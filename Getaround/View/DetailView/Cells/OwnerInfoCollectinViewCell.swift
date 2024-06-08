//
//  OwnerInfoCollectinViewCell.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import SwiftUI

final class OwnerInfoCollectinViewCell: UICollectionViewListCell {
	enum Constants {
		static let imageHeight: CGFloat = 60.0
	}
	
	private weak var imageContainer: UIView!
	private weak var tagView: UIView!
	private weak var label: UILabel!
	private weak var ratingView: RatingView!
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
		let imageContainer = UIView()
		imageContainer.translatesAutoresizingMaskIntoConstraints = false
		imageContainer.layer.cornerRadius = Constants.imageHeight / 2
		imageContainer.clipsToBounds = true
		
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .headline)
		label.textColor = .label
		
		let ratingView = RatingView()
		
		let stackView = UIStackView(arrangedSubviews: [label, ratingView])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = 4
		stackView.alignment = .leading
		stackView.distribution = .fill
		
		addSubview(stackView)
		addSubview(imageContainer)
		
		self.stackView = stackView
		self.label = label
		self.ratingView = ratingView
		self.imageContainer = imageContainer
	}
	
	private func setupConstraints() {
		let viewsDictionary = ["stackView": stackView!,
							   "imageContainer": imageContainer!]
		
		let metricsDictionary: [String: Any] = ["imageWidth": Constants.imageHeight,
												"imageHeight": Constants.imageHeight]
		
		NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[imageContainer(==imageWidth)]-[stackView]|",
																   options: [.alignAllCenterY],
																   metrics: metricsDictionary,
																   views: viewsDictionary))
		
		
		NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[imageContainer(==imageHeight)]-8-|",
																   options: [],
																   metrics: metricsDictionary,
																   views: viewsDictionary))
	}
	
	func configure(with owner: Owner) {
		let hostingController = UIHostingController(rootView: CustomImageView(pictureURL: owner.pictureURL,
																			  displayKind: .thumbnail,
																			  isFavorite: false))
		
		if let imageView = hostingController.view {
			imageView.contentMode = .scaleAspectFit
			imageView.frame.size = .init(width: Constants.imageHeight, height: Constants.imageHeight)
			imageContainer.addSubview(imageView)
		}
		
		label.text = owner.name
		
		ratingView.configure(with: owner.rating, ratingCountIsHidden: true)
	}
}
