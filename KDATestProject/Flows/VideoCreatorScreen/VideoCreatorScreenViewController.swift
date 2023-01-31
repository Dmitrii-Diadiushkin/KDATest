//
//  VideoCreatorScreenViewController.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 30.01.2023.
//

import Combine
import UIKit

final class VideoCreatorScreenViewController: UIViewController {
    private let viewModel: VideoCreatorViewModelProtocol
    
    private let headerView = VideoCreatorScreenHeaderView()
    private let collectionView: UICollectionView
    private let nextButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .black
        view.alpha = 0.4
        view.setTitle("Next", for: .normal)
        view.layer.cornerRadius = 12.0
        view.clipsToBounds = true
        view.isEnabled = false
        return view
    }()
    
    private let blurView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.isHidden = true
        return view
    }()
    
    private let progressAlert: UIAlertController = {
        let view = UIAlertController(
            title: "Video prossecing",
            message: "Wait a little bit",
            preferredStyle: .alert
        )
        let indicator = UIActivityIndicatorView(style: .large)
        view.view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.view.snp.bottom).inset(33.37)
            make.height.width.equalTo(41.25)
        }
        view.view.snp.makeConstraints { make in
            make.height.equalTo(180.0)
        }
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        return view
    }()
    
    private let successAlert: UIAlertController = {
        let view = UIAlertController(
            title: "It's done",
            message: "Video successfully saved to your gallery",
            preferredStyle: .alert
        )
        return view
    }()
    
    private let failureAlert: UIAlertController = {
        let attributedString = NSAttributedString(
            string: "Error",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.red
            ]
        )
        let view = UIAlertController(
            title: "",
            message: "Failed to save video ",
            preferredStyle: .alert
        )
        view.setValue(attributedString, forKey: "attributedTitle")
        return view
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, EffectTypeModelToShow>! = nil
    
    private var bag = Set<AnyCancellable>()
    
    init(viewModel: VideoCreatorViewModelProtocol) {
        self.viewModel = viewModel
        let layout = LayoutFactory.createLayout()
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        super.init(nibName: nil, bundle: nil)
        configureDataSource()
        setupViews()
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }
}

private extension VideoCreatorScreenViewController {
    func binding() {
        viewModel.effectDataPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] recievedData in
                guard let self = self else { return }
                self.loadData(with: recievedData)
            }
            .store(in: &bag)
        
        viewModel.creatorStateDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .inProgress:
                    self.blurView.isHidden = false
                    self.present(self.progressAlert, animated: false)
                case .success:
                    self.progressAlert.dismiss(animated: false)
                    self.present(self.successAlert, animated: false)
                case .failure:
                    self.progressAlert.dismiss(animated: false)
                    self.present(self.failureAlert, animated: false)
                }
            }
            .store(in: &bag)
    }
    
    func setupViews() {
        view.backgroundColor = .white
        setupHeaderView()
        setupNextButton()
        setupCollectionView()
        setupBlurView()
        setupAlerts()
    }
    
    func setupHeaderView() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16.0)
            make.top.equalTo(headerView.snp.bottom).offset(24.0)
            make.bottom.equalTo(nextButton.snp.top).inset(-24.0)
        }
    }
    
    func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(56.0)
            make.height.equalTo(52.0)
        }
        nextButton.addTarget(self, action: #selector(handleNextButtonTap), for: .touchUpInside)
    }
    
    func setupBlurView() {
        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupAlerts() {
        successAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.closeBlurView()
        }))
        failureAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.closeBlurView()
        }))
    }
    
    func closeBlurView() {
        blurView.isHidden = true
    }
    
    @objc func handleNextButtonTap() {
        if let selectedCell = collectionView.indexPathsForSelectedItems?.first?.item {
            viewModel.tapNextButton(with: selectedCell)
        }
    }
    
    @objc func handleBackButtonTap(_ sender: UIButton) {
        viewModel.onPreviousScreen?()
    }
    
    func configureDataSource() {
        let cellRegistration = makeCellRegistration()
        dataSource = UICollectionViewDiffableDataSource<Int, EffectTypeModelToShow>(
            collectionView: collectionView
        ) { collectionView, indexPath, item -> UICollectionViewCell? in
            let cell = collectionView
                .dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: item
                )
            return cell
        }
    }

    typealias EffectCellRegistration = UICollectionView
        .CellRegistration<VideoCreatorScreenEffectCell, EffectTypeModelToShow>

    func makeCellRegistration() -> EffectCellRegistration {
        return EffectCellRegistration { cell, _, item in
            cell.configureCell(with: item)
        }
    }

    func loadData(with data: [EffectTypeModelToShow]) {
        var currentSnapshot = NSDiffableDataSourceSnapshot<Int, EffectTypeModelToShow>()
        currentSnapshot.appendSections([0])
        currentSnapshot.appendItems(data)
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

extension VideoCreatorScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? VideoCreatorScreenEffectCell {
            cell.toggleSelection(true)
            if !nextButton.isEnabled {
                nextButton.alpha = 1.0
                nextButton.isEnabled = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? VideoCreatorScreenEffectCell {
            cell.toggleSelection(false)
        }
    }
}
