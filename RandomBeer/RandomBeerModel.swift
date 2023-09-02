//
//  RandomBeerModel.swift
//  RandomBeer
//
//  Created by 권현석 on 2023/09/02.
//

import Foundation

typealias Beers = [QuickType]

struct QuickType: Codable {
    let name, description: String
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case imageURL = "image_url"
    }
}


