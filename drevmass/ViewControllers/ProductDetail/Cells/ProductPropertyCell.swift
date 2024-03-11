//
// ProductPropertyCell
// Created by Nurasyl on 22.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit

final class ProductPropertyCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = "ProductPropertyCell"

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(withProperty property: ProductProperty) {
        // TODO: Display data
    }
}

// MARK: - Private extension

private extension ProductPropertyCell {
    func setupViews() {
        contentView.addSubviews()
    }

    func setupConstraints() {}
}
