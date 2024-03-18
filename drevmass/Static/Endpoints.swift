//
// Endpoints
// Created by Nurasyl Melsuly on 13.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import Foundation

enum Endpoints {
//    case products(sorting: SortingType)
    case asset(name: String)
	case courses
    case courseDetail(id: Int)
    case favorites
    case complete
    case login
    case signUp
    case resetPassword
    case user
    case bonus
    case bonusInfo
    case promocode
    case userInfo
    case changePassword
    case company
    case social
    case contacts
    case support
    case product(sortType: SortingType)
    
    private static let baseURL = "http://185.100.67.103/api/"
    
    private var endpoint: String {
        switch self 
        {
        case .asset(name: let name):
            return name
		case .courses:
			return "course"
        case .courseDetail(id: let courseId):
            return "course/\(courseId)"
        case .favorites:
            return "favorites"
        case .complete:
            return "lessons/complete"
        case .login:
            return "login"
        case .signUp:
            return "signup"
        case .resetPassword:
            return "forgot_password"
        case .user:
            return "user"
        case .bonus:
            return "bonus"
        case .bonusInfo:
            return "bonus/info"
        case .promocode:
            return "user/promocode"
        case .userInfo:
            return "user/information"
        case .changePassword:
            return "reset_password"
        case .company:
            return "info"
        case .social:
            return "social"
        case .contacts:
            return "contacts"
        case .support:
            return "support"
            
        case .product(sortType: let sorting):
            let sort = switch sorting {
                case .popular:
                    "famous"
                case .lowToHighPrice:
                    "priceup"
                case .highToLowPrice:
                    "pricedown"
            }
                
            return "products/\(sort)"
        }
    }
    
    var value: String {
        return (Endpoints.baseURL + self.endpoint).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
