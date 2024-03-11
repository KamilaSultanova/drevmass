//
// UIColor+Extension
// Created by Nurasyl on 20.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit

extension UIColor {
    /// Specific colors used within the application.
    static let appBackground = color(named: "Background")
    static let appModalBackground = color(named: "ModalBackground")
    static let appBeige10 = color(named: "Beige10")
    static let appBeige30 = color(named: "Beige30")
    static let appBeige40 = color(named: "Beige40")
    static let appBeige50 = color(named: "Beige50")
    static let appBeige100 = color(named: "Beige100")
    static let appGray40 = color(named: "Gray40")
    static let appGray50 = color(named: "Gray50")
    static let appGray60 = color(named: "Gray60")
    static let appGray70 = color(named: "Gray70")
    static let appGray80 = color(named: "Gray80")
    static let appDark90 = color(named: "Dark90")
    static let appDark100 = color(named: "Dark100")

    /// Retrieves a color based on the provided name.
    ///
    /// - Parameter name: The name of the color resource.
    /// - Returns: A `UIColor` object representing the named color.
    ///
    /// - Important: This function assumes that color resources are defined in the Assets catalog under the "Colors" folder.
    /// - Precondition: The specified color name should correspond to an available color resource in the Assets catalog.
    /// - Warning: If the specified color is not found, the function will cause a fatal error.
    ///
    /// Usage:
    /// ```swift
    /// let customColor = UIColor.color(named: "myCustomColor")
    /// ```
    ///
    private static func color(named name: String) -> UIColor {
        guard let color = UIColor(named: "Colors/" + name) else {
            fatalError("Unable to find a color named \(name)!")
        }

        return color
    }
}
