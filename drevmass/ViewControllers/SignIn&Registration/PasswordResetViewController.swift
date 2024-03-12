//
// PasswordResetViewController
// Created by Kamila Sultanova on 03.03.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class PasswordResetViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.action = #selector(backButtonTapped)
        button.target = self
        button.image = .back
        return button
    }()
    
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите email для сброса пароля."
        label.font = .appFont(ofSize: 15, weight: .regular)
        label.textColor = .appGray80
        
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .appFont(ofSize: 13, weight: .regular)
        label.textColor = .appBeige100
        
        return label
    }()
    
    private lazy var emailTextField: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        
        textfield.borderStyle = .none
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray60,
            .font: UIFont.appFont(ofSize: 17, weight: .semiBold)
        ]

        let attributedPlaceholder = NSAttributedString(string: "Email", attributes: placeholderAttributes)

        textfield.attributedPlaceholder = attributedPlaceholder
        textfield.keyboardType = .emailAddress
        textfield.placeholder = nil
        textfield.autocorrectionType = .no
        textfield.padding.left = 0.0
        textfield.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
    
        return textfield
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "clear"), for: .normal)
        button.addTarget(self, action: #selector(clear), for: .touchDown)
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сбросить пароль", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.83, green: 0.78, blue: 0.70, alpha: 1.00)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.addTarget(self, action: #selector(reset), for: .touchDown)
        
        return button
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Сбросить пароль"    
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .appBeige100
        configureViews()
        setupUI()
        setupConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

private extension PasswordResetViewController {
    func setupUI() {
        view.addSubviews(instructionLabel, emailLabel, emailTextField, clearButton, resetButton)
    }
    
    func setupConstraints() {
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(64)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(instructionLabel)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        clearButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextField)
            make.right.equalTo(emailTextField.snp.right)
            make.size.equalTo(24)
        }
        
        resetButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    func configureViews() {
        clearButton.isHidden = true
    }
}

private extension PasswordResetViewController {
    
    @objc
    func keyboardWillAppear() {
        resetButton.snp.remakeConstraints { make in
            if #available(iOS 15.0, *) {
                make.horizontalEdges.equalToSuperview().inset(32)
                make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-16)
                make.height.equalTo(56)
            }
        }
    }
    
    @objc
    func keyboardWillHide() {
        resetButton.snp.remakeConstraints { make in
            if #available(iOS 15.0, *) {
                make.horizontalEdges.equalToSuperview().inset(32)
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
                make.height.equalTo(56)
            }
        }
    }
    
    @objc
    func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func textEditDidChanged(_ sender: TextFieldWithPadding) {
        clearButton.isHidden = emailTextField.text?.isEmpty ?? true
        
        if !emailTextField.text!.isEmpty {
            resetButton.isEnabled = true
            resetButton.backgroundColor = .appBeige100
        }
    }
    
    @objc
    func clear() {
        emailTextField.text = ""
        clearButton.isHidden = true
        resetButton.isEnabled = false
        resetButton.backgroundColor = UIColor(red: 0.83, green: 0.78, blue: 0.70, alpha: 1.00)
    }
    
    @objc
    func reset() {
        let email = emailTextField.text!.lowercased()
    
        let parameters: [String: Any] = [
            "email": email
        ]
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: "\(AuthService.shared.token)")
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let data = "\(value)".data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        },
        to: Endpoints.resetPassword.value,
        method: .post,
        headers: headers
    ).validate(statusCode: 200..<300).responseJSON {
                response in
                switch response.result {
                case .success:
                    let emailAlertVC = EmailAlertViewController()
                    emailAlertVC.email = self.emailTextField.text!
                    self.presentPanModal(emailAlertVC)
                case .failure(let error):
                    print(error.localizedDescription)
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Response data: \(utf8Text)")
                        }
                        self.showToast(type: .error, title: error.localizedDescription)
                }
            }
    }
}
