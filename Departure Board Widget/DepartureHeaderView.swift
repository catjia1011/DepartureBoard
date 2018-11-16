//
//  DepartureHeaderView.swift
//  Departure Board Widget
//
//  Created by Cat Jia on 17/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit

class DepartureHeaderView: UIView {

    private let titleLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .gray)

    var title: String? {
        set { self.titleLabel.text = newValue }
        get { return self.titleLabel.text }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.font = .systemFont(ofSize: 11, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black.withAlphaComponent(0.9)
        titleLabel.allowsDefaultTighteningForTruncation = true
        self.addSubview(titleLabel)

        loadingIndicator.sizeToFit()
        loadingIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        self.addSubview(loadingIndicator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let insets = UIEdgeInsets(top: 0, left: layoutMargins.left, bottom: 0, right: layoutMargins.right)
        titleLabel.frame = self.bounds.inset(by: insets)
        loadingIndicator.frame.origin.x = self.bounds.inset(by: insets).maxX - loadingIndicator.frame.width
        loadingIndicator.center.y = titleLabel.center.y
    }

    func showLoading() {
        self.loadingIndicator.startAnimating()
    }

    func dismissLoading() {
        self.loadingIndicator.stopAnimating()
    }
}
