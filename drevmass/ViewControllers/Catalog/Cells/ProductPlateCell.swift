//
// ProductPlateCell
// Created by Nurasyl on 20.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

final class ProductPlateCell: UICollectionViewCell {

    // MARK: - Properties

    static let identifier = "ProductPlateCell"

    private let productImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = .appFont(ofSize: 15)
        label.numberOfLines = 2

        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()

        label.font = .appFont(ofSize: 15, weight: .bold)

        return label
    }()

    private lazy var cartButton: CartButton = {
        let button = CartButton()

        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private extension

private extension ProductPlateCell {
    func setupViews() {
        contentView.addSubviews(productImageView, priceLabel, titleLabel, cartButton)
    }

    func setupConstraints() {
        productImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.equalTo(cartButton.snp.left)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.right.equalTo(cartButton.snp.left)
        }

        cartButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.size.equalTo(36)
            make.top.equalTo(productImageView.snp.bottom).offset(12)
        }
    }
}

extension ProductPlateCell {
    func setData(withProduct product: Product) {
        productImageView.sd_setImage(with: URL(string: product.imageUrl))
        titleLabel.text = product.name
        priceLabel.text = "\(product.price.formattedString()) ₽"
    }
    
    func setData(lessonProduct product: CourseDetail.UsedProducts) {
        productImageView.sd_setImage(with: URL(string: product.image_src))
        titleLabel.text = product.title
        priceLabel.text = "\(product.price.formattedString()) ₽"
    }
}

extension ProductPlateCell {
    @objc
    func cartButtonTapped(_ sender: CartButton) {
        sender.buttonState.switchValue()
    }
}
