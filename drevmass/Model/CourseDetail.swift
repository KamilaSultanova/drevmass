//
// CourseDetail
// Created by Kamila Sultanova on 04.02.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import Foundation

struct CourseDetail: Decodable  {
    let count: Int?
    let course: Course?

    struct Course: Decodable {
        let id: Int
        let name: String
        let description: String
        let duration: Int
        let lesson_cnt: Int
        let image_src: String
        let lessons: [Lesson]
        let completed: Bool 
        let bonus_info: BonusInfo
    }

    struct BonusInfo: Decodable {
        let deadline: String?
        let description: String
        let price: Int
        let promo_type: String
    }

    struct Lesson: Decodable, LessonProtocol {
        enum CodingKeys: String, CodingKey {
            case id
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
    
    struct UsedProducts: Decodable, ProductProtocol {
        let description: String
        let height: String
        let id: Int
        let imageUrl: String
        let price: Int
        let size: String
        let name: String
        let video_src: String
        let viewed: Int
    }
}


