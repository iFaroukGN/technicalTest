//
//  HomeCarListView+CarHead.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import SwiftUI

extension HomeCarListView {
	struct CarHeadlineView: View {
		var brand: String
		var model: String
		var rating: Rating
		
		var body: some View {
			HStack {
				Text(
					String(format: "%@ %@", brand, model)
				)
				.font(.headline)
				
				Spacer()
				
				HStack(spacing: 2) {
					Image(systemName: "star.fill")
						.foregroundColor(.yellow)
					
					Text(rating.formattedAverage)
						.foregroundStyle(Color.secondary)
					
					Text("(\(rating.count))")
						.foregroundStyle(Color.secondary)
				}
			}
		}
	}
}
