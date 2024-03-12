//
// ProfileViewController
// Created by Nurasyl on 22.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var infoView: UIView = {
        let view  = UIView()
        view.backgroundColor = .appBeige100
        
        return view
    }()
    
    private lazy var settingsView: UIView = {
        let view  = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = .appFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "888888888"
        label.font = .appFont(ofSize: 15, weight: .semiBold)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var gradientView: GradientView = {
        let view  = GradientView()
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.horizontalMode = false
        view.startColor = UIColor(red: 0.80, green: 0.73, blue: 0.58, alpha: 1.00)
        view.endColor = UIColor(red: 0.75, green: 0.68, blue: 0.53, alpha: 1.00)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBonus))
        
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        return view
    }()
  
    private lazy var logoImageView: UIImageView = {
        let image = UIImageView()
        image.image = .group
        image.alpha = 0.3
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        
        return image
    }()
    
    private lazy var bonusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Мои баллы", for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(.white, for: .normal)
        button.setImage(.arrow, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentVerticalAlignment = .center
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(tapBonus), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var bonusImageView: UIImageView = {
        let image = UIImageView()
        image.image = .bonusIcon
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        
        return image
    }()
    
    private lazy var bonusLabel: UILabel = {
        let label = UILabel()
        label.text = "500"
        label.font = .appFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        navigationController?.isNavigationBarHidden = true
        setupUI()
        setupConstraints()
    }
}

private extension ProfileViewController {
    func setupUI() {
        view.addSubviews(infoView, settingsView, nameLabel, numberLabel, gradientView)
        gradientView.addSubviews(logoImageView, bonusLabel, bonusButton, bonusImageView)
    }
    
    func setupConstraints() {
        infoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(350)
        }
        
        settingsView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(gradientView.snp.bottom).offset(24)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(46)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }
        
        gradientView.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(bonusButton.snp.right).offset(5)
            make.size.equalTo(245)
        }
        
        bonusButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(24)
            make.height.equalTo(20)
            make.width.equalTo(97)
        }
        
        bonusImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(bonusButton.snp.bottom).offset(13)
            make.size.equalTo(32)
        }
        
        bonusLabel.snp.makeConstraints { make in
            make.left.equalTo(bonusImageView.snp.right).offset(9)
            make.right.equalToSuperview().inset(24)
            make.centerY.equalTo(bonusImageView)
        }
    }
}

private extension ProfileViewController {
    @objc 
    func tapBonus(){
        let myBonusVC = MyBonusViewController()
        navigationController?.pushViewController(myBonusVC, animated: true)
    }
}
