//
//  DetailGamesController.swift
//  Games Update
//
//  Created by Muhammad Arif Hidayatulloh on 04/08/20.
//  Copyright © 2020 Ardat Tracode. All rights reserved.
//

import UIKit
import Moya
import Kingfisher

class DetailGamesController: UIViewController {

    @IBOutlet weak var detailLoadingPage: UIView!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailRelease: UILabel!
    @IBOutlet weak var detailNama: UILabel!
    @IBOutlet weak var detailPlatformList: UICollectionView!
    @IBOutlet weak var detailRating: UILabel!
    @IBOutlet weak var detailDeskripsi: UILabel!
    
    var dataPlatform = [DetailGamesModel.PlatformGames]()
    var cellString = "cellPlatform"
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Detail Game"
        let cell = UINib(nibName: "PlatformCell", bundle: nil)
        detailPlatformList.register(cell, forCellWithReuseIdentifier: cellString)
        detailPlatformList.delegate = self
        detailPlatformList.dataSource = self
        detailPlatformList.reloadData()
        detailLoadingPage.isHidden = false
        getData()
    }
    
    func getData(){
        let callNet = MoyaProvider<GamesNetwork>()
        callNet.request(.gameDetail(id: self.id)) { (result) in
            switch result {
            case .success(let respon):
                do {
                    self.detailLoadingPage.isHidden = true
                    let response = try respon.filterSuccessfulStatusCodes()
                    let data = try response.map(DetailGamesModel.self)
                    
                    let thumb = URL(string: data.background_image ?? "")
                    
                    self.dataPlatform = data.parent_platforms ?? []
                    self.detailNama.text = data.name ?? ""
                    self.detailRelease.text = "Released on \(data.released ?? "")"
                    self.detailRating.text = "Rating: \(data.rating ?? 0.0)"
                    self.detailDeskripsi.text = data.description_raw ?? ""
                    self.detailImage.kf.setImage(with: thumb)
                    
                    self.detailPlatformList.reloadData()
                    
                } catch {
                    print("Gagal Fetch Data")
                }
            case .failure(_):
                print("Gagal")
            }
        }
    }
}

extension DetailGamesController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataPlatform.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = dataPlatform[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellString, for: indexPath) as! PlatformCell
        cell.setData(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 145.0, height: 45.0)
    }
}
