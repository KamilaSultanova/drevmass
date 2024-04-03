//
//  LessonProducts.swift
//  drevmass
//
//  Created by Kamila Sultanova on 02.04.2024.
//

import Foundation

struct LessonProducts: Decodable{
    let usedProducts: [UsedProducts]
        
    enum CodingKeys: String, CodingKey {
        case usedProducts = "used_products"
    }
    
    struct UsedProducts: Decodable, ProductProtocol {
        let description: String
        let height: String
        let id: Int
        let imageUrl: String
        let price: Int
        let size: String
        let name: String
        let video_src: String
        let basket_count: Int
        let viewed: Int
        
        enum CodingKeys: String, CodingKey {
            case imageUrl = "image_src"
            case price
            case name = "title"
            case description
            case height
            case size
            case video_src
            case id
            case viewed
            case basket_count
        }
    }
    
}
