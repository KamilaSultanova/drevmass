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
    func addToCartButtonTapped(productId: Int, tabBarController: UITabBarController?)
}

class ProductPlateCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    var productId: Int?
    
    var count = 1
        
    weak var delegate: CatalogViewController?
    
    weak var delegateProductVC: ProductViewController?
    
    weak var delegateCartVC: CartViewController?
    
    weak var delegateProductCell: ProductPlateCellDelegate?
    
    weak var tabBarController: UITabBarController?
    
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
    
    private var isAddedToCart: Bool = false
    
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
        
       fetchInStock()
    }
    
    @objc private func cartButtonTapped() {
        guard let productId = productId else { return }

        if let tabBarController = self.delegate?.tabBarController,
           let cartTabBarItem = tabBarController.tabBar.items?[2],
           let currentBadgeValue = cartTabBarItem.badgeValue,
           var totalCount = Int(currentBadgeValue) {
            
            if isAddedToCart {
                totalCount -= 1
                if totalCount > 0 {
                    cartTabBarItem.badgeValue = "\(totalCount)"
                } else {
                    cartTabBarItem.badgeValue = "0"
                }
                
                AF.request(Endpoints.basketProduct(productID: productId).value, method: .delete, encoding: JSONEncoding.default, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseData { [self] response in
                    switch response.result {
                    case .success(_):
                        isAddedToCart = false
                        fetchInStock()
                    case .failure(let error):
                        print("Error: \(error)")
                        inputViewController?.showToast(type: .error)
                    }
                }
            } else {
                totalCount += 1
                cartTabBarItem.badgeValue = "\(totalCount)"
                
                let parameters = [
                   "product_id": productId,
                   "count": count
                    ]
                
                AF.request(Endpoints.basket.value, method: .post, parameters: parameters as Parameters,encoding: JSONEncoding.default, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseData { [self] response in
                    switch response.result {
                    case .success(_):
                        print("success")
                        isAddedToCart = true
                        fetchInStock()
                    case .failure(let error):
                        print("Error: \(error)")
                        inputViewController?.showToast(type: .error)
                    }
                }
            }

        }
        if let tabBarController = tabBarController,
           let cartTabBarItem = tabBarController.tabBar.items?[2],
           let currentBadgeValue = cartTabBarItem.badgeValue,
           var totalCount = Int(currentBadgeValue) {
            
            if isAddedToCart {
                totalCount -= 1
                if totalCount > 0 {
                    cartTabBarItem.badgeValue = "\(totalCount)"
                } else {
                    cartTabBarItem.badgeValue = "0"
                }
                
                AF.request(Endpoints.basketProduct(productID: productId).value, method: .delete, encoding: JSONEncoding.default, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseData { [self] response in
                    switch response.result {
                    case .success(_):
                        isAddedToCart = false
                        fetchInStock()
                        delegateProductCell?.addToCartButtonTapped(productId: productId, tabBarController: delegate?.tabBarController)
                    case .failure(let error):
                        print("Error: \(error)")
                        inputViewController?.showToast(type: .error)
                    }
                }
            } else {
                totalCount += 1
                cartTabBarItem.badgeValue = "\(totalCount)"
                
                let parameters = [
                   "product_id": productId,
                   "count": count
                    ]
                
                AF.request(Endpoints.basket.value, method: .post, parameters: parameters as Parameters,encoding: JSONEncoding.default, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseData { [self] response in
                    switch response.result {
                    case .success(_):
                        print("success")
                        isAddedToCart = true
                        fetchInStock()
                        delegateProductCell?.addToCartButtonTapped(productId: productId, tabBarController: delegate?.tabBarController)
                    case .failure(let error):
                        print("Error: \(error)")
                        inputViewController?.showToast(type: .error)
                    }
                }
            }
        }
        
        else {
            print("Error: Could not access tab bar controller or badge value")

        }
    }

}

extension ProductPlateCell {
    func fetchInStock() {
        AF.request(Endpoints.getBasket.value, method: .get, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseJSON { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let basketItems = json["basket"] as? [[String: Any]] {
                    let basketProductIds = basketItems.compactMap { $0["product_id"] as? Int }
                    
                    if let productId = self.productId, basketProductIds.contains(productId) {
                        self.isAddedToCart = true
                    } else {
                        self.isAddedToCart = false
                    }
                    
                    if self.isAddedToCart {
                        self.cartButton.setImage(.CartButton.added, for: .normal)
                    } else {
                        self.cartButton.setImage(.CartButton.normal, for: .normal)
                    }
                } else {
                    print("Invalid response format")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

