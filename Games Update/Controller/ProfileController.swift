//
//  ProfileController.swift
//  Games Update
//
//  Created by Muhammad Arif Hidayatulloh on 03/08/20.
//  Copyright © 2020 Ardat Tracode. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {

    @IBOutlet weak var profile_image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Profile Developer"
        // Do any additional setup after loading the view.
        makeShadow(yourView: profile_image)
    }
    
    func makeShadow(yourView: UIView){
        yourView.layer.shadowOpacity = 0.3
        yourView.layer.shadowOffset = CGSize(width: 1, height: 1)
        yourView.layer.shadowRadius = 3.0
        yourView.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
}
