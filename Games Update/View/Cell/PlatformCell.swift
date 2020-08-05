//
//  PlatformCell.swift
//  Games Update
//
//  Created by Muhammad Arif Hidayatulloh on 04/08/20.
//  Copyright © 2020 Ardat Tracode. All rights reserved.
//

import UIKit

class PlatformCell: UICollectionViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data: DetailGamesModel.PlatformGames){
        cellLabel.text = data.platform?.name ?? ""
    }
}
