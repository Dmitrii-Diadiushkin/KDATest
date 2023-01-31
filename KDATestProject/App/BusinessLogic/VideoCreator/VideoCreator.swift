//
//  VideoCreator.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 31.01.2023.
//

import AVFoundation
import CoreImage.CIFilterBuiltins
import PhotosUI
import UIKit

final class VideoCreator: VideoCreatorProtocol {
    private let imageUrls: ImagesForVideo
    private let dataManager: NetworkHandlerProtocol
    private var startImage: CIImage?
    private var finishImage: CIImage?
    private var frameSize: CGSize = CGSize(width: 960, height: 540)
    private var filter: CITransitionFilter?
    
    init(_ data: ImagesForVideo) {
        self.imageUrls = data
        self.dataManager = NetworkHandler.istance
    }
    
    func startVideoCreation(with filterType: EffectType, completion: @escaping ((Bool) -> Void)) {
        downloadImages { [weak self] result in
            if result {
                let ciFilter = filterType.getCIFilter()
                ciFilter.inputImage = self?.startImage
                ciFilter.targetImage = self?.finishImage
                self?.filter = ciFilter
                self?.createVideo { creationResult in
                    completion(creationResult)
                }
            } else {
                completion(false)
            }
        }
    }
}

private extension VideoCreator {
    
    func downloadImages(completion: @escaping ((Bool) -> Void)) {
        let gcdGroup = DispatchGroup()
        
        gcdGroup.enter()
        dataManager.downloadImage(url: imageUrls.sourceImage) { [weak self] result in
            switch result {
            case .success(let image):
                self?.startImage = self?.scaleImage(image)
            case .failure:
                break
            }
            gcdGroup.leave()
        }
        
        gcdGroup.enter()
        dataManager.downloadImage(url: imageUrls.targetImage) { [weak self] result in
            switch result {
            case .success(let image):
                self?.finishImage = self?.scaleImage(image)
            case .failure:
                break
            }
            gcdGroup.leave()
        }
        
        gcdGroup.notify(queue: DispatchQueue.global()) {
            if let stImage = self.startImage,
               stImage.extent.height > stImage.extent.width {
                self.frameSize = CGSize(width: 560, height: 940)
            }
            completion(true)
        }
    }
    
    func scaleImage(_ image: UIImage) -> CIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let scaleRatio: CGFloat
        let aspectRatio: CGFloat
        if ciImage.extent.height > ciImage.extent.width {
            scaleRatio = 940 / (ciImage.extent.height)
            aspectRatio = 560 / 940
        } else {
            scaleRatio = 540 / (ciImage.extent.width)
            aspectRatio = 960 / 540
        }
        let scaleFilter = CIFilter.lanczosScaleTransform()
        scaleFilter.inputImage = ciImage
        scaleFilter.scale = Float(scaleRatio)
        scaleFilter.aspectRatio = Float(aspectRatio)
        return scaleFilter.outputImage
    }
    
    func scaleImage(_ image: CIImage) -> CIImage? {
        let targetSize: CGSize
        
        if image.extent.height > image.extent.width {
            targetSize = CGSize(width: 560, height: 940)
        } else {
            targetSize = CGSize(width: 960, height: 540)
        }

        let scale = targetSize.height / (image.extent.height)
        let aspectRatio = targetSize.width/((image.extent.width) * scale)
        
        let scaleFilter = CIFilter.lanczosScaleTransform()
        scaleFilter.inputImage = image
        scaleFilter.scale = Float(scale)
        scaleFilter.aspectRatio = Float(aspectRatio)
        return scaleFilter.outputImage
    }
    
    func createVideo(completion: @escaping ((Bool) -> Void)) {
        var pixelBuffer: CVPixelBuffer?
        let attributes = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(frameSize.width),
            Int(frameSize.height),
            kCVPixelFormatType_32BGRA,
            attributes,
            &pixelBuffer
        )
        
        let context = CIContext()
        
        guard let unwrappedPixelBuffer = pixelBuffer,
              let startImage = startImage,
              let applyingFilter = filter
        else {
            completion(false)
            return
        }
        
        context.render(startImage, to: unwrappedPixelBuffer)
        
        guard let outputMovieURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
            .first?
            .appendingPathComponent("video.mov")
        else {
            completion(false)
            return
        }
        
        do {
            try FileManager.default.removeItem(at: outputMovieURL)
        } catch {
            print("Could not remove file \(error.localizedDescription)")
        }
        
        guard let assetWriter = try? AVAssetWriter(outputURL: outputMovieURL, fileType: .mov),
              var settingsAssistant = AVOutputSettingsAssistant(preset: .preset960x540)?.videoSettings else {
            completion(false)
            return
        }
        settingsAssistant["AVVideoHeightKey"] = frameSize.height
        settingsAssistant["AVVideoWidthKey"] = frameSize.width
        settingsAssistant["AVVideoScalingModeKey"] = AVVideoScalingModeResizeAspectFill
        let assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: settingsAssistant)
        let assetWriterAdaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: assetWriterInput,
            sourcePixelBufferAttributes: nil
        )
        assetWriter.add(assetWriterInput)
        
        assetWriter.startWriting()
        assetWriter.startSession(atSourceTime: CMTime.zero)
        
        let framesPerSecond = 30
        
        let totalFrames = 4 * framesPerSecond
        var frameCount = 0
        while frameCount < totalFrames {
            if assetWriterInput.isReadyForMoreMediaData {
                let frameTime = CMTimeMake(value: Int64(frameCount), timescale: Int32(framesPerSecond))
                let filterTime = Float(frameCount) / Float(totalFrames)
                applyingFilter.time = filterTime
                if let outputImage = applyingFilter.outputImage,
                   let filteredImage = scaleImage(outputImage) {
                    context.render(filteredImage, to: unwrappedPixelBuffer)
                }
                assetWriterAdaptor.append(unwrappedPixelBuffer, withPresentationTime: frameTime)
                frameCount += 1
            }
        }
        
        assetWriterInput.markAsFinished()
        assetWriter.finishWriting { [weak self] in
            pixelBuffer = nil
            self?.saveVideo(fileURL: outputMovieURL) { result in
                completion(result)
            }
        }
    }
    
    func saveVideo(fileURL: URL, completion: @escaping ((Bool) -> Void)) {
        if PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized {
            saveVideoToGallery(fileURL: fileURL) { saveResult in
                completion(saveResult)
            }
        } else {
            PHPhotoLibrary.requestAuthorization(
                for: .addOnly,
                handler: { [weak self] status in
                    if status == .authorized {
                        self?.saveVideoToGallery(fileURL: fileURL) { saveResult in
                            completion(saveResult)
                        }
                    } else {
                        completion(false)
                    }
                }
            )
        }
    }
    
    func saveVideoToGallery(fileURL: URL, completion: @escaping ((Bool) -> Void)) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
        }, completionHandler: { _, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        })
    }
}
