//
// SortingTypeCell
// Created by Nurasyl on 20.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit

final class SortingTypeCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = "SortingTypeCell"

    // MARK: - Lifecycle

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.font = .appFont(ofSize: 17)
        label.textColor = .appDark90

        return label
    }()

    private lazy var radioView: UIView = {
        let view = UIView()

        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.appBeige50.cgColor

        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private extension

private extension SortingTypeCell {
    func setupViews() {
        selectionStyle = .none
        contentView.addSubviews(radioView, titleLabel)
    }

    func setupConstraints() {
        radioView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalTo(radioView.snp.leading)
        }
    }
}

extension SortingTypeCell {
    func setData(sortingType: SortingType, text: String, selected: Bool = false) {
        titleLabel.text = text

        if selected {
            radioView.layer.borderWidth = 6
            radioView.layer.borderColor = UIColor.appBeige100.cgColor
        }
    }
}
