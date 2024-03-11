//
// CartViewController
// Created by Nurasyl on 22.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

private extension CartViewController {
    func setupViews() {
        view.backgroundColor = .appBackground
    }
}
