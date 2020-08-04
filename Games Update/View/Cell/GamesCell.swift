//
//  GamesCell.swift
//  Games Update
//
//  Created by Muhammad Arif Hidayatulloh on 03/08/20.
//  Copyright © 2020 Ardat Tracode. All rights reserved.
//

import UIKit
import Kingfisher
import Moya

protocol GamesCellDelegate : AnyObject {
    func toDetailPage(id:Int)
}

class GamesCell: UICollectionViewCell {

    @IBOutlet weak var cell_image: UIImageView!
    @IBOutlet weak var cell_released: UILabel!
    @IBOutlet weak var cell_rating: UILabel!
    @IBOutlet weak var cell_nama: UILabel!
    @IBOutlet weak var cell_content: UIView!
    
    var id = 0
    weak var delegate : GamesCellDelegate? = nil
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data: ListGamesModel.DataLists){
        let thumb = URL(string: data.background_image ?? "")
        let rating = data.rating ?? 0.0
        let release = data.released ?? ""
        
        self.id = data.id ?? 0
        cell_image.kf.setImage(with: thumb)
        cell_released.text = "Release: \(release)"
        cell_rating.text = "Rating: \(rating)"
        cell_nama.text = data.name ?? ""
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toDetail))
        self.cell_content.addGestureRecognizer(tap)
    }
    
    @objc func toDetail(){
        self.delegate?.toDetailPage(id: self.id)
    }
    
    func setDataGamePublisher(data: PublisherModel.GamesPublisher){
        self.id = data.id ?? 0
        
        let callNet = MoyaProvider<GamesNetwork>()
        callNet.request(.gameDetail(id: self.id)) { (result) in
            switch result {
            case .success(let respon):
                do {
                    let repsonse = try respon.filterSuccessfulStatusCodes()
                    let data =  try repsonse.map(DetailGamesModel.self)
                    let thumb = URL(string: data.background_image ?? "")
                    
                    self.cell_released.text = "Release: \(data.released ?? "")"
                    self.cell_image.kf.setImage(with: thumb)
                    self.cell_rating.text = "Rating: \(data.rating ?? 0.0)"
                    self.cell_nama.text = data.name ?? ""
                } catch {
                    print("Gagal Fetch Data")
                }
            case .failure(_):
                print("Gagal")
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toDetail))
        self.cell_content.addGestureRecognizer(tap)
    }
}
