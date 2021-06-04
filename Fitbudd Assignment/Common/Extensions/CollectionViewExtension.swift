//
//  CollectionViewExtension.swift
//  Fitbudd Assignment
//
//  Created by Shubham Arora on 04/06/21.
//

import UIKit

public extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 1
        messageLabel.textAlignment = .center
        messageLabel.font = Font.Bold.of(size: 25)
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
    
    func register<T: UICollectionViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = String(describing: cellType)
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        let className = String(describing: type)
        return dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as! T
    }
}
