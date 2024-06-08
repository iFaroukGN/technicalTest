//
//  CarViewItem.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import SwiftUI

struct HomeCarListView: View {
	var car: Car
	var favActionHandler: () -> Void
	
	var body: some View {
		VStack {
			CustomImageView(
				pictureURL: car.pictureURL,
				displayKind: .`default`, 
				isFavorite: car.isFavorite, 
				actionHandler: { favActionHandler() }
			)
			.padding(.bottom, 4)
			
			CarHeadlineView(
				brand: car.brand,
				model: car.model,
				rating: car.rating
			)
			.padding(.leading, 4)
			.padding(.trailing, 4)
			
			CarSubHeadlineView(
				pricePerDay: car.formattedPrice
			)
			.padding(.leading, 4)
			.padding(.bottom, 4)
		}
	}
}
