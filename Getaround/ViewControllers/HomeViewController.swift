//
//  HomeViewController.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import UIKit
import Combine
import SwiftUI

class HomeViewController: UIViewController {
	private let viewModel: HomeViewModel
	private var diffableDatasource: UICollectionViewDiffableDataSource<Section, Item>!
	
	private weak var collectionView: UICollectionView!
	private weak var rightBarButtonItem: UIBarButtonItem!
	
	private var disposables: Set<AnyCancellable> = []
	
	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Rentable cars"
		
		setupViews()
		
		configureDatasource()
		
		bindViewModel()
	}

	private func setupViews() {
		view.backgroundColor = .systemBackground
		
		let hightFirstAction = UIAction(title: "Best rating", 
										image: UIImage(systemName: "arrow.up")) { [weak self] _ in
			guard let self = self else {
				return
			}
			self.viewModel.sortCarsBy(order: .best)
		}
		
		let lowFirstAction = UIAction(title: "Worst rating", 
									  image: UIImage(systemName: "arrow.down")) { [weak self] _ in
			guard let self = self else {
				return
			}
			self.viewModel.sortCarsBy(order: .worst)
		}
		
		let rightBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
			menu: UIMenu(
				title: "Sort cars",
				children: [hightFirstAction,
						   lowFirstAction])
		)
		
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
			case .main:
				var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
				configuration.backgroundColor = .systemGroupedBackground
				
				let sectionLayout = NSCollectionLayoutSection.list(using: configuration,
																   layoutEnvironment: environment)
				return sectionLayout
			}
		}
		
		return layout
	}

	private func bindViewModel() {
		viewModel.fetchCars()
		
		viewModel
			.$cars
			.receive(on: DispatchQueue.main)
			.sink { [weak self] cars in
				guard let self = self else {
					return
				}
				
				self.applySnapshot(with: cars)
			}
			.store(in: &disposables)
		
		viewModel
			.$isLoading
			.dropFirst()
			.receive(on: DispatchQueue.main)
			.sink { [unowned self] isLoading in
				if !isLoading {
					self.setNeedsUpdateContentUnavailableConfiguration()
				}
			}
		.store(in: &disposables)
		
		viewModel
			.$hasError
			.dropFirst()
			.receive(on: DispatchQueue.main)
			.sink { [unowned self] _ in
				self.setNeedsUpdateContentUnavailableConfiguration()
			}
			.store(in: &disposables)
	}
	
	private func applySnapshot(with cars: [Car]) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
		
		cars
			.map(Item.car)
			.forEach { item in
				let section = Section.main()
				
				snapshot.appendSections([section])
				
				snapshot.appendItems([item],
									 toSection: section)
			}
		
		diffableDatasource.apply(snapshot, animatingDifferences: false)
	}
	
	private func reloadCell(with item: Car) {
		var snapshot = diffableDatasource.snapshot()

		snapshot.reloadItems([.car(car: item)])

		self.diffableDatasource.apply(snapshot)
	}
	
	private func configureDatasource() {
		let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Car> { cell, _ , car in
			
			cell.contentConfiguration = UIHostingConfiguration {
				HomeCarListView(car: car) { [weak self] in
					guard let self = self else {
						return
					}
					
					self.viewModel.handleActionOnCar(car)
					
					self.reloadCell(with: car)
				}
				.swipeActions { [unowned self] in
					Button {
						self.viewModel.handleActionOnCar(car)
						
						self.reloadCell(with: car)
					} label: {
						if car.isFavorite {
							Text("Remove as favorite")
						} else {
							Text("Mark as favorite")
						}
						
					}
					.tint(.pink.opacity(0.3))
				}
			}
			.margins(.all, .zero)
		}
		
		diffableDatasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
			switch itemIdentifier {
			case .car(let car):
				return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
																	for: indexPath,
																	item: car)
			}
		}
	}
	
	override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
		var config: UIContentUnavailableConfiguration?
		if viewModel.hasError {
			var empty = UIContentUnavailableConfiguration.empty()
			empty.background.backgroundColor = .systemBackground
			empty.image = UIImage(systemName: "xmark.octagon")
			empty.text = "Oups"
			empty.secondaryText = "Something went wrong"
			config = empty
			contentUnavailableConfiguration = config
		} else if viewModel.isLoading {
			var loading = UIContentUnavailableConfiguration.loading()
			loading.text = "Loading..."
			config = .loading()
			contentUnavailableConfiguration = config
		} else {
			contentUnavailableConfiguration = nil
		}
	}
}

extension HomeViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let item = diffableDatasource.itemIdentifier(for: indexPath) else {
			return
		}
		
		switch item {
		case .car(let car):
			let detailViewController = DetailViewController(car: car)
			detailViewController.delegate = self
			navigationController?.pushViewController(detailViewController, animated: true)
		}
	}
}

extension HomeViewController: DetailViewControllerDelegate {
	func detailViewControllerDelegateDidTapOnFavButton(_ viewcontroller: DetailViewController, car: Car) {
		reloadCell(with: car)
	}
}

extension HomeViewController {
	enum Section: Hashable {
		case main(uuid: UUID = UUID())
	}
	
	enum Item: Hashable {
		case car(car: Car)
	}
}
