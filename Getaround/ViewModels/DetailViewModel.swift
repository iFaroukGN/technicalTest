//
//  DetailViewModel.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import Foundation

class DetailViewModel {
	let repository: FavoriteCarLocalRepositoryProtocol
	
	init(repository: FavoriteCarLocalRepositoryProtocol = FavoriteCarLocalRepository()) {
		self.repository = repository
	}
	
	func handleActionOnCar(_ car: Car) {
		if carIsFavorite(car: car) {
			repository.removeCar(car)
		} else {
			repository.insertCar(car)
		}
	}
	
	func carIsFavorite(car: Car) -> Bool {
		return car.isFavorite
	}
}
