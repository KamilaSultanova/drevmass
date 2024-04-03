//
//  ProductProtocol.swift
//  drevmass
//
//  Created by Kamila Sultanova on 20.03.2024.
//

import Foundation

protocol ProductProtocol {
    var imageUrl: String { get }
    var price: Int { get }
    var name: String { get }
    var id: Int { get }
}
