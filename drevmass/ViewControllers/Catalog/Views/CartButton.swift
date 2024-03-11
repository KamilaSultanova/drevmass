//
// CartButton
// Created by Nurasyl on 20.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit

final class CartButton: UIButton {
    
    // MARK: - Properties
    
    enum ButtonState {
        case normal
        case addedToCart

        mutating func switchValue() {
            self = self == .addedToCart ? .normal : .addedToCart
        }
    }
    
    /// The current state of the `CartButton`.
    var buttonState: ButtonState = .normal {
        didSet {
            updateViewForState()
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CartButton {
    func setupView() {
        updateViewForState()
    }
    
    func updateViewForState() {
        switch buttonState {
            case .normal:
                setBackgroundImage(.CartButton.normal, for: .normal)
            case .addedToCart:
                setBackgroundImage(.CartButton.added, for: .normal)
            }
    }
}
