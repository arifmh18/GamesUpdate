//
//  PublisherCell.swift
//  Games Update
//
//  Created by Muhammad Arif Hidayatulloh on 03/08/20.
//  Copyright © 2020 Ardat Tracode. All rights reserved.
//

import UIKit
import Kingfisher

protocol PublisherCellDelegate : AnyObject {
    func toPagePublisher(judul:String, games: [PublisherModel.GamesPublisher])
}

class PublisherCell: UICollectionViewCell {

    @IBOutlet weak var cell_imagePublisher: UIImageView!
    @IBOutlet weak var cell_content: UIView!
    
    var judul = ""
    var games = [PublisherModel.GamesPublisher]()
    
    weak var delegate : PublisherCellDelegate? = nil
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data: PublisherModel.DataPublisher){
        self.cell_imagePublisher.layer.cornerRadius = self.frame.size.width / 2
        self.cell_imagePublisher.kf.setImage(with: URL(string: data.image_background ?? ""))
        
        self.judul = data.name ?? ""
        self.games = data.games ?? []
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(actTap))
        self.cell_content.addGestureRecognizer(tap)
        
    }
    
    @objc func actTap(){
        self.delegate?.toPagePublisher(judul: self.judul, games: self.games)
    }
}
