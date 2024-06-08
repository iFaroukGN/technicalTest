//
//  CarAPI.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import Foundation

protocol CarDatasourceProtocol: AnyObject {
	func fetchCars() async throws -> [Car]
}

class CarAPI: CarDatasourceProtocol {
	let apiCall: APICall
	
	init(apiCall: APICall = .init()) {
		self.apiCall = apiCall
	}
	
	func fetchCars() async throws -> [Car] {
		try await apiCall.decodeRequest(CarAPIEndpoints.fetchCars.endpoint)
	}
	
	
}
