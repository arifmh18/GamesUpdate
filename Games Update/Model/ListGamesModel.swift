//
//  ListGamesModel.swift
//  Games Update
//
//  Created by Muhammad Arif Hidayatulloh on 03/08/20.
//  Copyright © 2020 Ardat Tracode. All rights reserved.
//

import Foundation

struct ListGamesModel : Codable {
    let count : Int?
    let next : String?
    let previous : String?
    let results : [DataLists]?
    
    struct DataLists : Codable {
        var id : Int?
        var slug : String?
        var name : String?
        var released : String?
        var tba : Bool?
        var background_image : String?
        var rating : Double?
        var rating_top : Int?
        
    }
}
