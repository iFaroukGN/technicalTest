//
//  CarRentalPriceView.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import UIKit

final class CarRentalPriceView: UIView {
	private weak var pricelabel: UILabel!
	private weak var dayLabel: UILabel!
	private weak var stackView: UIStackView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupViews()
		
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		backgroundColor = .secondarySystemGroupedBackground

		let pricelabel = UILabel()
		pricelabel.font = UIFont.boldSystemFont(ofSize: 30)
		pricelabel.textColor = .label
		
		let dayLabel = UILabel()
		dayLabel.font = UIFont.preferredFont(forTextStyle: .body)
		dayLabel.textColor = .secondaryLabel
		
		let stackView = UIStackView(arrangedSubviews: [pricelabel, dayLabel])
		stackView.layoutMargins = .init(top: 5, left: 10, bottom: 5, right: 10)
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .fillProportionally
		
		addSubview(stackView)
		
		self.stackView = stackView
		self.pricelabel = pricelabel
		self.dayLabel = dayLabel
	}
	
	private func setupConstraints() {
		let viewsDictionary = ["stackView": stackView!]
		
		
		NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|",
																   options: [],
																   metrics: nil,
																   views: viewsDictionary))
		
		NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[stackView]-|",
																   options: [],
																   metrics: nil,
																   views: viewsDictionary))
	}
	
	func configure(with price: String, layerIshidden: Bool = false) {
		pricelabel.text = price
		dayLabel.text = "per day"
		
		if layerIshidden {
			layer.borderWidth = 0.0
		} else {
			layer.borderWidth = 1.0
			layer.cornerRadius = 10.0
			layer.borderColor = UIColor.quaternaryLabel.cgColor
		}
	}
}
