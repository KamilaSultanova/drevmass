//
//  ProductDetail.swift
//  drevmass
//
//  Created by Kamila Sultanova on 20.03.2024.
//

import Foundation

struct ProductDetail: Decodable {
    let product: Product
    let recommend: [Recommend]

    struct Product: Decodable, ProductProtocol {
        let id: Int
        let name: String
        let description: String
        let height: String
        let size: String
        let basket_count: Int
        let price: Int
        let imageUrl: String
        let videoId: String
        let viewed: Int
        
        
        enum CodingKeys: String, CodingKey {
            case imageUrl = "image_src"
            case price
            case name = "title"
            case description
            case height
            case size
            case videoId = "video_src"
            case id
            case viewed
            case basket_count
        }
    }
    
    struct Recommend: Decodable, ProductProtocol {
        
        enum CodingKeys: String, CodingKey {
            case imageUrl = "image_src"
            case price
            case name = "title"
            case description
            case height
            case size
            case videoId = "video_src"
            case id
            case viewed
            case basket_count
        }
        
        let id: Int
        let name: String
        let description: String
        let price: Int
        let height: String
        let size: String
        let basket_count: Int
        let imageUrl: String
        let videoId: String
        let viewed: Int?
    }
}

