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
    func toDetailPage(id:Int, data:ListGamesModel.DataLists)
}

class GamesCell: UICollectionViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellReleased: UILabel!
    @IBOutlet weak var cellRating: UILabel!
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellContent: UIView!
    @IBOutlet weak var cellLoadingPage: UIView!
    
    var id = 0
    weak var delegate : GamesCellDelegate? = nil
    var data : ListGamesModel.DataLists? = nil
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data: ListGamesModel.DataLists){
        cellLoadingPage.isHidden = true
        let thumb = URL(string: data.background_image ?? "")
        let rating = data.rating ?? 0.0
        let release = data.released ?? ""
        
        self.data = data
        self.id = data.id ?? 0
        cellImage.kf.setImage(with: thumb)
        cellReleased.text = "Release: \(release)"
        cellRating.text = "Rating: \(rating)"
        cellName.text = data.name ?? ""
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toDetail))
        self.cellContent.addGestureRecognizer(tap)
    }
    
    @objc func toDetail(){
        self.delegate?.toDetailPage(id: self.id, data: self.data!)
    }
    
    func setDataGamePublisher(data: PublisherModel.GamesPublisher){
        self.id = data.id ?? 0
        
        let callNet = MoyaProvider<GamesNetwork>()
        callNet.request(.gameDetail(id: self.id)) { (result) in
            switch result {
            case .success(let respon):
                do {
                    self.cellLoadingPage.isHidden = true
                    let repsonse = try respon.filterSuccessfulStatusCodes()
                    let dataRes =  try repsonse.map(DetailGamesModel.self)
                    let thumb = URL(string: dataRes.background_image ?? "")
                    
                    self.cellReleased.text = "Release: \(dataRes.released ?? "")"
                    self.cellImage.kf.setImage(with: thumb)
                    self.cellRating.text = "Rating: \(dataRes.rating ?? 0.0)"
                    self.cellName.text = dataRes.name ?? ""
                    self.data = ListGamesModel.DataLists(id: data.id, slug: data.slug, name: data.name, released: dataRes.released, tba: true, background_image: dataRes.background_image, rating: dataRes.rating, rating_top: 5)
                } catch {
                    print("Gagal Fetch Data")
                }
            case .failure(_):
                print("Gagal")
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toDetail))
        self.cellContent.addGestureRecognizer(tap)
    }
}
