//
//  RatingView.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import UIKit

class RatingView: UIView {
	private weak var mainStackView: UIStackView!
	private weak var stackView: UIStackView!
	private weak var labelAverage: UILabel!
	private weak var labelCount: UILabel!
	
	private var configuration: RatingViewConfiguration!

	init(configuration: RatingViewConfiguration = RatingViewConfiguration.defaultConfiguration()) {
		super.init(frame: .zero)
		
		self.configuration = configuration
		setupView()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupView() {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		
		let labelAverage = UILabel()
		labelAverage.textColor = UIColor.secondaryLabel
		labelAverage.font = UIFont.preferredFont(forTextStyle: .body)
		
		let labelCount = UILabel()
		labelCount.textColor = UIColor.secondaryLabel
		labelCount.font = UIFont.preferredFont(forTextStyle: .body)
		
		let mainStackView = UIStackView(arrangedSubviews: [stackView, labelAverage, labelCount])
		mainStackView.translatesAutoresizingMaskIntoConstraints = false
		mainStackView.axis = .horizontal
		
		addSubview(mainStackView)
		
		self.stackView = stackView
		self.mainStackView = mainStackView
		self.labelCount = labelCount
		self.labelAverage = labelAverage
	}
	
	private func setupConstraints() {
		let viewDictionary = ["mainStackView": mainStackView!]
		
		NSLayoutConstraint.activate(
			NSLayoutConstraint.constraints(withVisualFormat: "H:|[mainStackView]|",
										   options: [],
										   metrics: nil,
										   views: viewDictionary)
		)
		
		NSLayoutConstraint.activate(
			NSLayoutConstraint.constraints(withVisualFormat: "V:|[mainStackView]|",
										   options: [],
										   metrics: nil,
										   views: viewDictionary)
		)
	}
	
	func configure(with rating: Rating, ratingCountIsHidden: Bool = false) {
		labelAverage.text = rating.formattedAverage
		labelCount.text =  "(\(rating.count))"
		
		var ratings = rating.ratingDict
		
		while ratings.count < configuration.maxRating {
			ratings.append(.empty)
		}
		
		ratings.forEach { state in
			let imageView = UIImageView(image: state.image)
			imageView.tintColor = configuration.color
			
			UIView.animate(withDuration: 0.3) { [weak self] in
				guard let self = self else {
					return
				}
				
				self.labelCount.isHidden = ratingCountIsHidden
				self.stackView.addArrangedSubview(imageView)
				
			}
		}
	}
}

extension RatingView {
	struct RatingViewConfiguration {
		let maxRating: Int
		let color: UIColor
		
		init(maxRating: Int, color: UIColor) {
			self.maxRating = maxRating
			self.color = color
		}
		
		static func defaultConfiguration() -> Self {
			return .init(maxRating: 5, color: .systemYellow)
		}
	}
}

extension Rating.State {
	var image: UIImage {
		switch self {
		case .empty:
			return UIImage(systemName: "star")!
		case .half:
			return UIImage(systemName: "star.leadinghalf.filled")!
		case .filled:
			return UIImage(systemName: "star.fill")!
		}
	}
}
