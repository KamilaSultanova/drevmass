//
//  CartViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 12.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON


class CartViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - UI Elements
    
    var product: ProductProtocol?
        
    var selectedProductArray: [ProductProtocol] = []
    
    var recommendProductArray: [Basket.Product] = []
    
    var updateProductArray: [ProductDetail.Product] = []
    
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
        label.text = "В корзине пока ничего нет"
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
    
    private lazy var productsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
    
        return view
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
        
        return label
    }()
    
    private lazy var bonusIcon: UIImageView = {
        let image = UIImageView()
        image.image = .Course.bonus
        image.contentMode = .scaleAspectFit
    
        return image
    }()
    
    private lazy var bonusSwitch: UISwitch = {
        let switchBonus = UISwitch()
        switchBonus.onTintColor = .appBeige100
        switchBonus.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        switchBonus.isOn = true
        
        return switchBonus
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
        button.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var purchasePriceLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.text = "100"
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .right
        
        return label
    }()

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Корзина"
        fetchCart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let rightButton = navigationController?.navigationBar.viewWithTag(1) as? UIButton {
           rightButton.isHidden = true
       }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBackground
        setupNavBar()
        setupUI()
        setupConstraints()
    }
}

extension CartViewController {
    private func setupUI() {
        
        view.addSubviews(scrollView, fadeImageview, purchaseButton)
//        fadeImageview.addSubview(purchaseButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(emptyСartImageView,emptyCartLabel, instrustionsLabel, catalogButton, productsView)
        productsView.addSubviews( tableView, bonusLabel, bonusIcon, bonusSwitch, bonusInfoLabel, promocodeButton, priceView, recommendProductLabel, collectionView)
        priceView.addSubviews(productsPriceLabel, productsNumberLabel, bonusPaymentLabel, discountLabel, lineImageView, totalLabel, finalPriceLabel)
        purchaseButton.addSubview(purchasePriceLabel)
        
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
        
        productsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        bonusSwitch.snp.makeConstraints { make in
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
        
        purchaseButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(56)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        fadeImageview.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(137)
        }
        
        purchasePriceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(24)
        }
    }
    
    private func configureViews(){
        if selectedProductArray.isEmpty {
            productsView.isHidden = true
            fadeImageview.isHidden = true
            emptyCartLabel.isHidden = false
            emptyСartImageView.isHidden = false
            instrustionsLabel.isHidden = false
            catalogButton.isHidden = false
            if let rightButton = navigationController?.navigationBar.viewWithTag(1) as? UIButton {
                rightButton.isHidden = true
            }
        }else{
            productsView.isHidden = false
            fadeImageview.isHidden = false
            emptyCartLabel.isHidden = true
            emptyСartImageView.isHidden = true
            instrustionsLabel.isHidden = true
            catalogButton.isHidden = true
            if let rightButton = navigationController?.navigationBar.viewWithTag(1) as? UIButton {
                rightButton.isHidden = false
            }
        }
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
    func deleteTapped() {
        let alertController = UIAlertController(title: "Удаление товаров", message: "Вы уверены, что хотите удалить все товары?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Очистить корзину", style: .destructive) { [weak self] _ in
            self?.deleteAllProducts()
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        
        present(alertController, animated: true, completion: nil)
    }

    
    func deleteAllProducts() {
        AF.request(Endpoints.basket.value, method: .delete, encoding: JSONEncoding.default, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseData { [self] response in
            switch response.result {
            case .success(_):
                fetchCart()
                print("deleted")
            case .failure(let error):
                print("Error: \(error)")
                self.inputViewController?.showToast(type: .error)
            }
        }
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        fetchCart()
    }
    
    @objc
    func tapPromocodeButton(){
        let enterPromocodeVC = EnterPromocodeViewController()
        presentPanModal(enterPromocodeVC)
    }
    
    @objc
    func orderButtonTapped(){
        print("Order button tapped")
        let orderVC = OrderViewController()
        navigationController?.pushViewController(orderVC, animated: true)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedProductArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
        
        cell.setdata(product: selectedProductArray[indexPath.row])
        cell.cartButton.isHidden = true
        cell.quantityView.isHidden = false
        cell.productId = selectedProductArray[indexPath.row].id
        cell.setCount(product: selectedProductArray[indexPath.row] as! Basket.BasketItem)
        cell.selectionStyle = .none
        cell.delegateCartVC = self
        cell.delegateListTableviewCell = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productId = selectedProductArray[indexPath.row].id
        
        AF.request(Endpoints.productDetail(id: productId).value, method: .get, headers: [
            .authorization(bearerToken: AuthService.shared.token)
        ]).responseDecodable(of: ProductDetail.self) { response in
            switch response.result {
            case .success(let productDetail):
                let product = productDetail.product
                let productVC = ProductViewController(product: product)
                self.navigationController?.pushViewController(productVC, animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension CartViewController{
    func fetchCart(){
        AF.request(Endpoints.getBasket.value, method: .get,  headers: [.authorization(bearerToken: AuthService.shared.token)]).responseDecodable(of: Basket.self) { [self] response in
                switch response.result {
                case .success(let basket):
                    selectedProductArray = basket.basket
                    
                    configureViews()
                    bonusLabel.text = "Списать бонусы \(basket.bonus)"
                    bonusInfoLabel.text = "Баллами можно оплатить до \(basket.discount)% от стоимости заказа."
                    productsNumberLabel.text = "\(basket.countProducts) товара"
                    productsPriceLabel.text = "\(basket.totalPrice.formattedString()) ₽ "
                    
                    finalPriceLabel.text = "\(basket.basketPrice.formattedString()) ₽"
                    
                    if let tabBarController = self.tabBarController {
                        let cartTabBarItem = tabBarController.tabBar.items?[2]
                        let totalCount = basket.basket.reduce(0) { $0 + $1.count }
                        cartTabBarItem?.badgeValue = "\(totalCount)"
                        }
                    
                    
                    if bonusSwitch.isOn == true{
                        if Double(basket.bonus) < Double(basket.totalPrice) * 0.3{
                            discountLabel.text = "-\(basket.bonus) ₽ "
                            finalPriceLabel.text = "\((basket.basketPrice - basket.bonus).formattedString()) ₽"
                        }else{
                            discountLabel.text = "-\(Int(Double(basket.totalPrice) * 0.3)) ₽ "
                            finalPriceLabel.text = "\((basket.basketPrice - Int(Double(basket.totalPrice) * 0.3)).formattedString()) ₽"
                        }
                    }else{
                        discountLabel.text = "0 ₽ "
                        finalPriceLabel.text = "\(basket.basketPrice.formattedString()) ₽"
                    }
                    purchasePriceLabel.text = finalPriceLabel.text
                    
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
        cell.productId = recommendProductArray[indexPath.row].id
        cell.delegateProductCell = self
        cell.tabBarController = self.tabBarController
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
        self.navigationController?.navigationBar.prefersLargeTitles = true

        let rightButton = UIButton()
        rightButton.setImage(.delete, for: .normal)
        rightButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        rightButton.tag = 1
        navigationController?.navigationBar.addSubview(rightButton)
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


extension CartViewController: ProductPlateCellDelegate {
    func addToCartButtonTapped(productId: Int, tabBarController: UITabBarController?) {
        fetchCart()
        
    }
}

extension CartViewController: ListTableViewCellDelegate{
    func deleteAlert() {
        fetchCart()
        configureViews()
    }
    
    func increaseNumberOfProducts(countId: Int) {
        fetchCart()
    }
    
    func decreasedNumberOfproducts(countId: Int) {
        fetchCart()
    }
}

