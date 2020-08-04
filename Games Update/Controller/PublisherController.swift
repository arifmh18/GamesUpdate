//
//  PublisherController.swift
//  Games Update
//
//  Created by Muhammad Arif Hidayatulloh on 04/08/20.
//  Copyright © 2020 Ardat Tracode. All rights reserved.
//

import UIKit

class PublisherController: UIViewController {

    @IBOutlet weak var publisherList: UICollectionView!
    
    var dataGames = [PublisherModel.GamesPublisher]()
    var judul = ""
    var cellGames = "cellGames"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = judul
        let cellG = UINib(nibName: "GamesCell", bundle: nil)
        publisherList.register(cellG, forCellWithReuseIdentifier: cellGames)
        publisherList.delegate = self
        publisherList.dataSource = self
        publisherList.reloadData()
    }
}

extension PublisherController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GamesCellDelegate {
    func toDetailPage(id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailGame") as! DetailGamesController
        vc.id = id
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let data = self.dataGames[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellGames, for: indexPath) as! GamesCell
        cell.setDataGamePublisher(data: data)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width - 32, height: 100)
    }
}
