//
//  BonusTableViewCell.swift
//  drevmass
//
//  Created by Kamila Sultanova on 14.03.2024.
//

import UIKit
import SnapKit

class BonusTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private lazy var bonusTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .regular)
        label.textColor = .appDark90
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 13, weight: .regular)
        label.textColor = .appGray70
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var plusOrMinusLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .bold)
        label.textColor = .appDark90
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var bonusAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .bold)
        label.textColor = .appDark90
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var bonusIcon: UIImageView = {
        let image = UIImageView()
        image.image = .Course.bonus
        image.contentMode = .scaleAspectFit
    
        return image
    }()
    
    private lazy var lineImageView: UIImageView = {
        let image = UIImageView()
        image.image = .divider.withTintColor(.appGray60)
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")}
    
    func setupViews(){
        contentView.addSubviews(bonusTypeLabel, dateLabel, bonusIcon,plusOrMinusLabel, bonusAmountLabel, lineImageView)
    }
    
    func setupConstraints(){
        bonusTypeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview()
            make.width.equalTo(255)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(bonusTypeLabel.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(255)
            make.bottom.equalToSuperview().inset(16)
        }
        
        bonusIcon.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        bonusAmountLabel.snp.makeConstraints { make in
            make.right.equalTo(bonusIcon.snp.left).offset(-4)
            make.centerY.equalTo(bonusIcon)
        }
        
        plusOrMinusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bonusIcon)
            make.right.equalTo(bonusAmountLabel.snp.left)
        }
        
        lineImageView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setData(bonus: Bonus.Transactions) {
        bonusTypeLabel.text = bonus.description
        plusOrMinusLabel.text = bonus.transactionType
        if bonus.transactionType == "-"{
            plusOrMinusLabel.textColor = .red
            bonusAmountLabel.textColor = .red
        }
        bonusAmountLabel.text = "\(bonus.promoPrice)"
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: bonus.transactionDate) {
                dateFormatter.locale = Locale(identifier: "ru_RU")
                dateFormatter.dateFormat = "dd MMMM yyyy"
                let formattedDate = dateFormatter.string(from: date)
                dateLabel.text = formattedDate
            } else {
                dateLabel.text = "Неверная дата"
            }
    }
}
