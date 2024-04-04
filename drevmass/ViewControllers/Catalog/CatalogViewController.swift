//
//  CatalogViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 12.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import Reachability


class CatalogViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - UI Elements
    
    enum LayoutType {
        case gallery
        case list
        case plate
    }
   
    var productArray: [Product] = []
    
    private lazy var currentSortingType: SortingType = .popular
    
    private var currentLayoutType: LayoutType = .plate
    
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
    
    private lazy var sortingButton: UIButton = {
        let button = UIButton()
        
 
        button.setImage(.Icons.sortButton.withTintColor(.appGray70), for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .bold)
        button.setAttributedTitle(NSAttributedString(string: currentSortingType.rawValue, attributes: [
            .font: UIFont.appFont(ofSize: 15, weight: .semiBold),
            .foregroundColor: UIColor.appDark90
        ]), for: .normal)

        button.contentHorizontalAlignment = .left
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.borderless()
            configuration.imagePadding = 8
            button.configuration = configuration
        } else {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        }
        
        button.addTarget(self, action: #selector(sortingTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var layoutButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.LayoutButton.plate.withTintColor(.appGray70), for: .normal)
        button.addTarget(self, action: #selector(layoutTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var collectionView: SelfSizingCollectionView = {
        let layout = UICollectionViewFlowLayout()

        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .vertical

        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ProductPlateCell.self, forCellWithReuseIdentifier: "ProductPlateCell")

        return collectionView
    }()
    
    private lazy var tableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.register(GaleryTableViewCell.self, forCellReuseIdentifier: "GalleryCell")
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "ListCell")
        return tableView
    }()
    
    private lazy var noInternetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var wifiImageView: UIImageView = {
        let imageview = UIImageView()
        
        imageview.image = .Toast.wifi
        imageview.contentMode = .scaleAspectFit
        
        return imageview
    }()
    
    private lazy var internetLabel: UILabel = {
        let label = UILabel()
        label.text = "Не удалось загрузить"
        label.textAlignment = .center
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .appDark100
        
        return label
    }()
    
    private lazy var reloadButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
        button.setTitle("Повторить попытку", for: .normal)
        button.backgroundColor = .appBeige100
        button.addTarget(self, action: #selector(reloadTapped), for: .touchUpInside)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        
        return button
    }()

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Каталог"
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBackground
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .appBeige100
        setupUI()
        setupConstraints()
        fetchProducts()
        
        guard let reachability = try? Reachability() else {
            print("Unable to create Reachability object")
            return
        }
        
        if reachability.isReachable {
            noInternetView.isHidden = true
            fetchProducts()
            configureViews()
        } else {
            noInternetView.isHidden = false
            tableView.isHidden = true
            collectionView.isHidden = true
        }
    }
}
extension CatalogViewController {
    private func setupUI() {
        
        view.addSubviews(scrollView, noInternetView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(sortingButton, layoutButton, collectionView, tableView)
        noInternetView.addSubviews(wifiImageView, internetLabel, reloadButton)
        
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        noInternetView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        wifiImageView.snp.makeConstraints { make in
            make.size.equalTo(112)
            make.center.equalToSuperview()
        }
        
        internetLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(wifiImageView.snp.bottom).offset(24)
        }
        
        reloadButton.snp.makeConstraints { make in
            make.top.equalTo(internetLabel.snp.bottom).offset(24)
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(84)
        }

        contentView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(scrollView.contentLayoutGuide)
            make.top.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        sortingButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
        }
        
        layoutButton.snp.makeConstraints { make in
            make.centerY.equalTo(sortingButton)
            make.size.equalTo(36)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(sortingButton.snp.right).offset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortingButton.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(32).priority(.high)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(sortingButton.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(32).priority(.low)
        }
    }
    
    func configureViews(){
        if currentLayoutType == .plate{
            collectionView.isHidden = false
            tableView.isHidden = true
        } else {
            collectionView.isHidden = true
            tableView.isHidden = false
            tableView.separatorStyle = .singleLine
            if currentLayoutType == .gallery{
                tableView.separatorStyle = .none
            }
        }
    }
}

extension CatalogViewController: SortingViewControllerDelegate{
    
    func didSelectSortingType(_ sortingType: SortingType) {
        currentSortingType = sortingType
        sortingButton.setAttributedTitle(NSAttributedString(string: sortingType.rawValue, attributes: [
            .font: UIFont.appFont(ofSize: 15, weight: .semiBold),
            .foregroundColor: UIColor.appDark90
        ]), for: .normal)
        fetchProducts()
    }
    
    @objc
    func reloadTapped(){
        fetchProducts()
    }
    
    @objc
    func sortingTapped() {
        let sortingVC = SortingViewController()
        sortingVC.selectedSortingType = currentSortingType
        sortingVC.delegate = self
        presentPanModal(sortingVC)
    }
    
    @objc
    func layoutTapped(){
        switch currentLayoutType {
            case .plate:
                currentLayoutType = .gallery
                layoutButton.setImage(.LayoutButton.gallery.withTintColor(.appGray70), for: .normal)
            case .gallery:
                currentLayoutType = .list
                layoutButton.setImage(.LayoutButton.list.withTintColor(.appGray70), for: .normal)
            case .list:
                currentLayoutType = .plate
                layoutButton.setImage(.LayoutButton.plate.withTintColor(.appGray70), for: .normal)
            }
        configureViews()
        fetchProducts()
    }
}

extension CatalogViewController {
    func fetchProducts(){
        AF.request(Endpoints.product(sortType: currentSortingType).value, method: .get,  headers: [.authorization(bearerToken: AuthService.shared.token)]).responseDecodable(of: [Product].self){ response in
            switch response.result{
            case .success(let products):
                self.productArray = products
                self.collectionView.reloadData()
                self.tableView.reloadData()
            case .failure(let error):
                self.showToast(type: .error)
                print(error)
            }
        }
    }
}

extension CatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductPlateCell", for: indexPath) as? ProductPlateCell else {
            fatalError("Unable to find a cell with identifier \(ProductPlateCell.self)!")
        }
        cell.setdata(product: productArray[indexPath.row])
        cell.productId = productArray[indexPath.row].id
        cell.delegateCatalogVC = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 22
        let height = CGFloat(180)
   
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailVC = ProductViewController(product: productArray[indexPath.row])
        navigationController?.pushViewController(productDetailVC, animated: true)
    }

}

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentLayoutType == .gallery{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath) as! GaleryTableViewCell
//            cell.product = productArray[indexPath.row]
            cell.setdata(product: productArray[indexPath.row])
            cell.productId = productArray[indexPath.row].id
            cell.selectionStyle = .none
            cell.delegate = self
            
            return cell
        }
        
        if currentLayoutType == .list{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
//            cell.product = productArray[indexPath.row]
            cell.setdata(product: productArray[indexPath.row])
            cell.productId = productArray[indexPath.row].id
            cell.selectionStyle = .none
            cell.delegate = self
            
       
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailVC = ProductViewController(product: productArray[indexPath.row])
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

