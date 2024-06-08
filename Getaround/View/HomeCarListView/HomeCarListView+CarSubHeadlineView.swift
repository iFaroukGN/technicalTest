//
//  HomeCarListView+CarSubHeadlineView.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import SwiftUI

extension HomeCarListView {
	struct CarSubHeadlineView: View {
		var pricePerDay: String
		
		var body: some View {
			HStack(spacing: 2) {
				Text(pricePerDay)
					.font(.subheadline)
					.bold()
				
				Text("per day")
					.font(.body)
				
				Spacer()
			}
		}
	}
}
