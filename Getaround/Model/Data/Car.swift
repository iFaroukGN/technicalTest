//
//  Car.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import Foundation

struct Car: Hashable, Codable {
	let id: UUID = UUID()
	
	let brand: String
	let model: String
	let pictureURL: URL
	let pricePerDay: Int
	let rating: Rating
	let owner: Owner

	var isFavorite: Bool {
		return (UserDefaults.standard.value(forKey: id.uuidString) as? Data) !=  nil
	}
	
	var formattedPrice: String {
		return pricePerDay.formatted(
			.currency(code: "eur")
			.precision(.significantDigits(1))
		)
	}
		
	enum CodingKeys: String, CodingKey {
		case brand
		case model
		case pictureURL = "picture_url"
		case pricePerDay = "price_per_day"
		case rating
		case owner
	}
}

extension Car {
	static func fakeObject() -> Car {
		.init(brand: "String",
			  model: "String",
			  pictureURL: URL(string: "https://raw.githubusercontent.com/drivy/jobs/master/mobile/api/pictures/6.jpg")!,
			  pricePerDay: 20,
			  rating: .init(average: 4.3, 
							count: 30),
			  owner: .init(name: "abalo",
						   pictureURL: URL(string: "https://getaround-assets.gumlet.io/jobs/team/jack.jpg")!,
						   rating: .init(average: 1.2, count: 2)))
	}
}
