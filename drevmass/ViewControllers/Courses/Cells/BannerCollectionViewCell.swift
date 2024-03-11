//
// BannerCollectionViewCell
// Created by Kamila Sultanova on 08.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class BannerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private lazy var imageView: UIImageView = {
        let imageview = UIImageView()
        
        imageview.layer.cornerRadius = 24
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.image = .Course.greetingBanner
        
        return imageview
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .appDark90
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .appFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BannerCollectionViewCell {
    func setupViews() {
        contentView.addSubview(imageView)
        imageView.addSubviews(titleLabel, subtitleLabel)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(128)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
            make.width.equalTo(195)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.width.equalTo(195)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(titleLabel)
        }
    }
    
    func setData(banner: Banner) {
        titleLabel.text = banner.title
        subtitleLabel.text = banner.subtitle
    }
}
