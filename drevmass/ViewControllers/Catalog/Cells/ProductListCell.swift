//
// ProductListCell
// Created by Nurasyl on 20.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit
import SDWebImage

final class ProductListCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ProductListCell"
    
    private lazy var productLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .regular)
        label.textColor = .appDark90
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var cartButton: CartButton = {
        let button = CartButton()

        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)

        return button
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()

        label.font = .appFont(ofSize: 15, weight: .bold)
        label.textColor = .appDark90

        return label
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

private extension ProductListCell {
    func setupViews() {
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        selectionStyle = .none
        contentView.addSubviews(productLabel, productImageView, priceLabel, cartButton)
    }
    
    func setupConstraints() {
        productImageView.snp.makeConstraints { make in
            make.verticalEdges.left.equalToSuperview().inset(16)
            make.width.equalTo(dynamicValue(forSize: 146))
        }
        
        productLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView).inset(4)
            make.left.equalTo(productImageView.snp.right).offset(12)
            make.right.equalToSuperview().inset(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cartButton)
            make.left.equalTo(productImageView.snp.right).offset(12)
            make.right.equalTo(cartButton.snp.left)
        }
        
        cartButton.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().inset(16)
            make.size.equalTo(36)
        }
    }
}

extension ProductListCell: ProductCellProtocol {
    func setData(withProduct product: Product) {
        productLabel.text = product.name
        priceLabel.text = ("\(product.price.formattedString()) ₽")
        productImageView.sd_setImage(with: URL(string: product.imageUrl))
    }
}

extension ProductListCell {
    @objc
    func cartButtonTapped(_ sender: CartButton) {
        sender.buttonState.switchValue()
    }
}
