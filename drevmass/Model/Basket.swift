//
//  Basket.swift
//  drevmass
//
//  Created by Kamila Sultanova on 23.03.2024.
//

import Foundation

struct Basket: Decodable {
    enum CodingKeys: String, CodingKey {
        case basket
        case basketPrice = "basket_price"
        case bonus
        case countProducts = "count_products"
        case discount
        case products
        case totalPrice = "total_price"
        case usedBonus = "used_bonus"
    }
    
    let basket: [BasketItem]
    let basketPrice: Int
    let bonus: Int
    let countProducts: Int
    let discount: Int
    let products: [Product]
    let totalPrice: Int
    let usedBonus: Int
    
    struct BasketItem: Decodable, ProductProtocol {
        let count: Int
        let price: Int
        let id: Int
        let imageUrl: String
        let name: String

        enum CodingKeys: String, CodingKey {
            case count, price
            case id = "product_id"
            case imageUrl = "product_img"
            case name = "product_title"
        }
    }

    struct Product: Decodable, ProductProtocol {
        let basketCount: Int
        let description: String
        let height: String
        let id: Int
        let imageUrl: String
        let price: Int
        let size: String
        let name: String
        let videoId: String

        enum CodingKeys: String, CodingKey {
            case basketCount = "basket_count"
            case description, height, id
            case imageUrl = "image_src"
            case price
            case size
            case name = "title"
            case videoId = "video_src"
        }
    }
}


