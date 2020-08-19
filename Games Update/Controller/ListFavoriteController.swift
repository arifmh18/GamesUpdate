//
//  ListFavoriteController.swift
//  Games Update
//
//  Created by Muhammad Arif Hidayatulloh on 19/08/20.
//  Copyright © 2020 Ardat Tracode. All rights reserved.
//

import UIKit

class ListFavoriteController: UIViewController {

    @IBOutlet weak var favoriteList: UICollectionView!
    @IBOutlet weak var favoriteNoData: UIView!
    @IBOutlet weak var favoriteLoading: UIActivityIndicatorView!
    
    var cellGames = "cellGames"
    var dataGames = [ListGamesModel.DataLists]()
    private lazy var gamesProvider: GamesFavoriteProvider = { return GamesFavoriteProvider() }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Games Favorite"
        let cellG = UINib(nibName: "GamesCell", bundle: nil)
        favoriteList.register(cellG, forCellWithReuseIdentifier: cellGames)
        favoriteList.delegate = self
        favoriteList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoriteLoading.startAnimating()
        favoriteLoading.isHidden = false
        // Do any additional setup after loading the view.
        getDataFav()
    }
    
    func getDataFav(){
        gamesProvider.getAllData { (dataGame) in
            self.favoriteLoading.isHidden = true
            if dataGame.isEmpty {
                self.favoriteNoData.isHidden = false
                self.favoriteList.reloadData()
            } else {
                self.favoriteNoData.isHidden = true
                self.dataGames = dataGame
                self.favoriteList.reloadData()
            }
        }
    }
}

extension ListFavoriteController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, GamesCellDelegate {
    func toDetailPage(id: Int, data: ListGamesModel.DataLists) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailGame") as? DetailGamesController
        vc?.id = id
        vc?.dataGame = data
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.dataGames[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellGames, for: indexPath) as? GamesCell
        cell?.setData(data: data)
        cell?.delegate = self
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width - 32, height: 100)
    }

}
