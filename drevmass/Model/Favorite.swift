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

    struct Lesson: Decodable {
        let id: Int?
        let name: String?
        let title: String?
        let description: String?
        let image: String?
        let video: String?
        let duration: Int?
        var isFavorite: Bool?
        var completed: Bool?
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

