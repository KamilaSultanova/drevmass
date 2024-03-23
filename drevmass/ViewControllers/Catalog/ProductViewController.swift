//
//  ProductViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 19.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class ProductViewController: UIViewController {

    // MARK: - UI Elements
    
    let product: Product
    
    var recommendProductArray: [ProductDetail.Recommend] = []
    
    private lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .CourseButton.share.withTintColor(.appBeige100), style: .plain, target: self, action: #selector(shareTapped))
        
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = false
        scrollView.isScrollEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var posterImageview: UIImageView = {
        let imageview = UIImageView()
        imageview.layer.cornerRadius = 24
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        imageview.sd_setImage(with: URL(string: "http://45.12.74.158/\(product.imageUrl)"))
        
        return imageview
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 28, weight: .bold)
        label.text = "\(product.price.formattedString()) ₽"
        label.textColor = .appDark90
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var productLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 17, weight: .regular)
        label.textColor = .appDark90
        label.text = "\(product.name)"
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var addToCartAboveButton: UIButton = {
        let button = UIButton()
        button.setTitle("В корзину", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBeige100
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.addTarget(self, action: #selector(addToCartTapped), for: .touchDown)
        return button
    }()
    
    private lazy var addToCartBelowButton: UIButton = {
        let button = UIButton()
        button.setTitle("В корзину", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBeige100
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
//        button.addTarget(self, action: #selector(alert), for: .touchDown)
        return button
    }()
    
    private lazy var howToUseButton: UIButton = {
        let button = UIButton()
      
        button.contentHorizontalAlignment = .center
        button.setImage(.howtouse, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Как использовать?", attributes: [
            .font: UIFont.appFont(ofSize: 15, weight: .semiBold),
            .foregroundColor: UIColor.appBeige100
        ]), for: .normal)

        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.borderless()
            configuration.imagePadding = 10
            button.configuration = configuration
        } else {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
//        button.addTarget(self, action: #selector(alert), for: .touchDown)
        return button
    }()
    
    private lazy var heightView: UIView = {
        let heightView = UIView()
        
        let imageview = UIImageView()
        imageview.image = .Icons.height
        
        let heightLabel = UILabel()
        heightLabel.text = "Рост"
        heightLabel.textAlignment = .left
        heightLabel.font = .appFont(ofSize: 15, weight: .regular)
        heightLabel.textColor = .appGray80
        
        let measureLabel = UILabel()
        measureLabel.textAlignment = .right
        measureLabel.text = product.height
        measureLabel.font = .appFont(ofSize: 15, weight: .semiBold)
        measureLabel.textColor = .appDark100
        
        heightView.addSubviews(imageview, heightLabel, measureLabel)
        imageview.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }
        
        heightLabel.snp.makeConstraints { make in
            make.left.equalTo(imageview.snp.right).offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(168)
        }
        
        measureLabel.snp.makeConstraints { make in
            make.left.equalTo(heightLabel.snp.right)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
        
        return heightView
    }()
    
    private lazy var lineImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = .divider.withTintColor(.appBeige50)
        
        return imageview
    }()
    
    private lazy var sizeView: UIView = {
        let sizeView = UIView()
        
        let imageview = UIImageView()
        imageview.image = .Icons.size
        
        let heightLabel = UILabel()
        heightLabel.text = "Размер"
        heightLabel.textAlignment = .left
        heightLabel.font = .appFont(ofSize: 15, weight: .regular)
        heightLabel.textColor = .appGray80
        
        let measureLabel = UILabel()
        measureLabel.textAlignment = .right
        measureLabel.text = product.size
        measureLabel.font = .appFont(ofSize: 15, weight: .semiBold)
        measureLabel.textColor = .appDark100
        
        sizeView.addSubviews(imageview, heightLabel, measureLabel)
        
        imageview.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }
        
        heightLabel.snp.makeConstraints { make in
            make.left.equalTo(imageview.snp.right).offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(168)
        }
        
        measureLabel.snp.makeConstraints { make in
            make.left.equalTo(heightLabel.snp.right)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
        
        return sizeView
    }()
    
    private lazy var stackview: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [heightView, sizeView])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.layer.cornerRadius = 24
        stackView.layer.borderColor = UIColor.appBeige30.cgColor
        stackView.layer.borderWidth = 2
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 20, weight: .semiBold)
        label.text = "Описание"
        label.textColor = .appDark100
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 16, weight: .regular)
        label.textColor = .appGray80
        label.numberOfLines = 0
        label.textAlignment = .natural
        
        let attributedText = NSMutableAttributedString(string: product.description)
        let kernValue: CGFloat = 0.75
        attributedText.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attributedText.length))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    private lazy var recommendProductLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 20, weight: .semiBold)
        label.text = "С этим товаром покупают"
        label.textColor = .appDark90
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var collectionView: SelfSizingCollectionView = {
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumInteritemSpacing = 10

        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ProductPlateCell.self, forCellWithReuseIdentifier: "ProductPlateCell")

        return collectionView
    }()
    
    private lazy var fadeImageview: UIImageView = {
        let imageview = UIImageView()
        
        imageview.contentMode = .scaleAspectFill
        imageview.image = .buttonFade
        
        return imageview
    }()
    
    
    // MARK: - Lifecycle
    
    init(product: ProductProtocol) {
        if let product = product as? Product {
            self.product = product
        } else if let recommendProduct = product as? ProductDetail.Recommend {
            self.product = Product(id: recommendProduct.id,
                                   imageUrl: recommendProduct.imageUrl,
                                   videoId: recommendProduct.videoId,
                                   price: recommendProduct.price,
                                   name: recommendProduct.name,
                                   description: recommendProduct.description,
                                   height: recommendProduct.height,
                                   size: recommendProduct.size,
                                   viewed: recommendProduct.viewed)
        }else if let recommendProduct = product as? Basket.Product {
            self.product = Product(id: recommendProduct.id,
                                   imageUrl: recommendProduct.imageUrl,
                                   videoId: recommendProduct.videoId,
                                   price: recommendProduct.price,
                                   name: recommendProduct.name,
                                   description: recommendProduct.description,
                                   height: recommendProduct.height,
                                   size: recommendProduct.size, viewed: nil)
        }else {
            fatalError("Unsupported type passed to ProductViewController")
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateConstraintsForAddToCartBelowButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = shareButton
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .appBeige100
        addToCartBelowButton.isHidden = true
        fadeImageview.isHidden = true
        setupUI()
        setupConstraints()
        fetchRecommendedProducts()
    }
}

extension ProductViewController{
    private func setupUI(){
        navigationItem.largeTitleDisplayMode = .never
        view.addSubviews(scrollView, fadeImageview)
        fadeImageview.addSubview(addToCartBelowButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(posterImageview, productLabel, priceLabel, addToCartAboveButton, howToUseButton, stackview, lineImageView, titleLabel, descriptionLabel, recommendProductLabel, collectionView)
    }
    
    private func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.bottom.equalTo(fadeImageview.snp.bottom)
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        
        posterImageview.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(220)
        }
        
        productLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageview.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        addToCartAboveButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        howToUseButton.snp.makeConstraints { make in
            make.top.equalTo(addToCartAboveButton.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        stackview.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(howToUseButton.snp.bottom).offset(16)
            make.height.equalTo(116)
        }
        
        lineImageView.snp.makeConstraints { make in
            make.centerY.equalTo(stackview)
            make.horizontalEdges.equalTo(stackview.snp.horizontalEdges).inset(20)
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(stackview.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            
        }
        
        recommendProductLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendProductLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(180)
            make.bottom.equalToSuperview().inset(100)
        }
    }
}

extension ProductViewController {
    @objc
    func shareTapped(){
        let text = "Привет! В приложении \"Древмасс\" нашел \(productLabel.text ?? "")"
        let image = posterImageview

        let activityViewController = UIActivityViewController(
            activityItems: [text, image],
            applicationActivities: nil
        )
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true)
    }
    
    func fetchRecommendedProducts() {
        let productId = product.id
        
        AF.request(Endpoints.productDetail(id: productId).value, method: .get, headers: [
            .authorization(bearerToken: AuthService.shared.token)
        ]).responseData { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                if let recommendJSON = json["Recommend"].arrayObject {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: recommendJSON)
                        let recommendProducts = try JSONDecoder().decode([ProductDetail.Recommend].self, from: jsonData)
                        self.recommendProductArray = recommendProducts
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                self.showToast(type: .error, title: error.localizedDescription)
            }
        }
    }
    
    @objc
    func addToCartTapped(){
//        AF.request(Endpoints.basket.value, method: .post,  headers: [.authorization(bearerToken: AuthService.shared.token)]).responseData { response in
//            switch response.result {
//            case .success(let data):
//                let json = JSON(data)
//                if let token = json["product_id"].string{
//                    
//                }
//                if let token = json["count"].string{
//                    
//                }
//                
//            case .failure(_):
//                self.showToast(type: .error)
//            }
//        }
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ProductViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendProductArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductPlateCell" , for: indexPath) as? ProductPlateCell else {
            fatalError("Unable to find a cell with identifier ProductPlateCell!")
        }

        cell.setdata(product: recommendProductArray[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165, height: 180)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let productDetailVC = ProductViewController(product: recommendProductArray[indexPath.row])

        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension ProductViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if scrollView.contentOffset.y > addToCartAboveButton.frame.maxY {
                addToCartBelowButton.isHidden = false
                fadeImageview.isHidden = false
            } else {
                addToCartBelowButton.isHidden = true
                fadeImageview.isHidden = true
            }
        }
    }
    
    private func updateConstraintsForAddToCartBelowButton() {
        if scrollView.contentOffset.y > addToCartAboveButton.frame.maxY {
            
            fadeImageview.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(137)
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
            addToCartBelowButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(16)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.height.equalTo(56)
            }
            
        } else {
            addToCartBelowButton.snp.remakeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.height.equalTo(56)
            }
            fadeImageview.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(137)
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
}

