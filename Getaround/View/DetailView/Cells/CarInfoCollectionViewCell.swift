//
//  CarInfoCollectionViewCell.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import UIKit

final class CarInfoCollectionViewCell: UICollectionViewListCell {
	private weak var label: UILabel!
	private weak var ratingView: RatingView!
	private weak var stackView: UIStackView!
	private weak var carRentalPriceView: CarRentalPriceView!
	private weak var button: UIButton!
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupViews()
		
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		contentView.backgroundColor = .systemBackground
		
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 24)
		label.textColor = .label
		label.numberOfLines = 1
		
		let ratingView = RatingView()
		
		let stackView = UIStackView(arrangedSubviews: [label, ratingView])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .leading
		stackView.distribution = .fill
		stackView.layoutMargins = .init(top: 15, left: 0, bottom: 15, right: 0)
		stackView.isLayoutMarginsRelativeArrangement = true
		
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
		button.tintColor = .systemPink
		
		let carRentalPriceView = CarRentalPriceView()
		carRentalPriceView.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(stackView)
		addSubview(carRentalPriceView)
		addSubview(button)
		
		self.stackView = stackView
		self.label = label
		self.ratingView = ratingView
		self.button = button
		self.carRentalPriceView = carRentalPriceView
	}
	
	private func setupConstraints() {
		let viewsDictionary = ["stackView": stackView!,
							   "carRentalPriceView": carRentalPriceView!,
							   "button": button!]
		
		
		NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]->=0-[carRentalPriceView]|",
																   options: [],
																   metrics: nil,
																   views: viewsDictionary))
		
		NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[stackView]-|",
																   options: [],
																   metrics: nil,
																   views: viewsDictionary))
		
		NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[carRentalPriceView]|",
																   options: [],
																   metrics: nil,
																   views: viewsDictionary))
		
		
		NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[button(==18)]",
																   options: [],
																   metrics: nil,
																   views: viewsDictionary))
		
		NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[button(==18)]-2-|",
																   options: [],
																   metrics: nil,
																   views: viewsDictionary))
	}
	
	func configure(with car: Car) {
		configure(with: "\(car.brand) \(car.model)", and: car.rating)
		
		configureCarRentalPriceView(with: car.formattedPrice)
	}
	
	private func configure(with name: String, and rating: Rating) {
		label.text = name
		ratingView.configure(with: rating)
	}
	
	private func configureCarRentalPriceView(with price: String) {
		carRentalPriceView.configure(with: price)
	}
}
