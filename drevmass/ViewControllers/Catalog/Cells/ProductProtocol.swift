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
    var videoId: String { get }
    var description: String { get }
    var height: String { get }
    var size: String { get }
    var viewed: Int? { get }
    var id: Int { get }
}
