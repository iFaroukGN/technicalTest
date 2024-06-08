//
//  Owner.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import Foundation

struct Owner: Hashable, Codable {
	let name: String
	let pictureURL: URL
	let rating: Rating

	enum CodingKeys: String, CodingKey {
		case name
		case pictureURL = "picture_url"
		case rating
	}
}
