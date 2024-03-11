//
// ProductDetailViewController
// Created by Nurasyl on 22.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

final class ProductDetailViewController: UIViewController {

    // MARK: - Properties

    let product: Product?
    
    let lessonProduct: CourseDetail.UsedProducts?

    let productProperties: [ProductProperty] = [
        ProductProperty(name: "Рост", value: "от 50-180 см", icon: .Icons.height),
        ProductProperty(name: "Размер", value: "16 см х 8 см", icon: .Icons.size),
        ProductProperty(name: "Вес", value: "300 гр", icon: .Icons.weight)
    ]

    // MARK: - UI Elements

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false

        return scrollView
    }()

    private lazy var contentView: UIView = UIView()

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 24
        imageView.sd_setImage(with: URL(string: product!.imageUrl))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.text = product?.name
        label.font = .appFont(ofSize: 17)
        label.textColor = .appDark90

        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()

        label.text = "\(product!.price.formattedString()) ₽"
        label.font = .appFont(ofSize: 28, weight: .bold)
        label.textColor = .appDark90

        return label
    }()

    private lazy var cartButtonView: CartButtonView = {
        let view = CartButtonView()

        view.delegate = self

        return view
    }()

    private lazy var bottomGradientView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.isHidden = true
        imageView.image = .cartButtonGradient

        return imageView
    }()

    private lazy var bottomCartButtonView: CartButtonView = {
        let view = CartButtonView(price: product?.price)
        
        view.isHidden = true
        view.delegate = self

        return view
    }()
    
    private lazy var propertiesView: UIView = {
        let view = UIView()

        view.layer.borderColor = UIColor.appBeige30.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 24

        return view
    }()

    private lazy var tableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.isUserInteractionEnabled = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none

        tableView.register(ProductPropertyCell.self, forCellReuseIdentifier: ProductPropertyCell.identifier)

        return tableView
    }()

    // MARK: - Lifecycle

    init(product: Product?, lessonProduct: CourseDetail.UsedProducts?) {
        self.product = product
        self.lessonProduct = lessonProduct
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = " "
    }
}

private extension ProductDetailViewController {
    func setupViews() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        title = ""
        view.addSubviews(scrollView, bottomGradientView, bottomCartButtonView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(productImageView, titleLabel, priceLabel, cartButtonView, propertiesView)
        propertiesView.addSubview(tableView)
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(2000)
        }

        productImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(220)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(17)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        cartButtonView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        propertiesView.snp.makeConstraints { make in
            make.top.equalTo(cartButtonView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        bottomGradientView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(137)
        }

        bottomCartButtonView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(bottomGradientView).inset(16)
        }
    }
}

extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > titleLabel.frame.maxY {
            title = titleLabel.text
        } else {
            title = ""
        }

        if scrollView.contentOffset.y > cartButtonView.frame.maxY {
            self.bottomGradientView.isHidden = false
            self.bottomCartButtonView.isHidden = false

            UIView.animate(withDuration: 0.2, animations: {
                self.bottomGradientView.layer.opacity = 1
                self.bottomCartButtonView.layer.opacity = 1
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomGradientView.layer.opacity = 0
                self.bottomCartButtonView.layer.opacity = 0
            }, completion: { _ in
                self.bottomGradientView.isHidden = true
                self.bottomCartButtonView.isHidden = true
            })
        }
    }
}

extension ProductDetailViewController: CartButtonViewDelegate {
    func itemsCountDidChange(to value: Int) {
        cartButtonView.setItemsCount(to: value)
        bottomCartButtonView.setItemsCount(to: value)
    }
    
    func showCart() {
        tabBarController?.selectedIndex = 2
    }
}

extension ProductDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productProperties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductPropertyCell.identifier, for: indexPath) as? ProductPropertyCell else {
            fatalError("Unable to find a cell with identifier \(ProductPropertyCell.identifier)!")
        }

        cell.setData(withProperty: productProperties[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}
