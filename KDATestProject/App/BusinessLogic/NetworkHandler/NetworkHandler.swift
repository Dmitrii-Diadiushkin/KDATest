//
//  NetworkHandler.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 30.01.2023.
//

import Foundation

enum NetworkError: Error {
    case somethingWrong
}

final class NetworkHandler: NetworkHandlerProtocol {
    
    static let istance = NetworkHandler()
    
    private let accessToken = "NV2WxCozowyoqYv6PcCl4hlMOxufL5hNiBxi9BQUJ20"
    
    private let baseUrlConstructor: URLComponents = {
        var baseURLComponetns = URLComponents()
        baseURLComponetns.scheme = "https"
        baseURLComponetns.host = "api.unsplash.com"
        return baseURLComponetns
    }()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    private enum RequestType {
        case photosRequest
        case searchRequest
    }
    
    private init() {
        
    }
    
    private func configureURL(requestType: RequestType, queryRequest: String? = nil) -> URL? {
        switch requestType {
        case .photosRequest:
            var urlConstructor = baseUrlConstructor
            urlConstructor.path = "/photos"
            urlConstructor.queryItems = [
                URLQueryItem(name: "client_id", value: accessToken)
            ]
            let url = urlConstructor.url
            return url
        case .searchRequest:
            guard let queryRequest = queryRequest else { return nil }
            
            var urlConstructor = baseUrlConstructor
            urlConstructor.path = "/search/photos"
            urlConstructor.queryItems = [
                URLQueryItem(name: "client_id", value: accessToken),
                URLQueryItem(name: "query", value: queryRequest)
            ]
            let url = urlConstructor.url
            return url
        }
    }
    
    func getPhotos(completion: ((Swift.Result<[PhotosModel], NetworkError>) -> Void)? = nil) {
        guard let url = configureURL(requestType: .photosRequest) else {
            print("URL Error!")
            return
        }
        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        let urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 0)
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completion?(.failure(.somethingWrong))
                return
            }
            if let recievedData = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                do {
                    let json = try JSONDecoder().decode([PhotosModel].self, from: recievedData)
                    completion?(.success(json))
                } catch {
                    completion?(.failure(.somethingWrong))
                }
            } else {
                completion?(.failure(.somethingWrong))
                return
            }
        }
        task.resume()
    }
    
    func searchPhotos(
        query: String,
        completion: ((Swift.Result<[PhotosModel], NetworkError>) -> Void)? = nil
    ) {
        guard let url = configureURL(requestType: .searchRequest, queryRequest: query) else {
            print("URL Error!")
            return
        }
        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        let urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 0)
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completion?(.failure(.somethingWrong))
                return
            }
            if let recievedData = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                do {
                    let json = try JSONDecoder().decode(Welcome.self, from: recievedData).results
                    completion?(.success(json))
                } catch {
                    completion?(.failure(.somethingWrong))
                }
            } else {
                completion?(.failure(.somethingWrong))
                return
            }
        }
        task.resume()
    }
}
