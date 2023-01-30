//
//  MainViewController.swift
//  KDATestProject
//
//  Created by Dmitrii Diadiushkin on 29.01.2023.
//

import Combine
import SnapKit
import UIKit

final class MainViewController: UIViewController {
    private let viewModel: MainScreenViewModelProtocol
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, PhotosModelToShow>! = nil
    private var tapGesture: UITapGestureRecognizer
    
    
    private var selectedCounter: Int = 0 {
        didSet {
            if selectedCounter == 2 {
                nextButton.isHidden = false
            } else {
                nextButton.isHidden = true
            }
        }
    }
    
    private var dataToShow: [PhotosModelToShow] = [] {
        didSet {
            loadData()
        }
    }
    
    private var bag = Set<AnyCancellable>()
    
    private let headerView = MainHeaderView()
    private let collectionView: UICollectionView
    private let nextButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Next", for: .normal)
        view.backgroundColor = .black
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    init(viewModel: MainScreenViewModelProtocol) {
        self.viewModel = viewModel
        let layout = PinterestLayout()
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        tapGesture = UITapGestureRecognizer(
            target: headerView,
            action: #selector(headerView.handleTap)
        )
        super.init(nibName: nil, bundle: nil)
        
        layout.delegate = self
        setupViews()
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData()
    }
}

private extension MainViewController {
    func setupViews() {
        configureDataSource()
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        headerView.delegate = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview().inset(16.0)
            make.top.equalTo(headerView.snp.bottom).offset(24.0)
        }
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(56.0)
            make.height.equalTo(52.0)
        }
        nextButton.addTarget(self, action: #selector(handleNextButtonTap), for: .touchUpInside)
        nextButton.isHidden = true
    }
    
    func binding() {
        viewModel.photosDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { data in
                self.dataToShow = data
            }
            .store(in: &bag)
    }
    
    func configureDataSource() {
        let cellRegistration = makeCellRegistration()
        dataSource = UICollectionViewDiffableDataSource<Int, PhotosModelToShow>(
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

    typealias ImageCellRegistration = UICollectionView.CellRegistration<MainImageCell, PhotosModelToShow>

    func makeCellRegistration() -> ImageCellRegistration {
        return ImageCellRegistration { cell, _, item in
            cell.configureCell(with: item)
        }
    }

    func loadData() {
        var currentSnapshot = NSDiffableDataSourceSnapshot<Int, PhotosModelToShow>()
        currentSnapshot.appendSections([0])
        currentSnapshot.appendItems(dataToShow)
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    @objc func handleNextButtonTap() {
        viewModel.tappedNextButton(data: dataToShow)
    }
}

extension MainViewController: MainHeaderViewDelegate {
    func pressSearchButton(with string: String) {
        viewModel.needSearch(text: string)
    }
    
    func handleSearchStartStop(searchIsActive: Bool) {
        if searchIsActive {
            view.removeGestureRecognizer(tapGesture)
        } else {
            view.addGestureRecognizer(tapGesture)
        }
    }
}

extension MainViewController: PinterestLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        return dataToShow[indexPath.item].imageHeight
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MainImageCell {
            if selectedCounter < 2 {
                dataToShow[indexPath.item].isSelected.toggle()
                cell.toggleSelection(dataToShow[indexPath.item].isSelected)
                if dataToShow[indexPath.item].isSelected {
                    selectedCounter += 1
                } else {
                    selectedCounter -= 1
                }
            } else {
                if dataToShow[indexPath.item].isSelected {
                    dataToShow[indexPath.item].isSelected.toggle()
                    cell.toggleSelection(dataToShow[indexPath.item].isSelected)
                    selectedCounter -= 1
                }
            }
        }
    }
}
