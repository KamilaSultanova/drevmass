//
// UIView+Extension
// Created by Nurasyl on 20.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit

extension UIView {
    /// Adds multiple `UIView`s as subviews to the current view.
    ///
    /// - Parameter views: A variadic list of `UIView` elements to be added as subviews.
    ///
    /// Example:
    /// ```swift
    /// let view1 = UIView()
    /// let view2 = UIView()
    /// let view3 = UIView()
    ///
    /// self.view.addSubviews(view1, view2, view3)
    /// ```
    ///
    /// - Note: The views will be added in the order they are passed.
    ///
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
