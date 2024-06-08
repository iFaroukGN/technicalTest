//
//  Rating.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import Foundation

struct Rating: Hashable, Codable {
	let average: Double
	let count: Int
	
	var formattedAverage: String {
		return average.formatted(
			.number
				.precision(.significantDigits(2))
				.rounded(rule: .down)
		)
	}

	var ratingDict: [State] {
		guard count > 0 else {
			return []
		}
		
		let ratedValue = Int(average)
		let other = average.truncatingRemainder(dividingBy: 1)
		
		var ratings: [State] = []
		
		if ratedValue > 0 {
			(1 ... ratedValue).forEach { _ in
				ratings.append(.filled)
			}
		}
		
		ratings.append(other < 0.5 ? .empty : .half)

		return ratings
	}
}

extension Rating {
	enum State {
		case empty
		case half
		case filled
	}
}
