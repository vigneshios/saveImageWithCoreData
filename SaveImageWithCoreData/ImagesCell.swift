//
//  ImagesCell.swift
//  SaveImageWithCoreData
//
//  Created by Vignesh on 31/01/19.
//  Copyright © 2019 Vignesh. All rights reserved.
//

import UIKit

class ImagesCell: UITableViewCell {

    @IBOutlet weak var favoriteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
