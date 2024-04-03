//
// Favorite
// Created by Kamila Sultanova on 08.02.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import Foundation

struct Favorite: Decodable {
    let course_id: Int
    let course_name: String
    let lessons: [Lesson]  

    struct Lesson: Decodable, LessonProtocol {
        enum CodingKeys: String, CodingKey {
            case id
            case orderId = "order_id"
            case name
            case title
            case description
            case image = "image_src"
            case video = "video_src"
            case duration
            case isFavorite = "is_favorite"
            case completed
            case used_products
            
        }
        let id: Int
        let orderId: Int
        let name: String
        let title: String
        let description: String
        let image: String
        let video: String
        let duration: Int
        var isFavorite: Bool
        var completed: Bool
        let used_products: [UsedProducts]?
    }
    
    struct UsedProducts: Decodable {
        let description: String?
        let height: String?
        let id: Int?
        let image_src: String?
        let price: Int?
        let size: String?
        let title: String?
        let video_src: String?
        let viewed: Int?
    }
}

