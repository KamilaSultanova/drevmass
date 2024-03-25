//
//  ProductPlateCell.swift
//  drevmass
//
//  Created by Kamila Sultanova on 12.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

protocol ProductPlateCellDelegate: AnyObject {
    func addToCartButtonTapped(productId: Int)
}

class ProductPlateCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    var productId: Int?
    
    var count = 1
        
    weak var delegate: CatalogViewController?
    
    weak var delegateProductVC: ProductViewController?
    
    weak var delegateCartVC: CartViewController?
    
    weak var delegateProductCell: ProductPlateCellDelegate?
    
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
    
    lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(.CartButton.normal, for: .normal)
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var isAddedToCart = false
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
extension ProductPlateCell {
    func setupUI() {
        contentView.addSubviews(imageview, priceLabel, productLabel, cartButton)
        
    }
    
    func setupConstraints() {
        imageview.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(imageview.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.equalTo(cartButton.snp.left)
        }
        
        productLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(priceLabel)
        }
        
        cartButton.snp.makeConstraints { make in
            make.top.equalTo(imageview.snp.bottom).offset(12)
            make.right.equalToSuperview()
            make.size.equalTo(36)
        }
    }
    
    func setdata(product: ProductProtocol){
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
        delegateProductCell?.addToCartButtonTapped(productId: self.productId ?? 0)
    }
    
    
}
