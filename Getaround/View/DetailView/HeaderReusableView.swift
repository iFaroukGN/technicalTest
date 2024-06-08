//
//  HeaderReusableView.swift
//  Getaround
//
//  Created by Farouk GNANDI on 07/06/2024.
//

import UIKit

final class HeaderReusableView: UICollectionReusableView {
	
	private weak var label: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupViews()
		
		setupConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .left
		label.textColor = .label
		label.font = UIFont.preferredFont(forTextStyle: .title2)
		
		self.label = label
		
		addSubview(label)
	}
	
	private func setupConstraints() {
		let viewsDictionary = ["label": label!]
		
		NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]-10-|",
																   options: [],
																   metrics: nil,
																   views: viewsDictionary))
		
		NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|",
																   options: [],
																   metrics: nil,
																   views: viewsDictionary))
	}
	
	func configure(with title: String?) {
		label.text = title
	}
}
