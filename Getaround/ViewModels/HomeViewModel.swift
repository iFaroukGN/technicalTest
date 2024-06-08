//
//  HomeViewModel.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import Foundation
import Combine

class HomeViewModel {
	@Published var cars: [Car] = []
	@Published var isLoading = false
	@Published var hasError = false
	
	let repository: CarRepositoryProtocol
	let favoriteCarRepository: FavoriteCarLocalRepositoryProtocol
	
	init(repository: CarRepositoryProtocol = CarRepository(),
		 favoriteCarRepository: FavoriteCarLocalRepositoryProtocol = FavoriteCarLocalRepository()) {
		self.repository = repository
		self.favoriteCarRepository = favoriteCarRepository
	}
	
	func fetchCars() {
		Task { [weak self] in
			guard let self = self else {
				return
			}
			
			self.isLoading = true
			
			defer {
				self.isLoading = false
			}
			
			do {
				self.cars = try await repository.fetchCars()
				self.hasError = false
			} catch {
				self.hasError = true
			}
		}
	}
	
	func sortCarsBy(order: SortOrder) {
		switch order {
		case .best:
			cars = cars.sorted(by: { $0.rating.average > $1.rating.average })
		case .worst:
			cars = cars.sorted(by: { $0.rating.average < $1.rating.average })
		}
	}
	
	func handleActionOnCar(_ car: Car) {
		if carIsFavorite(car: car) {
			favoriteCarRepository.removeCar(car)
		} else {
			favoriteCarRepository.insertCar(car)
		}
	}
	
	func carIsFavorite(car: Car) -> Bool {
		return car.isFavorite
	}
}

extension HomeViewModel {
	enum SortOrder {
		case best
		case worst
	}
}
