//
// SlidesCollectionViewCell
// Created by Kamila Sultanova on 05.03.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SnapKit

class SlidesCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        
        return image
    }()
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .appFont(ofSize: 28, weight: .bold)
        label.textColor = .appDark100
    
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .appFont(ofSize: 17, weight: .regular)
        label.textColor = .appGray80
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SlidesCollectionViewCell {
    func setupViews() {
        contentView.addSubviews(imageView, mainLabel, descriptionLabel)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).inset(30)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    func setData(slide: [String] ) {
        imageView.image = UIImage(named: slide[0])
        mainLabel.text = slide[1]
        descriptionLabel.text = "Здоровье спины – это один из основных показателей комфорта жизни"
    }
}
