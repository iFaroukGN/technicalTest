//
//  CustomImageView.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import SwiftUI

struct CustomImageView: View {
	var pictureURL: URL
	var displayKind: DisplayKind
	var isFavorite: Bool
	var actionHandler: (() -> Void)? = nil
	
	private var defaultHeight: CGFloat { 200 }
	
	var body: some View {
		AsyncImage(url: pictureURL) { phase in
			switch phase {
			case .failure:
				ZStack {
					Color
						.secondary
						.opacity(0.5)
					
					if displayKind == .`default` || displayKind == .detail {
						Image(systemName: displayKind.placeholder)
							.resizable()
							.scaledToFit()
							.foregroundColor(.pink)
							.frame(width: defaultHeight / 2 ,
								   height: defaultHeight / 2)
					} else {
						Image(systemName: displayKind.placeholder)
							.resizable()
							.scaledToFit()
							.foregroundColor(.pink)
							.frame(width: 24,
								   height: 24)
					}
				}
				.opacity(0.5)
				
			case .success(let image):
				ZStack(alignment: .topTrailing) {
					image
						.resizable()
						.scaledToFill()
					if displayKind == .`default` {
						Button {
							actionHandler?()
						} label: {
							Image(systemName: isFavorite ? "suit.heart.fill" : "suit.heart")
								.font(.title2)
						}
						.padding(.all, 10)
						.tint(.pink)
					}
				}
				
			case .empty:
				ZStack {
					Color
						.secondary
						.opacity(0.5)
					
					ProgressView()
				}
				.frame(height: defaultHeight)
				
			@unknown default:
				EmptyView()
			}
		}
	}
}

extension CustomImageView {
	enum DisplayKind {
		case `default`
		case detail
		case thumbnail
		
		var placeholder: String {
			switch self {
			case .`default`,
					.detail:
				return "car.fill"
			case .thumbnail:
				return "person.fill"
			}
		}
	}
}
