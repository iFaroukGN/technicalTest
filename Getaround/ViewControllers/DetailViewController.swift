//
//  DetailViewController.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import UIKit
import SwiftUI

protocol DetailViewControllerDelegate: AnyObject {
	func detailViewControllerDelegateDidTapOnFavButton(_ viewcontroller: DetailViewController, car: Car)
}

class DetailViewController: UIViewController {
	enum Constants {
		static let imageHeight: CGFloat = 250
	}
	
	private weak var collectionView: UICollectionView!
	private weak var rightBarButtonItem: UIBarButtonItem!
	
	private var car: Car
	private var viewModel: DetailViewModel
	private var diffableDatasource: UICollectionViewDiffableDataSource<Section, Item>!
	
	weak var delegate: DetailViewControllerDelegate!
	
	init(car: Car, viewModel: DetailViewModel = .init()) {
		self.car = car
		self.viewModel = viewModel
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		
		configureDatasource()
		
		applySnapshot()
	}
	
	private func favoriteAction() -> UIAction {
		return UIAction { [weak self] _ in
			guard let self = self else {
				return
			}
			
			viewModel.handleActionOnCar(car)
			
			rightBarButtonItem.image = UIImage(systemName: viewModel.carIsFavorite(car: car) ? "suit.heart.fill" : "suit.heart")
			
			delegate?.detailViewControllerDelegateDidTapOnFavButton(self, car: car)
		}
	}
	
	private func setupViews() {
		view.backgroundColor = .systemBackground
		
		navigationItem.largeTitleDisplayMode = .never
		
		let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: viewModel.carIsFavorite(car: car) ? "suit.heart.fill" : "suit.heart"),
												 primaryAction: favoriteAction())
		
		navigationItem.rightBarButtonItem = rightBarButtonItem
		
		let collectionView = UICollectionView(frame: view.bounds,
											  collectionViewLayout: createLayout())
		collectionView.alwaysBounceVertical = true
		collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		collectionView.backgroundColor = .systemBackground
		collectionView.delegate = self
		
		view.addSubview(collectionView)
		
		self.rightBarButtonItem = rightBarButtonItem
		self.collectionView = collectionView
	}
	
	private func createLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { [unowned self] sectionIndex, environment -> NSCollectionLayoutSection? in
			
			guard let section = self.diffableDatasource.sectionIdentifier(for: sectionIndex) else {
				return nil
			}
			
			switch section {
			case .header:
				let itemSize = NSCollectionLayoutSize(
					widthDimension: .fractionalWidth(1.0),
					heightDimension: .fractionalHeight(1.0)
				)
				
				let item = NSCollectionLayoutItem(layoutSize: itemSize)
				item.contentInsets = .zero
				
				let groupSize = NSCollectionLayoutSize(
					widthDimension: .fractionalWidth(1.0),
					heightDimension: .estimated(Constants.imageHeight)
				)
				
				let group = NSCollectionLayoutGroup.horizontal(
					layoutSize: groupSize,
					repeatingSubitem: item,
					count: 1
				)
				
				let section = NSCollectionLayoutSection(group: group)
				section.contentInsets = .zero
				
				return section
				
			case .rental,
					.owner:
				var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
				configuration.backgroundColor = .systemBackground
				configuration.headerMode = (section == .owner) ? .supplementary : .none
				configuration.headerTopPadding = (section == .owner) ? 10 : .zero
				
				let sectionLayout = NSCollectionLayoutSection.list(using: configuration,
																   layoutEnvironment: environment)
				return sectionLayout
			}
		}
		
		return layout
	}
	
	private func applySnapshot() {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
		
		snapshot.appendSections([.header,
								 .rental,
								 .owner])
		
		snapshot.appendItems([.carImage(car.pictureURL)],
							 toSection: .header)
		
		
		snapshot.appendItems([.rentalInfo(car)],
							 toSection: .rental)
		
		snapshot.appendItems([.ownerInfo(car.owner)],
							 toSection: .owner)
		
		diffableDatasource.apply(snapshot, animatingDifferences: false)
	}
	
	private func configureDatasource() {
		let carImageCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, URL> { [unowned self] cell, _ , pictureURL in
			cell.contentConfiguration = UIHostingConfiguration {
				CustomImageView(pictureURL: pictureURL,
								displayKind: .detail,
								isFavorite: self.viewModel.carIsFavorite(car: self.car))
				.frame(height: Constants.imageHeight)
			}
		}
		
		let carInfoCellRegistration = UICollectionView.CellRegistration<CarInfoCollectionViewCell, Car> { cell, _ , car in
			cell.configure(with: car)
		}
		
		let ownerInfoCellRegistration = UICollectionView.CellRegistration<OwnerInfoCollectinViewCell, Owner> { cell, _ , owner in
			cell.layer.borderWidth = 1.0
			cell.layer.borderColor = UIColor.quaternaryLabel.cgColor
			cell.accessories = [.disclosureIndicator()]
			
			cell.configure(with: owner)
		}
		
		diffableDatasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
			
			switch itemIdentifier {
			case .carImage(let pictureURL):
				return collectionView.dequeueConfiguredReusableCell(using: carImageCellRegistration,
																	for: indexPath,
																	item: pictureURL)
			case .rentalInfo(let car):
				return collectionView.dequeueConfiguredReusableCell(using: carInfoCellRegistration,
																	for: indexPath,
																	item: car)
			case .ownerInfo(let owner):
				return collectionView.dequeueConfiguredReusableCell(using: ownerInfoCellRegistration,
																	for: indexPath,
																	item: owner)
			}
		}
		
		let sectionHeaderReusableViewRegistration = UICollectionView.SupplementaryRegistration<HeaderReusableView>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] reusableView, _, indexPath in
			
			guard let self = self else {
				return
			}
			
			let section = self.diffableDatasource.sectionIdentifier(for: indexPath.section)
			
			reusableView.configure(with: section?.title)
		}
		
		diffableDatasource.supplementaryViewProvider = { collectionView, identifier, indexPath -> UICollectionReusableView? in
			switch identifier {
			case UICollectionView.elementKindSectionHeader:
				return collectionView.dequeueConfiguredReusableSupplementary(using: sectionHeaderReusableViewRegistration,
																			 for: indexPath)
				
			default:
				fatalError("unknown supplementary view kind")
			}
		}
	}
}

extension DetailViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		guard let item = diffableDatasource.itemIdentifier(for: indexPath) else {
			return false
		}
		
		return item.canInteract
	}
}

extension DetailViewController {
	enum Section: Hashable {
		case header
		case rental
		case owner
		
		var title: String? {
			switch self {
			case .header,
					.rental:
				return nil
				
			case .owner:
				return "Owner"
			}
		}
	}
	
	enum Item: Hashable {
		case carImage(URL)
		case rentalInfo(Car)
		case ownerInfo(Owner)
		
		var canInteract: Bool {
			switch self {
			case .carImage,
					.rentalInfo,
					.ownerInfo:
				return false
			}
		}
	}
}

