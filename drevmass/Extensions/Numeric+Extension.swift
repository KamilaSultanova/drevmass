//
// Int+Extension
// Created by Nurasyl on 23.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import Foundation

extension Numeric {
    func formattedString(style: NumberFormatter.Style = .decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        return formatter.string(from: self as? NSNumber ?? NSNumber()) ?? ""
    }
}
