//
// CartButtonView
// Created by Nurasyl on 22.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit
import SnapKit

protocol CartButtonViewDelegate: AnyObject {
    func showCart()
    func itemsCountDidChange(to value: Int)
}

final class CartButtonView: UIView {

    // MARK: - Properties

    let price: String?
    var itemsCount: Int = 0 {
        willSet {
            updateView(oldValue: itemsCount, newValue: newValue)
        }
        didSet {
            delegate?.itemsCountDidChange(to: itemsCount)
        }
    }
    weak var delegate: CartButtonViewDelegate?
    var plateViewRightConstraint: Constraint?

    // MARK: - UI Elements

    private lazy var plateView: UIView = {
        let view = UIView()

        view.backgroundColor = .appBeige100
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.appBeige100.cgColor
        view.layer.cornerRadius = 28

        return view
    }()

    private lazy var plateViewButton: UIButton = {
        let button = UIButton()

        button.addTarget(self, action: #selector(plateViewTapped), for: .touchUpInside)

        return button
    }()

    private lazy var showCartButton: UIButton = {
        let button = UIButton(type: .system)

        button.isHidden = true
        button.setImage(.Icons.arrowRight, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .appBeige100
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(showCartButtonTapped), for: .touchUpInside)

        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.text = "В корзину"
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .white
        if let price {
            label.textAlignment = .left
        } else {
            label.textAlignment = .center
        }

        return label
    }()

    private lazy var decrementButton: UIButton = {
        let button = UIButton(type: .system)

        button.isHidden = true
        button.setImage(.Icons.minus, for: .normal)
        button.tintColor = .appBeige100
        button.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
        button.contentHorizontalAlignment = .trailing

        return button
    }()

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = .appDark90
        label.font = .appFont(ofSize: 17, weight: .semiBold)

        return label
    }()

    private lazy var incrementButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.isHidden = true
        button.setImage(.Icons.plus, for: .normal)
        button.tintColor = .appBeige100
        button.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        button.contentHorizontalAlignment = .leading

        return button
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()

        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .white
        label.textAlignment = .right
        if let price {
            label.text = "\(price) ₽"
        } else {
            label.isHidden = true
        }

        return label
    }()

    // MARK: - Lifecycle

    init(price: Int? = nil) {
        self.price = price?.formattedString()
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setItemsCount(to value: Int) {
        if value == itemsCount {
            return
        }

        itemsCount = max(0, value)
    }
}

private extension CartButtonView {
    func setupView() {
        addSubviews(plateView, showCartButton)
        plateView.addSubviews(titleLabel, priceLabel, plateViewButton, countLabel, decrementButton, incrementButton)
    }

    func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }

        plateView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.left.equalToSuperview()
            self.plateViewRightConstraint = make.right.equalToSuperview().constraint
        }

        plateViewButton.snp.makeConstraints { make in
            make.edges.equalTo(plateView)
        }

        showCartButton.snp.makeConstraints { make in
            make.size.equalTo(56)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }

        priceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }

        incrementButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.right.equalToSuperview().inset(12)
            make.width.equalTo(28)
        }

        countLabel.snp.makeConstraints { make in
            make.right.equalTo(incrementButton.snp.left)
            make.width.equalTo(dynamicValue(forSize: 40))
            make.centerY.equalToSuperview()
        }

        decrementButton.snp.makeConstraints { make in
            make.right.equalTo(countLabel.snp.left)
            make.width.equalTo(28)
            make.verticalEdges.equalToSuperview()
        }
    }

    func updateView(oldValue: Int, newValue: Int) {
        if newValue != 0 { countLabel.text = String(newValue) }

        if newValue == 1 && oldValue == 0 {
            self.showCartButton.isHidden = false
            self.countLabel.isHidden = false
            self.decrementButton.isHidden = false
            self.incrementButton.isHidden = false

            UIView.animate(withDuration: 0.2, animations: {
                self.countLabel.layer.opacity = 1
                self.decrementButton.layer.opacity = 1
                self.incrementButton.layer.opacity = 1
                self.titleLabel.textColor = .appBeige100
                self.titleLabel.textAlignment = .left
                self.titleLabel.text = "В корзине"
                self.showCartButton.layer.opacity = 1
                self.plateView.backgroundColor = .white
                self.plateViewRightConstraint?.update(inset: 64)
                self.layoutIfNeeded()
            })
        } else if newValue == 0 {
            UIView.animate(withDuration: 0.2, animations: {
                self.countLabel.layer.opacity = 0
                self.decrementButton.layer.opacity = 0
                self.incrementButton.layer.opacity = 0
                self.titleLabel.textColor = .white
                self.titleLabel.textAlignment = self.price != nil ? .left : .center
                self.titleLabel.text = "В корзину"
                self.showCartButton.layer.opacity = 0
                self.plateView.backgroundColor = .appBeige100
                self.plateViewRightConstraint?.update(inset: 0)
                self.layoutIfNeeded()
            }, completion: { _ in
                self.showCartButton.isHidden = true
                self.countLabel.isHidden = true
                self.decrementButton.isHidden = true
                self.incrementButton.isHidden = true
            })
        }
    }
}

extension CartButtonView {
    @objc
    func plateViewTapped() {
        itemsCount = max(itemsCount, 1)
    }

    @objc 
    func addItem() {
        itemsCount += 1
    }

    @objc 
    func removeItem() {
        itemsCount -= 1
    }

    @objc
    func showCartButtonTapped() {
        delegate?.showCart()
    }
}
