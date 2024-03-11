//
// AlertViewController
// Created by Kamila Sultanova on 14.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    var course: Course
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true

        return view
    }()
    
    private lazy var alertImageView: UIImageView = {
        let imageview = UIImageView()
        
        imageview.contentMode = .scaleAspectFit
        imageview.image = .Course.alert
        
        return imageview
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Поздравляем"
        label.font = .appFont(ofSize: 20, weight: .semiBold)
        label.textColor = .appDark90
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .appFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Вы успешно прошли курс и получаете \(course.bonus.price) бонусов."
        
        return label
    }()
    
    private lazy var alertButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
        button.setTitle("Понятно", for: .normal)
        button.backgroundColor = UIColor(red: 0.71, green: 0.64, blue: 0.5, alpha: 1)
        button.addTarget(self, action: #selector(alertButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(course: Course) {
        self.course = course
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appModalBackground.withAlphaComponent(0)
        
        view.addSubview(backgroundView)
        backgroundView.addSubviews(titleLabel, subtitleLabel, alertButton, alertImageView)
        
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .appModalBackground
            self.backgroundView.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(50)
                make.centerY.equalToSuperview()
                make.height.equalTo(334)
            }
            self.view.layoutIfNeeded()
        })
    }
    
    func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(47)
            make.centerY.equalToSuperview()
        }
        
        alertImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(112)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(alertImageView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        alertButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.height.equalTo(48)
        }
    }
    
    @objc
    func alertButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
