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
    var dataGame : ListGamesModel.DataLists? = nil
    private lazy var gamesProvider: GamesFavoriteProvider = { return GamesFavoriteProvider() }()
    var local = false
    
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
        
        getDatabase()
    }
    
    func getDatabase(){
        gamesProvider.getAllData { (dataGames) in
            for i in 0 ..< dataGames.count {
                if self.id == dataGames[i].id {
                    self.local = true
                }
            }
            
            if self.local {
                let customImage = UIImage(systemName: "heart.fill")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                let btnWallet = UIBarButtonItem(image: customImage, style: .plain, target: self, action:#selector(self.favorite))
                self.navigationItem.rightBarButtonItem = btnWallet
            } else {
                let customImage = UIImage(systemName: "heart")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                let btnWallet = UIBarButtonItem(image: customImage, style: .plain, target: self, action:#selector(self.favorite))
                self.navigationItem.rightBarButtonItem = btnWallet
            }
        }
    }
    
    @objc func favorite(){
        if !local {
            gamesProvider.createData(dataGame?.id ?? 0, dataGame?.slug ?? "", dataGame?.name ?? "", dataGame?.released ?? "", dataGame?.tba ?? false, dataGame?.background_image ?? "", dataGame?.rating ?? 0.0, dataGame?.rating_top ?? 0) {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Successful", message: "Data Berhasil Disimpan di Favorite", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
                        self.local = true
                        let customImage = UIImage(systemName: "heart.fill")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                        let btnWallet = UIBarButtonItem(image: customImage, style: .plain, target: self, action:#selector(self.favorite))
                        self.navigationItem.rightBarButtonItem = btnWallet
                        alert.dismiss(animated: true, completion: nil)
                    })
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            gamesProvider.deleteData(dataGame?.id ?? 0) {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Successful", message: "Data Berhasil Dihapus dari Favorite", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
                        self.local = false
                        let customImage = UIImage(systemName: "heart")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                        let btnWallet = UIBarButtonItem(image: customImage, style: .plain, target: self, action:#selector(self.favorite))
                        self.navigationItem.rightBarButtonItem = btnWallet
                        alert.dismiss(animated: true, completion: nil)
                    })
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
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
