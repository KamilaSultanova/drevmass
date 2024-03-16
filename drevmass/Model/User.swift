//
//  User.swift
//  drevmass
//
//  Created by Kamila Sultanova on 15.03.2024.
//

import Foundation

struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case gender
        case height
        case weight
        case birth
        case activity
        case phone_number
    }
    var id: Int
    var email: String
    var name: String
    var gender: Int
    var height: Int
    var weight: Int
    var birth: String
    var activity: Int
    var phone_number: String
}
