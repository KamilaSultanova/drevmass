//
// AuthService
// Created by Nurasyl Melsuly on 13.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import Foundation
import KeychainSwift

protocol AuthServiceProtocol {
    var isAuthorized: Bool { get }
}

final class AuthService: AuthServiceProtocol {
    public static let shared = AuthService()
    
    private let keychain = KeychainSwift()
    
    public var isAuthorized: Bool {
        keychain.get("token") != nil
    }
    
    var token: String {
        get {
            keychain.get("token") ?? ""
        }
        
        set {
            keychain.set(newValue, forKey: "token")
        }
    }
    
    private init () {}
}
