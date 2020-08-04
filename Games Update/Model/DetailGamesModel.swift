//
//  DetailGamesModel.swift
//  Games Update
//
//  Created by Muhammad Arif Hidayatulloh on 04/08/20.
//  Copyright © 2020 Ardat Tracode. All rights reserved.
//

import Foundation


struct DetailGamesModel : Codable {
    let id : Int?
    let name : String?
    let description_raw : String?
    let description : String?
    let background_image : String?
    let released : String?
    let rating : Double?
    let genres : [DetailGenreGames]?
    let parent_platforms : [PlatformGames]?
    
    struct DetailGenreGames : Codable {
        let id : Int?
        let name : String?
        let image_background : String?
    }
    
    struct PlatformGames : Codable {
        let platform : DetailPlatformGames?
    }
    
    struct DetailPlatformGames : Codable {
        let id : Int?
        let name : String?
        let slug : String?
    }
}
