//
// ProfileViewController
// Created by Nurasyl on 22.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

private extension ProfileViewController {
    func setupViews() {
        view.backgroundColor = .appBackground
    }
}
