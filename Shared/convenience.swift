//
//  convenience.swift
//  iFund
//
//  Created by Cat Jia on 22/2/2017.
//  Copyright © 2017 Initium Media. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    static let trickyZeroDimension = 0.01 as CGFloat

    func register<T: UITableViewCell>(cellType: T.Type) {
        self.register(cellType, forCellReuseIdentifier: NSStringFromClass(cellType))
    }

    func dequeue<T: UITableViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: NSStringFromClass(cellType), for: indexPath) as! T
    }

    func register<T: UITableViewHeaderFooterView>(headerFooterType: T.Type) {
        self.register(headerFooterType, forHeaderFooterViewReuseIdentifier: NSStringFromClass(headerFooterType))
    }

    func dequeue<T: UITableViewHeaderFooterView>(headerFooterType: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(headerFooterType)) as! T
    }
}


extension UIColor {
    static let appleBlue: UIColor = UIColor(red: 0, green: 122.0 / 255, blue: 255.0 / 255, alpha: 1)
}


enum Result<Value> {
    case success(Value)
    case failure(Error)
}
