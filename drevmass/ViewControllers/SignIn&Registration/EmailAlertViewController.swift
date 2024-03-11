//
// EmailAlertViewController
// Created by Kamila Sultanova on 04.03.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import PanModal
import SnapKit

class EmailAlertViewController: UIViewController, PanModalPresentable {
    
    // MARK: - UI Elements
    
    var longFormHeight: PanModalHeight = .intrinsicHeight
    var cornerRadius: CGFloat = 24
    var panModalBackgroundColor: UIColor = .appModalBackground
    
    var email: String = ""
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Cбросить пароль"
        label.font = .appFont(ofSize: 22, weight: .bold)
        label.textColor = .appDark90
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var alertLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 16, weight: .regular)
        
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray80
        ]
        let emailAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appDark90
        ]
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "На почту ", attributes: regularAttributes))
        attributedString.append(NSAttributedString(string: "\(email)", attributes: emailAttributes))
        attributedString.append(NSAttributedString(string: " мы отправили инструкцию для сброса пароля.", attributes: regularAttributes))
        
        label.attributedText = attributedString
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var alertButton: UIButton = {
        let button = UIButton()
        button.setTitle("Продолжить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBeige100
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.addTarget(self, action: #selector(alert), for: .touchDown)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
    }
}

private extension EmailAlertViewController {
    func setupUI() {
        view.addSubviews(passwordLabel, alertLabel, alertButton)
    }
    
    func setupConstraints() {
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        alertLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        alertButton.snp.makeConstraints { make in
            make.top.equalTo(alertLabel.snp.bottom).offset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
    }
}

private extension EmailAlertViewController {
    @objc
    func alert() {
        self.dismiss(animated: true)
    }
}
