//
// Product
// Created by Nurasyl on 20.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

struct Product: Decodable, ProductProtocol {
   
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_src"
        case price
        case name = "title"
        case description
        case height
        case size
        case videoId = "video_src"
        case id
        case viewed
    }
    
    let id: Int
    var imageUrl: String 
    let videoId: String
    var price: Int
    var name: String
    let description: String
    let height: String
    let size: String
    let viewed: Int?
}
