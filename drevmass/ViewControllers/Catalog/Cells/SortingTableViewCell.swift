//
//  SortingTableViewCell.swift
//  drevmass
//
//  Created by Kamila Sultanova on 18.03.2024.
//

import UIKit
import SnapKit

class SortingTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .appFont(ofSize: 17, weight: .regular)
        label.textColor = .appDark100
        label.textAlignment = .left

        return label
    }()
    
    private lazy var checkView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.appBeige50.cgColor
        
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")}
    
}

extension SortingTableViewCell {
    func setupUI(){
        contentView.addSubviews(titleLabel, checkView)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        checkView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    
    func setData(with sortingType: SortingType, selected: Bool) {
            titleLabel.text = sortingType.rawValue
            updateBorder(isSelected: selected)
        }
    
    func updateBorder(isSelected: Bool) {
        checkView.layer.borderWidth = isSelected ? 6 : 2
        checkView.layer.borderColor = isSelected ? UIColor.appBeige100.cgColor : UIColor.appBeige50.cgColor
    }

}
