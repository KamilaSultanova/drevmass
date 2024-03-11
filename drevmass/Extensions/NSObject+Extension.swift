//
// NSObject+Extension
// Created by Nurasyl on 22.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit

extension NSObject {
    /// Calculates and returns a dynamic value based on the provided size that scales proportionally to the current device's screen size.
    ///
    /// - Parameters:
    ///   - size: The initial size value to be dynamically adjusted.
    ///
    /// - Returns: A CGFloat value adjusted based on the current device's screen size.
    func dynamicValue(forSize size: CGFloat) -> CGFloat {
        let screenSize = UIScreen.main.bounds.size
        let baseScreenSize = CGSize(width: 375, height: 812)
        let scaleFactor = min(screenSize.width, screenSize.height) / min(baseScreenSize.width, baseScreenSize.height)

        return size * scaleFactor
    }
}
