//
//  SearchTableViewCell.swift
//  Foody CookBook
//
//  Created by Shubham Arora on 11/05/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var searchImageview: UIImageView!
    
    // Variable
    internal var imageData: ImagesViewModel! {
        didSet {
            searchImageview.sd_setImage(with: URL(string: imageData.userImageURL), placeholderImage: nil)
            lblName.text = imageData.user
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnFavourite.isHidden = true
        btnFavourite.setImage(UIImage(systemName: "star.fill"), for: .selected)
        btnFavourite.setImage(UIImage(systemName: "star"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
