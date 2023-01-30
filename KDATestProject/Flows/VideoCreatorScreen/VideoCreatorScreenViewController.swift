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
    }
    
    func setupViews() {
        view.backgroundColor = .white
        setupHeaderView()
        setupNextButton()
        setupCollectionView()
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
