//
// CourseLessonCollectionViewCell
// Created by Kamila Sultanova on 14.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SnapKit

class MarkedLessonCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private lazy var backgroundview: UIView = {
        let view = UIView()
        
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.appBeige30.cgColor
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        
        return view
    }()

    private lazy var imageview: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
      
        return imageView
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.Course.playButton, for: .normal)
        
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.CourseButton.bookmarkFilled, for: .normal)
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .appFont(ofSize: 15, weight: .semiBold)
        label.textColor = .appDark100
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        
        label.font = .appFont(ofSize: 13, weight: .medium)
        label.textColor = .appGray70
        label.textAlignment = .left
        label.numberOfLines = 1
        
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
    
    func setData(lesson: CourseDetail.Lesson) {
        imageview.sd_setImage(with: URL(string: lesson.image))
        titleLabel.text = lesson.title
        durationLabel.text = "\(lesson.id) урок · \(lesson.duration) мин"
    }
}

private extension MarkedLessonCollectionViewCell {
    func setupViews() {
        contentView.addSubview(backgroundview)
        backgroundview.addSubviews(imageview, playButton, durationLabel, titleLabel, bookmarkButton)
    }
    
    func setupConstraints() {
        backgroundview.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        imageview.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(148)
        }
        
        playButton.snp.makeConstraints { make in
            make.center.equalTo(imageview)
            make.size.equalTo(44)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.equalTo(imageview.snp.top).inset(12)
            make.right.equalTo(imageview.snp.right).inset(12)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(imageview.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(durationLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(durationLabel)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
