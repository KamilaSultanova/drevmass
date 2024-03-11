//
// ProductGalleryCell
// Created by Nurasyl on 20.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit
import SDWebImage

final class ProductGalleryCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = "ProductGalleryCell"

    private let productImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = .appFont(ofSize: 17)

        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()

        label.font = .appFont(ofSize: 20, weight: .bold)

        return label
    }()

    private lazy var cartButton: CartButton = {
        let button = CartButton()

        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private extension

private extension ProductGalleryCell {
    func setupViews() {
        selectionStyle = .none
        contentView.addSubviews(productImageView, priceLabel, titleLabel, cartButton)
    }

    func setupConstraints() {
        productImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(cartButton.snp.left)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(cartButton.snp.left)
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
        }

        cartButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.equalTo(productImageView.snp.bottom).offset(12)
            make.size.equalTo(48)
        }
    }
}

extension ProductGalleryCell: ProductCellProtocol {
    func setData(withProduct product: Product) {
        productImageView.sd_setImage(with: URL(string: Endpoints.asset(name: product.imageUrl).value))
        titleLabel.text = product.name
        priceLabel.text = "\(product.price.formattedString()) ₽"
    }
}

extension ProductGalleryCell {
    @objc
    func cartButtonTapped(_ sender: CartButton) {
        sender.buttonState.switchValue()
    }
}
