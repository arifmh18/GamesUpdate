//
//  BerandaController.swift
//  Games Update
//
//  Created by Muhammad Arif Hidayatulloh on 03/08/20.
//  Copyright © 2020 Ardat Tracode. All rights reserved.
//

import UIKit
import Moya

class BerandaController: UIViewController {

    @IBOutlet weak var beranda_publisherList: UICollectionView!
    @IBOutlet weak var beranda_gamesLIst: UICollectionView!
    
    @IBOutlet weak var beranda_heightGames: NSLayoutConstraint!
    
    var dataPublisher = [PublisherModel.DataPublisher]()
    var dataGames = [ListGamesModel.DataLists]()
    
    var cellGames = "cellGames"
    var cellPublisher = "cellPublisher"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Games Update"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profil", style: .plain, target: self, action: #selector(toProfile))
        
        let cellG = UINib(nibName: "GamesCell", bundle: nil)
        let cellP = UINib(nibName: "PublisherCell", bundle: nil)
        beranda_gamesLIst.register(cellG, forCellWithReuseIdentifier: cellGames)
        beranda_publisherList.register(cellP, forCellWithReuseIdentifier: cellPublisher)
        
        beranda_publisherList.delegate = self
        beranda_publisherList.dataSource = self
        beranda_gamesLIst.delegate = self
        beranda_gamesLIst.dataSource =  self
        
        getData()
    }
    
    @objc func toProfile(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profile")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func getData(){
        let callNet = MoyaProvider<GamesNetwork>()
        callNet.request(.listGame) { (result) in
            switch result {
            case .success(let respon):
                do {
                    let response = try respon.filterSuccessfulStatusCodes()
                    let data = try response.map(ListGamesModel.self)
                    
                    self.dataGames = data.results ?? []
                    let size = self.dataGames.count
                    
                    self.beranda_heightGames.constant = CGFloat(30 + (size * 110))
                    self.beranda_gamesLIst.isScrollEnabled = false
                    self.beranda_gamesLIst.reloadData()
                } catch {
                    print("gagal fetch data")
                }
            case .failure(_):
                print("error")
            }
        }
        callNet.request(.listPublisher) { (result) in
            switch result {
            case .success(let respon):
                do {
                    let response = try respon.filterSuccessfulStatusCodes()
                    let data = try response.map(PublisherModel.self)
                    self.dataPublisher = data.results ?? []
                    self.beranda_publisherList.reloadData()
                } catch {
                    print("gagal fetch data")
                }
            case .failure(_):
                print("error")
            }
        }
    }
}

extension BerandaController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PublisherCellDelegate, GamesCellDelegate {
    func toDetailPage(id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailGame") as! DetailGamesController
        vc.id = id
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func toPagePublisher(judul: String, games: [PublisherModel.GamesPublisher]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "publisher") as! PublisherController
        vc.dataGames = games
        vc.judul = judul
        self.navigationController!.pushViewController(vc, animated: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.beranda_gamesLIst {
            return self.dataGames.count
        } else {
            return self.dataPublisher.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.beranda_gamesLIst {
            let data = self.dataGames[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellGames, for: indexPath) as! GamesCell
            cell.setData(data: data)
            cell.delegate = self
            return cell
        } else {
            let data = self.dataPublisher[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellPublisher, for: indexPath) as! PublisherCell
            cell.setData(data: data)
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.beranda_publisherList {
            return CGSize(width: 40, height: 40)
        } else {
            return CGSize(width: self.view.frame.size.width - 32, height: 100)
        }
    }
    
}
