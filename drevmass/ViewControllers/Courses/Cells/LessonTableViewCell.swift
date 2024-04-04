//
// LessonTableViewCell
// Created by Kamila Sultanova on 11.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import Alamofire

class LessonTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    weak var delegateCourseDetailVC: CourseDetailViewController?
    
    var lessonID: Int?
    
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
        
        button.setImage(.CourseButton.bookmarkWhite, for: .normal)
        button.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .appDark100
        label.textAlignment = .left
        label.numberOfLines = 4
        
        return label
    }()
    
    private lazy var checkImageView: UIImageView = {
        let imageview = UIImageView()
        
        imageview.image = .Course.check
        imageview.contentMode = .scaleAspectFill
        
        return imageview
    }()
    
   lazy var durationLabel: UILabel = {
        let label = UILabel()
        
        label.font = .appFont(ofSize: 13, weight: .medium)
        label.textColor = .appGray70
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        checkImageView.isHidden = true
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(lesson: LessonProtocol, row: Int) {
        self.lessonID = lesson.id
        imageview.sd_setImage(with: URL(string: "http://45.12.74.158/\(lesson.image)"))
        titleLabel.text = lesson.title
        let fullText = "\(row) урок · \(Int(floor(Double(lesson.duration) / 60.0))) мин"
            
        let attributedText = NSMutableAttributedString(string: fullText)
        
        if lesson.isFavorite {
            bookmarkButton.setImage(UIImage.CourseButton.bookmarkFilled, for: .normal)
                } else {
            bookmarkButton.setImage(UIImage.CourseButton.bookmarkWhite, for: .normal)
            }
        if lesson.completed {
            checkImageView.isHidden = false
            durationLabel.snp.remakeConstraints { make in
                make.top.equalTo(imageview.snp.bottom).offset(8)
                make.right.equalToSuperview().inset(16)
                make.left.equalTo(checkImageView.snp.right).offset(5)
            }
            let range = (fullText as NSString).range(of: "\(row) урок")
            attributedText.addAttribute(.foregroundColor, value: UIColor.systemGreen, range: range)
               } else {
                   
            let range = (fullText as NSString).range(of: "\(row) урок")
            attributedText.addAttribute(.foregroundColor, value: UIColor.appGray70, range: range)
               }
            durationLabel.attributedText = attributedText
        }
    }

extension LessonTableViewCell {
    func setupViews() {
        contentView.addSubview(backgroundview)
        backgroundview.addSubviews(imageview, playButton, durationLabel, titleLabel, bookmarkButton, checkImageView)
    }
    
    func setupConstraints() {
        backgroundview.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
        
        imageview.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(185)
        }
        
        playButton.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(imageview)
            make.size.equalTo(44)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.equalTo(imageview.snp.top).inset(12)
            make.right.equalTo(imageview.snp.right).inset(12)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.centerY.equalTo(durationLabel)
            make.size.equalTo(16)
            make.left.equalToSuperview().inset(16)
        }
    
        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(imageview.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(checkImageView.snp.right).offset(5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(durationLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configureViews() {
        
        if checkImageView.isHidden == true {
            durationLabel.snp.makeConstraints { make in
                make.top.equalTo(imageview.snp.bottom).offset(8)
                make.horizontalEdges.equalToSuperview().inset(16)}
        }
        layoutIfNeeded()
    }
    
    @objc
    func addToFavorite(){
        var method = HTTPMethod.post
        var url = Endpoints.favorites.value

        if let lessonID = self.lessonID {
            if var lesson = delegateCourseDetailVC?.lessonsArray.first(where: { $0.id == lessonID }) {
                method = lesson.isFavorite ? .delete : .post
                url = lesson.isFavorite ? "http://185.100.67.103/api/favorites/\(lessonID)" : Endpoints.favorites.value

                let headers: HTTPHeaders = [
                    .authorization(bearerToken: "\(AuthService.shared.token)")
                ]

                AF.upload(multipartFormData: { multipartFormData in
                    if let textData = "\(lessonID)".data(using: .utf8) {
                            multipartFormData.append(textData, withName: "lesson_id")
                        }
                    },
                to: url,
                method: method,
                headers: headers
                ).validate(statusCode: 200..<300).responseData {
                    response in
                    switch response.result {
                    case .success:
                        lesson.isFavorite.toggle()
                        self.bookmarkButton.setImage(lesson.isFavorite ? UIImage.CourseButton.bookmarkFilled : UIImage.CourseButton.bookmarkWhite, for: .normal)
                            self.delegateCourseDetailVC?.updateLessons()
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.inputViewController?.showToast(type: .error, title: error.localizedDescription)
                    }
                }
            }
        }
    }

}
