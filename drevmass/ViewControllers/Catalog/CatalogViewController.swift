//
// CatalogViewController
// Created by Nurasyl on 20.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import PanModal
import Alamofire

final class CatalogViewController: UIViewController {

    /// Represents the available layout types for the view.
    private enum LayoutType: CGFloat {
        case plate = 208
        case gallery = 284
        case list = 120

        /// Moves to the next layout type in a cyclic manner.
        mutating func switchValue() {
            switch self {
                case .plate:
                    self = .gallery
                case .gallery:
                    self = .list
                case .list:
                    self = .plate
            }
        }
    }

    // MARK: - Properties

    var products: [Product] = [] {
        didSet {
            setupLayout()
        }
    }

    /// Manages the layout type for the view and triggers layout setup when changed.
    private var layoutType: LayoutType = .plate {
        didSet {
            setupLayout()
        }
    }

    /// Manages the current sorting type for the view.
    private var sortingType: SortingType = .popular {
        didSet {
            setupSorting()
        }
    }

    // MARK: - UI Elements
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)

        button.setImage(.Icons.sortButton.withTintColor(.appGray70), for: .normal)
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.borderless()
            configuration.imagePadding = 8
            button.configuration = configuration
        } else {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        }

        button.addAction(UIAction(handler: { _ in
            self.selectSortingType()
        }), for: .touchUpInside)

        return button
    }()

    private lazy var layoutButton: UIButton = {
        let button = UIButton(type: .system)

        button.setImage(.LayoutButton.plate, for: .normal)
        button.tintColor = .appGray70

        button.addAction(UIAction(handler: { _ in
            self.switchLayoutType()
        }), for: .touchUpInside)

        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = true
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

    private lazy var collectionView: SelfSizingCollectionView = {
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 12

        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false

        collectionView.register(ProductPlateCell.self, forCellWithReuseIdentifier: ProductPlateCell.identifier)

        return collectionView
    }()

    private lazy var tableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorColor = .appGray40

        tableView.register(ProductListCell.self, forCellReuseIdentifier: ProductListCell.identifier)
        tableView.register(ProductGalleryCell.self, forCellReuseIdentifier: ProductGalleryCell.identifier)

        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupLayout()
        setupSorting()
        fetchProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Каталог"
    }
}

// MARK: - Private extension

private extension CatalogViewController {
    func setupViews() {
        navigationController?.navigationBar.barTintColor = .white
        view.backgroundColor = .appBeige40
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(sortButton, layoutButton, tableView, collectionView)
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(scrollView.contentLayoutGuide)
            make.top.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        sortButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }

        layoutButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.size.equalTo(36)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalToSuperview().priority(.high)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalToSuperview().priority(.medium)
        }
    }

    func setupLayout() {
        collectionView.isHidden = layoutType != .plate
        tableView.isHidden = layoutType == .plate

        switch layoutType {
            case .gallery, .list:
                layoutButton.setImage(layoutType == .list ? .LayoutButton.list : .LayoutButton.gallery, for: .normal)
                tableView.reloadData()
                tableView.separatorStyle = layoutType == .gallery ? .none : .singleLine

            case .plate:
                layoutButton.setImage(.LayoutButton.plate, for: .normal)
                collectionView.reloadData()
        }

        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview().inset(119).priority(layoutType == .plate ? .high : .low)
        }

        tableView.snp.remakeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview().inset(119).priority(layoutType != .plate ? .high : .low)
        }
    }

    func setupSorting() {
        sortButton.setAttributedTitle(NSAttributedString(string: sortingType.rawValue, attributes: [
            .font: UIFont.appFont(ofSize: 15, weight: .semiBold),
            .foregroundColor: UIColor.appDark90
        ]), for: .normal)
        
        fetchProducts()
    }
}

// MARK: - Networking

extension CatalogViewController {
    func fetchProducts() {
        let headers: HTTPHeaders = [
            .authorization(bearerToken: AuthService.shared.token)
        ]
        
        AF.request(Endpoints.products(sorting: sortingType).value, method: .get, headers: headers).responseDecodable(of: [Product].self) { response in
            switch response.result {
                case .success(let products):
                    self.products = products
                case .failure(let error):
					self.showToast(type: .error)
                    print(error)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension CatalogViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductPlateCell.identifier, for: indexPath) as? ProductPlateCell else {
            fatalError("Unable to find a cell with identifier \(ProductPlateCell.identifier)!")
        }

        cell.setData(withProduct: products[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 - 22, height: 180)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.row]
        let productDetailVC = ProductDetailViewController(product: selectedProduct, lessonProduct: nil)

        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CatalogViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = layoutType == .gallery ? ProductGalleryCell.identifier : ProductListCell.identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ProductCellProtocol else {
            fatalError("Unable to find a cell with identifier \(identifier)!")
        }

        cell.setData(withProduct: products[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return layoutType.rawValue
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.row]
        let productDetailVC = ProductDetailViewController(product: selectedProduct, lessonProduct: nil)

        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension CatalogViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
                scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
            }
        }
    }
}

extension CatalogViewController {
    @objc
    func switchLayoutType() {
        layoutType.switchValue()
    }

    @objc
    func selectSortingType() {
        let sortingSelectVC = SortingSelectViewController()
		
        sortingSelectVC.currentSorting = sortingType
        sortingSelectVC.delegate = self

		presentPanModal(sortingSelectVC)
    }
}

extension CatalogViewController: SortingSelectDelegate {
    func didSelect(sortingType: SortingType) {
        self.sortingType = sortingType
    }
}
