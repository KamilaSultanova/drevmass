//
//  GaleryTableViewCell.swift
//  drevmass
//
//  Created by Kamila Sultanova on 19.03.2024.
//

import UIKit
import SnapKit
import Alamofire

class GaleryTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    var productId: Int?
    
    var count = 1
        
    weak var delegate: CatalogViewController?
    
    private lazy var imageview: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
      
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 20, weight: .bold)
        label.textColor = .appDark90
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var productLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 17, weight: .regular)
        label.textColor = .appDark90
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(.CartButton.normal, for: .normal)
        
        return button
    }()
   
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GaleryTableViewCell {
    func setupUI() {
        contentView.addSubviews(imageview, priceLabel, productLabel, cartButton)

    }
    
    func setupConstraints() {
        imageview.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(202)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(imageview.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(cartButton.snp.left)
        }
        
        productLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(priceLabel)
            make.bottom.equalToSuperview().inset(8)
        }
        
        cartButton.snp.makeConstraints { make in
            make.top.equalTo(imageview.snp.bottom).offset(12)
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(48)
        }
    }
    
    func setdata(product: Product){
        imageview.sd_setImage(with: URL(string: "http://45.12.74.158/\(product.imageUrl)"))
        priceLabel.text = "\(product.price.formattedString()) ₽"
        productLabel.text = product.name
    }
    
    @objc private func cartButtonTapped() {
        let parameters = [
            "product_id": productId,
            "count": count
        ]
    
        AF.request(Endpoints.basket.value, method: .post, parameters: parameters as Parameters,encoding: JSONEncoding.default, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseData { response in
            switch response.result {
            case .success(_):
                UserDefaults.standard.set(self.productId, forKey: "selectedProductID")
                self.cartButton.setImage(.CartButton.added, for: .normal)
            case .failure(let error):
                print("Error: \(error)")
                self.inputViewController?.showToast(type: .error)
            }
        }
    }
}
