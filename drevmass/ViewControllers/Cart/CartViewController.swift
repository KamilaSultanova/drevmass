//
//  CartViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 12.03.2024.
//

import UIKit
import SnapKit
import Alamofire


class CartViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - UI Elements
        
    var selectedProductArray: [ProductProtocol] = []
    
    var recommendProductArray: [Basket.Product] = []
    
    private lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .delete.withTintColor(.appGray70), style: .plain, target: self, action: #selector(deleteTapped))
        
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        
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
    
    private lazy var emptyСartImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = .basket
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "В истории баллов пока пусто"
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .appDark100
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var instrustionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Наполните её товарами из каталога"
        label.font = .appFont(ofSize: 16, weight: .regular)
        label.textColor = .appGray70
        label.numberOfLines = 0

        let attributedText = NSMutableAttributedString(string: label.text!)
        let kernValue: CGFloat = 0.75
        attributedText.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attributedText.length))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var catalogButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти в каталог", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBeige100
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
        button.addTarget(self, action: #selector(goToCatalog), for: .touchDown)
        return button
    }()
    
    private lazy var tableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = false
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "ListCell")
        return tableView
    }()
    
    private lazy var bonusLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .appDark100
        label.numberOfLines = 1
        label.textAlignment = .left
//        label.text = "Списать бонусы 500"
        
        return label
    }()
    
    private lazy var bonusIcon: UIImageView = {
        let image = UIImageView()
        image.image = .Course.bonus
        image.contentMode = .scaleAspectFit
    
        return image
    }()
    
    private lazy var notificationSwitch: UISwitch = {
        let switchNotification = UISwitch()
        switchNotification.onTintColor = .appBeige100
//        switchNotification.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        return switchNotification
    }()
    
    private lazy var bonusInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .regular)
        label.textColor = .appGray80
        label.numberOfLines = 0
        label.textAlignment = .left
       
        return label
    }()
    
    private lazy var promocodeButton: CustomButton = {
        let button = CustomButton()
        button.addTwoImagesButton(leftImage: .promocode, rightImage: .CourseButton.arrow, title: "Ввести промокод")
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.appBeige30.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(tapPromocodeButton), for: .touchUpInside)

        return button
    }()
    
    private lazy var priceView: UIView = {
        let view = UIView()
        view.backgroundColor = .appBeige30
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var productsNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 13, weight: .regular)
        label.textColor = .appGray80
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var productsPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 13, weight: .regular)
        label.textColor = .appDark100
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var bonusPaymentLabel: UILabel = {
        let label = UILabel()
        label.text = "Оплата бонусами"
        label.font = .appFont(ofSize: 13, weight: .regular)
        label.textColor = .appGray80
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.98, green: 0.36, blue: 0.36, alpha: 1.00)
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var lineImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = .divider.withTintColor(.appBeige50)
        
        return imageview
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Итого"
        label.font = .appFont(ofSize: 15, weight: .semiBold)
        label.textColor = .appDark100
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var finalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .bold)
        label.textColor = .appDark100
        label.textAlignment = .right
        
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
    
    private lazy var purchaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оформить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBeige100
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
//        button.addTarget(self, action: #selector(alert), for: .touchDown)
        return button
    }()


    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBackground
        setupNavBar()
        setupUI()
        setupConstraints()
        configureViews()
        fetchCart()
        
    }
}

extension CartViewController {
    private func setupUI() {
        
        view.addSubviews(scrollView, fadeImageview)
        fadeImageview.addSubview(purchaseButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(emptyСartImageView,emptyCartLabel, instrustionsLabel, catalogButton, tableView, bonusLabel, bonusIcon, notificationSwitch, bonusInfoLabel, promocodeButton, priceView, recommendProductLabel, collectionView)
        priceView.addSubviews(productsPriceLabel, productsNumberLabel, bonusPaymentLabel, discountLabel, lineImageView, totalLabel, finalPriceLabel)
        
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(scrollView.contentLayoutGuide)
            make.top.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        
        emptyСartImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(emptyCartLabel.snp.top).offset(-24)
            make.height.equalTo(112)
        }
        
        emptyCartLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        instrustionsLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyCartLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(emptyCartLabel)
            make.centerX.equalToSuperview()
        }
        
        catalogButton.snp.makeConstraints { make in
            make.top.equalTo(instrustionsLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(199)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        bonusLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(32)
            make.left.equalToSuperview().inset(16)
        }
        
        bonusIcon.snp.makeConstraints { make in
            make.centerY.equalTo(bonusLabel)
            make.size.equalTo(20)
            make.left.equalTo(bonusLabel.snp.right).offset(4)
        }
        
        notificationSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(bonusLabel)
            make.right.equalToSuperview().inset(16)
        }
        
        bonusInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(bonusLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(280)
        }
        
        promocodeButton.snp.makeConstraints { make in
            make.top.equalTo(bonusInfoLabel.snp.bottom).offset(16)
            make.height.equalTo(64)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        priceView.snp.makeConstraints { make in
            make.top.equalTo(promocodeButton.snp.bottom).offset(32)
            make.height.equalTo(134)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        productsNumberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(200)
        }
        
        productsPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(productsNumberLabel)
            make.right.equalToSuperview().inset(16)
        }
        
        bonusPaymentLabel.snp.makeConstraints { make in
            make.top.equalTo(productsNumberLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(200)
        }
        
        discountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bonusPaymentLabel)
            make.right.equalToSuperview().inset(16)
        }
        
        lineImageView.snp.makeConstraints { make in
            make.top.equalTo(bonusPaymentLabel.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(lineImageView.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(200)
        }
        
        finalPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalLabel)
            make.right.equalToSuperview().inset(16)
        }
        
        recommendProductLabel.snp.makeConstraints { make in
            make.top.equalTo(priceView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendProductLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(180)
            make.bottom.equalToSuperview().inset(100)
        }
        
        fadeImageview.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(137)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        purchaseButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
    }
    
    private func configureViews(){
        emptyCartLabel.isHidden = true
        emptyСartImageView.isHidden = true
        instrustionsLabel.isHidden = true
        catalogButton.isHidden = true
    }
}

extension CartViewController{
    @objc
    func goToCatalog(){
        if let tabBarController = tabBarController{
            tabBarController.selectedIndex = 1
        }
    }
    
    @objc
    func deleteTapped(){
        
    }
    
    @objc
    func tapPromocodeButton(){
        let enterPromocodeVC = EnterPromocodeViewController()
        presentPanModal(enterPromocodeVC)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedProductArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
        
        if let cartButton = cell.viewWithTag(1001) as? UIButton {
               cartButton.isHidden = true
           }
        if let quantityButton = cell.viewWithTag(1002) as? UIView {
            quantityButton.isHidden = false
           }
        
        cell.setdata(product: selectedProductArray[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CartViewController{
    func fetchCart(){
        print(Endpoints.getBasket.value)
        AF.request(Endpoints.getBasket.value, method: .get,  headers: [.authorization(bearerToken: AuthService.shared.token)]).responseDecodable(of: Basket.self) { [self] response in
                    switch response.result {
                    case .success(let basket):
                        selectedProductArray = basket.basket
                        bonusLabel.text = "Списать бонусы \(basket.bonus)"
                        bonusInfoLabel.text = "Баллами можно оплатить до \(basket.discount)% от стоимости заказа."
                        productsNumberLabel.text = "\(basket.countProducts) товара"
                        productsPriceLabel.text = "\(basket.totalPrice.formattedString()) ₽ "
                        discountLabel.text = "-\(basket.bonus) ₽ "
                        finalPriceLabel.text = "\(basket.basketPrice.formattedString()) ₽"
                        tableView.reloadData()
                        
                        recommendProductArray = basket.products
                        collectionView.reloadData()
                        
                    case .failure(let error):
                        self.showToast(type: .error)
                        print(error)
                    }
                }
            }
    }

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

//MARK: - Navigation Controller

extension CartViewController{
    func setupNavBar() {

        self.title = "Корзина"
        self.navigationController?.navigationBar.prefersLargeTitles = true

        let rightButton = UIButton()
        rightButton.setImage(.delete, for: .normal)
        rightButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        navigationController?.navigationBar.addSubview(rightButton)
        rightButton.tag = 1
        rightButton.frame = CGRect(x: self.view.frame.width, y: 0, width: 24, height: 24)

        let targetView = self.navigationController?.navigationBar

        let trailingContraint = NSLayoutConstraint(item: rightButton, attribute:
            .trailingMargin, relatedBy: .equal, toItem: targetView,
                             attribute: .trailingMargin, multiplier: 1.0, constant: -16)
        let bottomConstraint = NSLayoutConstraint(item: rightButton, attribute: .bottom, relatedBy: .equal, toItem: targetView, attribute: .bottom, multiplier: 1.0, constant: -16)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([trailingContraint, bottomConstraint])
    }
}

