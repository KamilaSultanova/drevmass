//
// Course
// Created by Kamila Sultanova on 07.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import Foundation

struct Course: Decodable {
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case image = "image_src"
		case number = "lesson_cnt"
		case duration
		case lesson
		case bonus = "bonus_info"
	}
	
	let id: Int
    let name: String
	let duration: Int
    var image: String
    var number: Int
    var lesson: String?
    var bonus: BonusInfo
    
    struct BonusInfo: Decodable {
        let deadline: String
        let description: String
        let price: Int
        let promo_type: String
    }
}
