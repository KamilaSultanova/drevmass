//
// SortingType
// Created by Nurasyl on 20.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import Foundation

/// Represents the available sorting options for the view.
enum SortingType: String, CaseIterable {
    /// Sort by popularity.
    case popular = "По популярности"

    /// Sort by price in ascending order.
    case priceAsc = "По возрастанию цены"

    /// Sort by price in descending order.
    case priceDesc = "По убыванию цены"
}
