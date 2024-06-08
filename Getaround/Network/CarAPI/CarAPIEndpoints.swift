//
//  CarAPIEndpoints.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import Foundation

enum CarAPIEndpoints {
	case fetchCars
	
	var endpoint: URLRequest {
		switch self {
		case .fetchCars:
			let remoteURL = URL(string: "https://raw.githubusercontent.com/drivy/jobs/master/mobile/api/cars.json")!

			return URLRequest(url: remoteURL)
		}
	}
}
