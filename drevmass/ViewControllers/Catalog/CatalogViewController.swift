//
//  CatalogViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 12.03.2024.
//

import UIKit
import SnapKit
import Alamofire

class CatalogViewController: UIViewController, UIScrollViewDelegate {
   
    var productArray: [Product] = []
    
    // MARK: - UI Elements
    
    private lazy var currentSortingType: SortingType = .popular
    
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
        
        button.setTitle("По популярности", for: .normal)
        button.setImage(.Icons.sortButton.withTintColor(.appGray70), for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.appDark90, for: .normal)
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
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .bold)
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

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Курсы"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBackground
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .appBeige100
        setupUI()
        setupConstraints()
        fetchProducts()
    }
}
extension CatalogViewController {
    private func setupUI() {
        
        view.addSubview(scrollView )
        scrollView.addSubview(contentView)
        contentView.addSubviews(sortingButton, layoutButton, collectionView)
        
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
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
            make.bottom.equalToSuperview().inset(32)
        }
    }
}

extension CatalogViewController: SortingViewControllerDelegate{
    
    func didSelectSortingType(_ sortingType: SortingType) {
        currentSortingType = sortingType
        fetchProducts()
    }
    
    @objc
    func sortingTapped() {
        let sortingVC = SortingViewController()
        sortingVC.delegate = self
        presentPanModal(sortingVC)
    }
    
    @objc
    func layoutTapped(){
        
    }
}

extension CatalogViewController {
    func fetchProducts(){
        AF.request(Endpoints.product(sortType: currentSortingType).value, method: .get,  headers: [.authorization(bearerToken: AuthService.shared.token)]).responseDecodable(of: [Product].self){ response in
            switch response.result{
            case .success(let products):
                self.productArray = products
                self.collectionView.reloadData()
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 22
        let height = CGFloat(180)
   
        return CGSize(width: width, height: height)
    }

}
