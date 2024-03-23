//
//  ListTableViewCell.swift
//  drevmass
//
//  Created by Kamila Sultanova on 19.03.2024.
//

import UIKit
import SnapKit

class ListTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    
    private lazy var imageview: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
      
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .bold)
        label.textColor = .appDark90
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var productLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .regular)
        label.textColor = .appDark90
        label.numberOfLines = 2
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.tag = 1001
        button.setImage(.CartButton.normal, for: .normal)
        
        return button
    }()
    
    private lazy var quantityView: UIView = {
        let view = UIView()
        view.backgroundColor = .appBeige30
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.tag = 1002
        
        return view
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .semiBold)
        label.textColor = .appDark90
        label.numberOfLines = 1
        label.text = "1"
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(.minus, for: .normal)
        
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(.plus, for: .normal)
        
        return button
    }()
   
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        quantityView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListTableViewCell {
    func setupUI() {
        contentView.addSubviews(imageview, priceLabel, productLabel, cartButton, quantityView)
        quantityView.addSubviews(quantityLabel, minusButton, plusButton)

    }
    
    func setupConstraints() {
        imageview.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview().inset(16)
            make.height.equalTo(88)
            make.width.equalTo(146)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(22)
            make.left.equalTo(imageview.snp.right).offset(12)
        }
        
        productLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalTo(imageview.snp.right).offset(12)
            make.right.equalToSuperview().inset(15)
        }
        
        cartButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(priceLabel.snp.right)
            make.size.equalTo(36)
        }
        
        quantityView.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.height.equalTo(32)
            make.width.equalTo(100)
            make.right.equalToSuperview().inset(16)
        }
        
        quantityLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        minusButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(8)
            make.size.equalTo(16)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(8)
            make.size.equalTo(16)
        }
    }
    
    func setdata(product: ProductProtocol){
        imageview.sd_setImage(with: URL(string: "http://45.12.74.158/\(product.imageUrl)"))
        priceLabel.text = "\(product.price.formattedString()) ₽"
        productLabel.text = product.name
    }

}
