//
// CourseTableViewCell
// Created by Kamila Sultanova on 07.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class CourseTableViewCell: UITableViewCell {
	
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
		let imageview = UIImageView()
		
		imageview.contentMode = .scaleAspectFill
		imageview.layer.cornerRadius = 16
		imageview.clipsToBounds = true
		
		return imageview
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		
		label.font = .appFont(ofSize: 17, weight: .semiBold)
		label.textColor = .appDark100
		label.textAlignment = .left
		label.numberOfLines = 2
		
		return label
	}()
	
	private lazy var lessonInfoLabel: UILabel = {
		let label = UILabel()
		
		label.font = .appFont(ofSize: 13, weight: .semiBold)
		label.textColor = .appGray70
		
		return label
	}()
	
	private lazy var bonusView: UIView = {
		let view = UIView()
		
		view.backgroundColor = UIColor(red: 0.94, green: 0.92, blue: 0.91, alpha: 1)
		view.layer.cornerRadius = 12
		view.clipsToBounds = true
		
		return view
	}()
	
	private lazy var bonusLabel: UILabel = {
		let label = UILabel()
		
		label.font = .appFont(ofSize: 13, weight: .semiBold)
		label.textColor = .appDark100
		
		return label
	}()
	
	private lazy var bonusImageview: UIImageView = {
		let imageview = UIImageView()
		
		imageview.contentMode = .scaleAspectFit
		imageview.image = .Course.bonus
		
		return imageview
	}()
	
	// MARK: - Lifecycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setData(course: Course) {
		titleLabel.text = course.name
        let lessonCount = course.number
        let (lessonString, suffix) = lessonCount.lessons()
		imageview.sd_setImage(with: URL(string: course.image))
		
		let regularAttributes: [NSAttributedString.Key: Any] = [
			.font: UIFont.appFont(ofSize: 13)
		]
		let semiboldAttributes: [NSAttributedString.Key: Any] = [
			.font: UIFont.appFont(ofSize: 13, weight: .semiBold)
		]
		let boldAttributes: [NSAttributedString.Key: Any] = [
			.font: UIFont.appFont(ofSize: 13, weight: .bold)
		]
        
        let lessonCountAttributedString = NSAttributedString(string: "\(course.number)", attributes: boldAttributes)
        let lessonSuffixAttributedString = NSAttributedString(string: " \(lessonString)\(suffix)", attributes: regularAttributes)

        let attributedString = NSMutableAttributedString()
        attributedString.append(lessonCountAttributedString)
        attributedString.append(lessonSuffixAttributedString)
		attributedString.append(NSAttributedString(string: " · ", attributes: semiboldAttributes))
		attributedString.append(NSAttributedString(string: "\(course.duration)", attributes: boldAttributes))
		attributedString.append(NSAttributedString(string: " мин", attributes: regularAttributes))
		
		lessonInfoLabel.attributedText = attributedString
		
        if course.bonus.price == 0 {
			bonusView.isHidden = true
		}
        bonusLabel.text = "+\(course.bonus.price)"
	}
}

extension Int {
    func lessons() -> (String, String) {
        var lessonString: String!
        var suffix: String!
        if self == 1 || (self % 10 == 1 && self % 100 != 11) {
            lessonString = "урок"
            suffix = ""
        } else if (2...4).contains(self % 10) && !(12...14).contains(self % 100) {
            lessonString = "урок"
            suffix = "а"
        } else {
            lessonString = "урок"
            suffix = "ов"
        }
        return (lessonString, suffix)
    }
}

private extension CourseTableViewCell {
	func setupViews() {
		contentView.addSubview(backgroundview)
		backgroundview.addSubviews(imageview, lessonInfoLabel, titleLabel, bonusView)
		bonusView.addSubviews(bonusLabel, bonusImageview)
	}
	
	func setupConstraints() {
		backgroundview.snp.makeConstraints { make in
			make.top.horizontalEdges.equalToSuperview()
			make.bottom.equalToSuperview().inset(12)
			make.height.equalTo(124)
		}
		
		imageview.snp.makeConstraints { make in
			make.top.left.equalToSuperview().inset(8)
			make.height.equalTo(108)
			make.width.equalTo(96)
		}
		
		lessonInfoLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().inset(10)
			make.left.equalTo(imageview.snp.right).offset(12)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(lessonInfoLabel.snp.bottom).offset(4)
			make.left.equalTo(lessonInfoLabel)
			make.right.equalToSuperview().inset(8)
		}
		
		bonusView.snp.makeConstraints { make in
			make.right.equalToSuperview().inset(8)
			make.centerY.equalTo(lessonInfoLabel)
			make.height.equalTo(24)
		}
		
		bonusLabel.snp.makeConstraints { make in
			make.left.equalToSuperview().inset(8)
			make.centerY.equalTo(bonusView)
		}
		
		bonusImageview.snp.makeConstraints { make in
			make.left.equalTo(bonusLabel.snp.right).offset(4)
			make.centerY.equalToSuperview()
			make.size.equalTo(20)
			make.right.equalToSuperview().inset(2)
		}
	}
}
