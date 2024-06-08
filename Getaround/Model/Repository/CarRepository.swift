//
//  CarRepository.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import Foundation

protocol CarRepositoryProtocol: AnyObject {
	func fetchCars() async throws -> [Car]
}

class CarRepository: CarRepositoryProtocol {
	let datasource: CarDatasourceProtocol!
	
	init(datasource: CarDatasourceProtocol = CarAPI()) {
		self.datasource = datasource
	}
	
	func fetchCars() async throws -> [Car] {
		try await datasource.fetchCars()
	}
}
