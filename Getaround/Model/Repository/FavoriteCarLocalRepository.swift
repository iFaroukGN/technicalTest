//
//  FavoriteCarLocalRepository.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import Foundation

protocol FavoriteCarLocalRepositoryProtocol: AnyObject {
	func retrieveCar(_ car: Car) -> Car?
	func insertCar(_ car: Car)
	func removeCar(_ car: Car)
}

class FavoriteCarLocalRepository: FavoriteCarLocalRepositoryProtocol {
	let userDefault: UserDefaults = .standard
	
	func retrieveCar(_ car: Car) -> Car? {
		if let car = UserDefaults.standard.value(forKey: car.id.uuidString) as? Data {
			return try? PropertyListDecoder().decode(Car.self, from: car)
		}
		
		return nil
	}
	
	func insertCar(_ car: Car) {
		UserDefaults.standard.set(try? PropertyListEncoder().encode(car), forKey: car.id.uuidString)
	}
	
	func removeCar(_ car: Car) {
		UserDefaults.standard.removeObject(forKey: car.id.uuidString)
	}
}
