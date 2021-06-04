//
//  SearchCollectionViewCell.swift
//  Fitbudd Assignment
//
//  Created by Shubham Arora on 05/06/21.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    // IBOutlet
    @IBOutlet weak var avatarImageView: UIImageView!
    
    // Variables
    internal var imageData: ImagesViewModel! {
        didSet {
            avatarImageView.sd_setImage(with: URL(string: imageData.userImageURL), placeholderImage: nil)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
