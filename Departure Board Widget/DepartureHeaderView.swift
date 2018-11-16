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
    private let maskLayer = CAGradientLayer()

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

        maskLayer.colors = [UIColor.black, UIColor.black, UIColor.black.withAlphaComponent(0), UIColor.black.withAlphaComponent(0)].map { $0.cgColor }
        maskLayer.startPoint = CGPoint(x: 0, y: 0)
        maskLayer.endPoint = CGPoint(x: 1, y: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let insets = UIEdgeInsets(top: 0, left: layoutMargins.left, bottom: 0, right: layoutMargins.right)
        titleLabel.frame = self.bounds.inset(by: insets)
        maskLayer.frame = titleLabel.bounds
        loadingIndicator.frame.origin.x = self.bounds.inset(by: insets).maxX - loadingIndicator.frame.width
        loadingIndicator.center.y = titleLabel.center.y

        // set gradient locations
        let gradientWidth: CGFloat = 12
        let titleWidth = titleLabel.frame.width
        let indicatorWidth = loadingIndicator.frame.width
        let locations = [0, (titleWidth - indicatorWidth - gradientWidth), (titleWidth - indicatorWidth), titleWidth]
        if locations.sorted() == locations && indicatorWidth != 0 {
            maskLayer.locations = locations.map { $0 / titleWidth } as [NSNumber]
        } else {
            maskLayer.locations = [0, 1, 1, 1] as [NSNumber]
        }

        assert(maskLayer.colors != nil && maskLayer.locations?.count == maskLayer.colors?.count, "unexpected gradient setting")
    }

    func showLoading() {
        self.loadingIndicator.startAnimating()
        titleLabel.layer.mask = maskLayer
    }

    func dismissLoading() {
        self.loadingIndicator.stopAnimating()
        titleLabel.layer.mask = nil
    }
}
