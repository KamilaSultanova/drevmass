//
//  File.swift
//  drevmass
//
//  Created by Kamila Sultanova on 15.03.2024.
//

import Foundation

struct Promocode: Decodable {
    enum CodingKeys: String, CodingKey{
        case bonus
        case promocode
        case description
        case allAtempt = "all_attempt"
        case used
    }
    
    let bonus: Int
    let promocode: String
    let description: String
    let allAtempt: Int
    let used: Int
}
