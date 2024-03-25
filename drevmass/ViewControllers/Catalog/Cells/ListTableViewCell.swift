//
//  ListTableViewCell.swift
//  drevmass
//
//  Created by Kamila Sultanova on 19.03.2024.
//

import UIKit
import SnapKit
import Alamofire

protocol ListTableViewCellDelegate: AnyObject {
    func decreasedNumberOfproducts(countId: Int)
    func increaseNumberOfProducts(countId: Int)
    func deleteAlert()
}
class ListTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    
    var productId: Int?
        
    var count: Int = 0
    
    var currentCount: Int = 0
        
    weak var delegate: CatalogViewController?
    
    weak var delegateCartVC: CartViewController?
    
    weak var delegateListTableviewCell: ListTableViewCellDelegate?
        
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
        button.tag = 1001
        button.setImage(.CartButton.normal, for: .normal)
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var quantityView: UIView = {
        let view = UIView()
        view.backgroundColor = .appBeige30
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.tag = 1002
        
        return view
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .semiBold)
        label.textColor = .appDark90
        label.numberOfLines = 1
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(.minus, for: .normal)
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(.plus, for: .normal)
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
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
    
    func setCount(product: Basket.BasketItem){
        quantityLabel.text = "\(product.count)"
        currentCount = product.count
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

extension ListTableViewCell{
    
    @objc private func minusButtonTapped() {
        if currentCount > 1 {
            descreaseCart()
            delegateListTableviewCell?.decreasedNumberOfproducts(countId: currentCount)
        }else{
            deleteAlert()
        }
    }
    
    
    func descreaseCart() {
        let parameters: [String: Any] = [
            "product_id": productId,
            "count": currentCount
        ]
        
        AF.request(Endpoints.decrease.value, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseData { [self] response in
            switch response.result {
            case .success(_):
                print(currentCount)
                quantityLabel.text = "\(currentCount)"
                print("decreased")
            case .failure(let error):
                print("Error: \(error)")
                self.inputViewController?.showToast(type: .error)
            }
        }
        
    }
    
    @objc private func plusButtonTapped() {
        let parameters: [String: Any] = [
            "product_id": productId,
            "count": currentCount
        ]
        
        AF.request(Endpoints.increase.value, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseData { [self] response in
            switch response.result {
            case .success(_):
                print(currentCount)
                quantityLabel.text = "\(currentCount)"
                print("increased")
            case .failure(let error):
                print("Error: \(error)")
                self.inputViewController?.showToast(type: .error)
            }
        }
        delegateListTableviewCell?.increaseNumberOfProducts(countId: currentCount)
    }
    
    
    func deleteAlert() {
        
        let alertController = UIAlertController(title: "Вы уверены, что хотите удалить данный товар?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Оставить", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        let deletetAction = UIAlertAction(title: "Удалить", style: .destructive) { [self] _ in
                        
            AF.request(Endpoints.basketProduct(productID: productId!).value, method: .delete, encoding: JSONEncoding.default, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseData { [self] response in
                switch response.result {
                case .success(_):
                    print("deleted")
                case .failure(let error):
                    print("Error: \(error)")
                    self.inputViewController?.showToast(type: .error)
                }
            }
            delegateListTableviewCell?.deleteAlert()
        }
    
        alertController.addAction(deletetAction)
        delegateCartVC?.present(alertController, animated: true, completion: nil)
    }
    
}
