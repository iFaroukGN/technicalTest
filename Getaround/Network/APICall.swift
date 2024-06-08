//
//  APICall.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import Foundation

enum HttpMethod: String {
	case get
}

class APICall {
	let shared: URLSession = .shared
	
	func decodeRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
		do {
			let (data, response) = try await shared.data(for: request)
			
			guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
				fatalError("Error")
			}
			
			let result = try JSONDecoder().decode(T.self, from: data)
			
			let dataString = String(data: data, encoding: .utf8)
			
			print("dataString: \(dataString ?? "")")
			
			return result
			
		} catch DecodingError.dataCorrupted(let context) {
			print("DecodingError.dataCorrupted context: \(context)")
		} catch DecodingError.keyNotFound(let key, let context) {
			print("Key '\(key)' not found: \(context.debugDescription)")
			print("CodingPath:", context.codingPath)
		} catch DecodingError.valueNotFound(let value, let context) {
			print("Value '\(value)' not found: \(context.debugDescription)")
			print("CodingPath:", context.codingPath)
		} catch DecodingError.typeMismatch(let type, let context) {
			print("Type '\(type)' mismatch: \(context.debugDescription)")
			print("CodingPath:", context.codingPath)
		} catch {
			print("Some random error: \(error)")
		}
		
		fatalError("Something went wrong")
	}

	func request(url: URL, method: HttpMethod) -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		return request
	}
}

