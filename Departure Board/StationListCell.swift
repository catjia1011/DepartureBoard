//
//  StationListCell.swift
//  Departure Board
//
//  Created by Cat Jia on 13/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit

protocol StationListCellDelegate: NSObjectProtocol {
    func stationListCell(_ cell: StationListCell, didUpdateSelectStatus isSelected: Bool, for direction: MTRLine.Direction) -> Void
}

class StationListCell: UITableViewCell {

    weak var delegate: StationListCellDelegate?

    private let stackView = UIStackView()
    private let buttons: [AddButton] = MTRLine.Direction.allCases.map { AddButton(direction: $0) }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        self.contentView.addSubview(stackView)

        for button in buttons {
            button.addTarget(self, action: #selector(didTapAddButton(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }

        self.prepareForReuse()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let textLabel = self.textLabel else {
            stackView.isHidden = true
            return
        }
        stackView.isHidden = false

        let spacing = 10 as CGFloat
        stackView.frame.size = CGSize(width: 120, height: 28)
        stackView.frame.origin.x = textLabel.frame.maxX - stackView.frame.width
        stackView.center.y = self.contentView.bounds.height / 2
        textLabel.frame.size.width -= (stackView.frame.width + spacing)
    }

    func setSelectedDirections(_ directions: [MTRLine.Direction]) {
        for button in buttons {
            button.isSelected = directions.contains(button.direction)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.delegate = nil
        for button in buttons {
            button.isSelected = false
        }
    }

    @objc private func didTapAddButton(_ button: AddButton) {
        button.isSelected.toggle()
        self.delegate?.stationListCell(self, didUpdateSelectStatus: button.isSelected, for: button.direction)
    }
}



private class AddButton: UIButton {
    static let defaultHeight = 28 as CGFloat

    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderWidth = 0
                self.layer.borderColor = UIColor.clear.cgColor
                self.layer.masksToBounds = true
                self.backgroundColor = .appleBlue
            } else {
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.appleBlue.cgColor
                self.layer.masksToBounds = false
                self.backgroundColor = .clear
            }
        }
    }

    let direction: MTRLine.Direction
    init(direction: MTRLine.Direction) {
        self.direction = direction
        super.init(frame: .zero)

        self.layer.cornerRadius = 4
        self.titleLabel?.font = .systemFont(ofSize: 13)
        self.setTitleColor(.appleBlue, for: .normal)
        self.setTitleColor(.white, for: .selected)
        self.setTitle(direction.title, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}