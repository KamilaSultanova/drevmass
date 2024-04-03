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
import youtube_ios_player_helper

class ProductViewController: UIViewController {

    // MARK: - UI Elements
    
    var product: Product
    
    var recommendProductArray: [ProductDetail.Recommend] = []
    
    private lazy var count: Int = 1
    
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
        button.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var addToCartBelowButton: UIButton = {
        let button = UIButton()
        button.setTitle("В корзину", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBeige100
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var goToCartAboveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appBeige100
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        button.setImage(.Icons.arrowRight, for: .normal)
        button.addTarget(self, action: #selector(goToCartTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var goToCartBelowButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appBeige100
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        button.setImage(.Icons.arrowRight, for: .normal)
        button.addTarget(self, action: #selector(goToCartTapped), for: .touchUpInside)
        return button
    }()
        
    private lazy var purchasePriceLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.text = "\(product.price.formattedString()) ₽"
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .right
        
        return label
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
        button.addTarget(self, action: #selector(watchButton), for: .touchDown)
        return button
    }()
    
    private lazy var playerView: YTPlayerView = {
        let player = YTPlayerView()
        
        return player
    }()
    
    let playerVars = ["controls": 1, "playsinline": 1, "autohide": 1, "showinfo": 1, "autoplay": 1, "modestbranding": 1]
    
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
        button.isEnabled = true
        
        return button
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(.plus, for: .normal)
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.isEnabled = true
        
        return button
    }()
    
    lazy var quantityBelowLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .semiBold)
        label.textColor = .appDark90
        label.numberOfLines = 1
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var minusBelowButton: UIButton = {
        let button = UIButton()
        button.setImage(.minus, for: .normal)
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var plusBelowButton: UIButton = {
        let button = UIButton()
        button.setImage(.plus, for: .normal)
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(product: ProductProtocol) {
        if var product = product as? Product {
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
        }else if let recommendProduct = product as? ProductDetail.Product {
            self.product = Product(id: recommendProduct.id,
                                   imageUrl: recommendProduct.imageUrl,
                                   videoId: recommendProduct.videoId,
                                   price: recommendProduct.price,
                                   name: recommendProduct.name,
                                   description: recommendProduct.description,
                                   height: recommendProduct.height,
                                   size: recommendProduct.size,
                                   viewed: recommendProduct.viewed)
        }else if let lessonProduct = product as? LessonProducts.UsedProducts {
            self.product = Product(id: lessonProduct.id,
                                   imageUrl: lessonProduct.imageUrl,
                                   videoId: lessonProduct.video_src,
                                   price: lessonProduct.price,
                                   name: lessonProduct.name,
                                   description: lessonProduct.description,
                                   height: lessonProduct.height,
                                   size: lessonProduct.size,
                                   viewed: lessonProduct.viewed)
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
        playerView.isHidden = true
        goToCartAboveButton.isHidden = true
        goToCartBelowButton.isHidden = true
        fetchButtonState()
    }
}

extension ProductViewController{
     func setupUI(){
        navigationItem.largeTitleDisplayMode = .never
        view.addSubviews(scrollView, fadeImageview, playerView, addToCartBelowButton, goToCartBelowButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(posterImageview, productLabel, priceLabel, addToCartAboveButton, goToCartAboveButton, howToUseButton, stackview, lineImageView, titleLabel, descriptionLabel, recommendProductLabel, collectionView)
        addToCartAboveButton.addSubviews(minusButton,plusButton,quantityLabel)
        addToCartBelowButton.addSubviews(minusBelowButton,plusBelowButton,quantityBelowLabel,purchasePriceLabel)
    }
    
     func setupConstraints(){
        playerView.snp.makeConstraints { make in
            make.width.equalTo(view.frame.size.width)
            make.height.equalTo(view.frame.size.height)
        }
        
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
        
        purchasePriceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(24)
        }
        
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
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(quantityLabel.snp.right).offset(8)
            make.size.equalTo(24)
        }
        quantityLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        minusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(quantityLabel.snp.left).offset(-8)
            make.size.equalTo(24)
        }
        
        plusBelowButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(quantityBelowLabel.snp.right).offset(8)
            make.size.equalTo(24)
        }
        quantityBelowLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        minusBelowButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(quantityBelowLabel.snp.left).offset(-8)
            make.size.equalTo(24)
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
    func watchButton(){
        playerView.isHidden = false
        self.playerView.load(withVideoId: "\(product.videoId)", playerVars: playerVars)
        self.playerView.playVideo()
    }
    
    @objc
    func goToCartTapped(){
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 2
        }
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
        cell.productId = recommendProductArray[indexPath.row].id
        cell.delegateProductVC = self
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
                goToCartBelowButton.isHidden = false
                fadeImageview.isHidden = false
            } else {
                addToCartBelowButton.isHidden = true
                goToCartBelowButton.isHidden = true
                fadeImageview.isHidden = true
            }
        }
    }
    
    func updateConstraintsForAddToCartBelowButton() {
        if scrollView.contentOffset.y < addToCartAboveButton.frame.maxY {
            if !goToCartBelowButton.isHidden{
                addToCartBelowButton.snp.remakeConstraints { make in
                    make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
                    make.left.equalToSuperview().inset(16)
                    make.height.equalTo(56)
                }
                
                goToCartBelowButton.snp.remakeConstraints { make in
                    make.centerY.equalTo(addToCartBelowButton)
                    make.left.equalTo(addToCartBelowButton.snp.right).offset(8)
                    make.right.equalToSuperview().inset(16)
                    make.size.equalTo(56)
                }
                
            }else{
                if goToCartAboveButton.isHidden{
                    goToCartBelowButton.isHidden = true
                    
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
                    return
                }
                goToCartBelowButton.snp.remakeConstraints { make in
                    make.centerY.equalTo(addToCartBelowButton)
                    make.left.equalTo(addToCartBelowButton.snp.right).offset(8)
                    make.right.equalToSuperview().inset(16)
                    make.size.equalTo(56)
                }
                
                addToCartBelowButton.snp.remakeConstraints { make in
                    make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
                    make.left.equalToSuperview().inset(16)
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
}

extension ProductViewController{
    func fetchButtonState(){
        AF.request(Endpoints.getBasket.value, method: .get,  headers: [.authorization(bearerToken: AuthService.shared.token)]).responseDecodable(of: Basket.self) { [self] response in
            switch response.result {
            case .success(let basket):
                for item in basket.basket {
                    if item.id == self.product.id {
                        configureButton()
                        count = item.count
                        quantityLabel.text = "\(count)"
                        quantityBelowLabel.text = "\(count)"
                    }
                }
                print("Product \(self.product.id) not found in basket")
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ProductViewController{
    func initialButtonConfigure(){
        goToCartAboveButton.isHidden = true
        goToCartAboveButton.isEnabled = false
        minusButton.isHidden = true
        plusButton.isHidden = true
        quantityLabel.isHidden = true
        
        addToCartAboveButton.snp.remakeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
            
        addToCartAboveButton.setTitle("В корзину", for: .normal)
        addToCartAboveButton.setTitleColor(.white, for: .normal)
        addToCartAboveButton.backgroundColor = .appBeige100
        addToCartAboveButton.layer.cornerRadius = 25
        addToCartAboveButton.clipsToBounds = true
        addToCartAboveButton.contentHorizontalAlignment = .center
        addToCartAboveButton.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        addToCartAboveButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
       
        addToCartBelowButton.setTitle("В корзину", for: .normal)
        addToCartBelowButton.setTitleColor(.white, for: .normal)
        addToCartBelowButton.backgroundColor = .appBeige100
        addToCartBelowButton.layer.cornerRadius = 25
        addToCartBelowButton.clipsToBounds = true
        addToCartBelowButton.contentHorizontalAlignment = .left
        addToCartBelowButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        addToCartBelowButton.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        addToCartBelowButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        
        purchasePriceLabel.isHidden = false
        goToCartAboveButton.isHidden = true
        goToCartBelowButton.isHidden = true
        quantityBelowLabel.isHidden = true
        plusBelowButton.isHidden = true
        minusBelowButton.isHidden = true
        
        addToCartBelowButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        
        goToCartBelowButton.snp.removeConstraints()
        
    }
    func configureButton(){
        
        goToCartAboveButton.isHidden = false
        goToCartAboveButton.isEnabled = true
        minusButton.isHidden = false
        plusButton.isHidden = false
        quantityLabel.isHidden = false
        
        addToCartAboveButton.setTitle("В корзине", for: .normal)
        addToCartAboveButton.setTitleColor(.appBeige100, for: .normal)
        addToCartAboveButton.layer.borderColor = UIColor.appBeige100.cgColor
        addToCartAboveButton.layer.borderWidth = 2
        addToCartAboveButton.backgroundColor = .white
        addToCartAboveButton.layer.cornerRadius = 25
        addToCartAboveButton.clipsToBounds = true
        addToCartAboveButton.contentHorizontalAlignment = .left
        addToCartAboveButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        addToCartAboveButton.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        
        addToCartAboveButton.snp.remakeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        
        goToCartAboveButton.snp.makeConstraints { make in
            make.centerY.equalTo(addToCartAboveButton)
            make.left.equalTo(addToCartAboveButton.snp.right).offset(8)
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(56)
        }
        
        purchasePriceLabel.isHidden = true
        minusBelowButton.isHidden = false
        plusBelowButton.isHidden = false
        quantityBelowLabel.isHidden = false
        
        addToCartBelowButton.setTitle("В корзине", for: .normal)
        addToCartBelowButton.setTitleColor(.appBeige100, for: .normal)
        addToCartBelowButton.layer.borderColor = UIColor.appBeige100.cgColor
        addToCartBelowButton.layer.borderWidth = 2
        addToCartBelowButton.backgroundColor = .white
        addToCartBelowButton.layer.cornerRadius = 25
        addToCartBelowButton.clipsToBounds = true
        addToCartBelowButton.contentHorizontalAlignment = .left
        addToCartBelowButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        addToCartBelowButton.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        
    }
    
}

extension ProductViewController{
    @objc
    func addToCartTapped(){
        let parameters = [
            "product_id": product.id,
            "count": count
            ]
        
        AF.request(Endpoints.basket.value, method: .post, parameters: parameters as Parameters,encoding: JSONEncoding.default, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseData { [self] response in
            switch response.result {
            case .success(_):
                fetchButtonState()
            case .failure(let error):
                print("Error: \(error)")
                inputViewController?.showToast(type: .error)
            }
        }
    }

}

extension ProductViewController{
    @objc func minusButtonTapped() {
        if count > 1{
            descreaseCart()            
        }else{
            initialButtonConfigure()
            deleteFromCart()
        }
    }
    
    func descreaseCart() {
        let parameters: [String: Any] = [
            "product_id": product.id,
            "count": count
        ]
        
        AF.request(Endpoints.decrease.value, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseData { [self] response in
            switch response.result {
            case .success(_):
                print(count)
                fetchButtonState()
            case .failure(let error):
                print("Error: \(error)")
                self.showToast(type: .error)
            }
        }
    }
    
    func deleteFromCart(){
        AF.request(Endpoints.basketProduct(productID: product.id).value, method: .delete, encoding: JSONEncoding.default, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseData { [self] response in
            switch response.result {
            case .success(_):
                fetchButtonState()
            case .failure(let error):
                print("Error: \(error)")
                self.showToast(type: .error)
            }
        }
    }
    
    @objc func plusButtonTapped() {
        let parameters: [String: Any] = [
            "product_id": product.id,
            "count": count
        ]
        
        AF.request(Endpoints.increase.value, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseData { [self] response in
            switch response.result {
            case .success(_):
                print(count)
                fetchButtonState()
            case .failure(let error):
                print("Error: \(error)")
                self.inputViewController?.showToast(type: .error)
            }
        }
    }
}
