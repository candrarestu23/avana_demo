//
//  HomeTableViewCell.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import UIKit

class HomeTableViewCell: BaseTableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
