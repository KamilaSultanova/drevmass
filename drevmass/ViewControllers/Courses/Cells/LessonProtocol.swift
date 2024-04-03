//
//  LessonProtocol.swift
//  drevmass
//
//  Created by Kamila Sultanova on 04.04.2024.
//

import Foundation

protocol LessonProtocol {
    var id: Int { get }
    var name: String { get }
    var title: String { get }
    var description: String { get }
    var image: String { get }
    var video: String { get }
    var duration: Int { get }
    var isFavorite: Bool { get set }
    var completed: Bool { get set }
}
