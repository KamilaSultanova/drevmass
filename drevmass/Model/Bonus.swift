//
//  Bonus.swift
//  drevmass
//
//  Created by Kamila Sultanova on 13.03.2024.
//

import Foundation

struct Bonus: Decodable {
    enum CodingKeys: String, CodingKey{
        case bonus
        case user_id
        case burning = "Burning"
        case transactions = "Transactions"
    }
    let bonus: Int
    let user_id: Int
    let burning: [Burning]?
    let transactions: [Transactions]
    
    struct Burning: Decodable{
        enum CodingKeys: String, CodingKey{
            case startDate = "activated_date"
            case burningBonus = "bonus"
            case endDate = "burning_date"
        }
        
        let startDate: String
        let burningBonus: Int
        let endDate: String
        
    }
    
    struct Transactions: Decodable{
        enum CodingKeys: String, CodingKey{
            case promoPrice = "promo_price"
            case promoType = "promo_type"
            case description
            case transactionType = "transaction_type"
            case transactionDate = "transaction_date"
            case bonusId = "bonus_id"
            
        }
        
        let promoPrice: Int
        let promoType: String
        let description: String
        let transactionType: String
        let transactionDate: String
        let bonusId: Int
    }
}
