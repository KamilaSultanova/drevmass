//
// SignInViewController
// Created by Kamila Sultanova on 02.03.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import KeychainSwift

class SignInViewController: UIViewController {
    
    // MARK: - UI Elements
        
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "С возвращением!"
        label.font = .appFont(ofSize: 28, weight: .bold)
        label.textColor = .appDark90
        
        return label
    }()
    
    private lazy var greetLabel: UILabel = {
        let label = UILabel()
        label.text = "Мы с вами научимся заниматься на тренажере-массажере для спины \nДревмасс."
        label.font = .appFont(ofSize: 15, weight: .regular)
        label.textColor = .appGray80
        label.numberOfLines = 0
        
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
        textfield.autocorrectionType = .no
        textfield.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textEditDidBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textEditDidEnd), for: .editingDidEnd)
        
        return textfield
    }()
    
    private lazy var emailIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .mail
        
        return imageView
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "clear"), for: .normal)
        button.addTarget(self, action: #selector(clear), for: .touchDown)
        return button
    }()
    
    private lazy var passwordTextField: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()

        textfield.borderStyle = .none
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray60,
            .font: UIFont.appFont(ofSize: 17, weight: .semiBold)
        ]

        let attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: placeholderAttributes)

        textfield.attributedPlaceholder = attributedPlaceholder
        textfield.isSecureTextEntry = true
        textfield.autocorrectionType = .no
        textfield.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textEditDidBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textEditDidEnd), for: .editingDidEnd)
        
        return textfield
    }()
    
    private lazy var passwordIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .lock
        
        return imageView
    }()
    
    private lazy var showButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "show"), for: .normal)
        button.addTarget(self, action: #selector(showPassword), for: .touchDown)
        return button
    }()
    
    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Забыли пароль?", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.appBeige100, for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
        button.addTarget(self, action: #selector(resetPassword), for: .touchDown)
        return button
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Продолжить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBeige20
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.addTarget(self, action: #selector(signIn), for: .touchDown)
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var enterLabel: UILabel = {
        let label = UILabel()
        label.text = "Еще нет аккаунта?"
        label.font = .appFont(ofSize: 15, weight: .semiBold)
        label.textColor = .appDark90
        
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(.appBeige100, for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
        button.addTarget(self, action: #selector(register), for: .touchDown)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .appBeige100
        setupUI()
        setupConstraints()
        configureView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    private func setupUI() {
        view.addSubviews(welcomeLabel, greetLabel, passwordIcon, passwordTextField, emailIcon, emailTextField, showButton, enterButton, registerButton, enterLabel, resetPasswordButton, clearButton)
    }
    
    private func setupConstraints() {
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        
        greetLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(welcomeLabel)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(greetLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(greetLabel)
            make.height.equalTo(48)
        }
        
        emailIcon.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextField)
            make.left.equalTo(emailTextField.snp.left)
            make.size.equalTo(24)
        }
        
        clearButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextField)
            make.right.equalTo(emailTextField.snp.right)
            make.size.equalTo(24)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(emailTextField)
            make.height.equalTo(48)
        }
        
        passwordIcon.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField)
            make.left.equalTo(passwordTextField.snp.left)
            make.size.equalTo(24)
        }
        
        resetPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(passwordTextField)
        }
        
        showButton.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField)
            make.right.equalTo(passwordTextField.snp.right)
            make.size.equalTo(24)
        }
        
        enterLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.left.equalTo(enterButton.snp.left).inset(64)
        }
        
        registerButton.snp.makeConstraints { make in
            make.left.equalTo(enterLabel.snp.right).offset(4)
            make.centerY.equalTo(enterLabel)
        }
        
        enterButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(32)
            make.bottom.equalTo(enterLabel.snp.top).offset(-24)
            make.height.equalTo(56)
        }
    }
}

extension SignInViewController {
    func configureView(){
        if emailTextField.state.isEmpty == true{
            clearButton.isHidden = true
        }
        if emailTextField.state.isEmpty || passwordTextField.state.isEmpty {
            enterButton.isEnabled = false
            enterButton.backgroundColor = .appBeige20
        }
    }
    
    @objc
    func clear() {
        emailTextField.text = ""
        clearButton.isHidden = true
        configureView()
    }
    
    @objc
    func keyboardWillAppear() {
        enterButton.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(32)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-16)
            make.height.equalTo(56)
        }
    }
    
    @objc
    func keyboardWillHide() {
        enterButton.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(32)
            make.bottom.equalTo(enterLabel.snp.top).offset(-24)
            make.height.equalTo(56)
        }
    }
    
    @objc
    func textEditDidBegin(_ sender: TextFieldWithPadding) {
        keyboardWillAppear()
        sender.bottomBorderColor = .appBeige100
        if sender == emailTextField {
            emailIcon.image = .mail
            if emailTextField.text?.isEmpty == false{
                clearButton.isHidden = false
            } else {
                clearButton.isHidden = true
            }
        } else {
            passwordIcon.image = .lock
        }
    }
    
    @objc
    func textEditDidEnd(_ sender: TextFieldWithPadding) {
        sender.bottomBorderColor = .appGray50
        if sender == emailTextField {
            clearButton.isHidden = true
        }
    }
    
    @objc
    func textEditDidChanged(_ sender: TextFieldWithPadding) {
        configureView()
        sender.bottomBorderColor = .appBeige100
        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            enterButton.backgroundColor = .appBeige100
            enterButton.isEnabled = true
        }
        
        if sender == emailTextField {
            if emailTextField.text!.isEmpty{
                clearButton.isHidden = true
            }else{
                clearButton.isHidden = false
            }
        }
        
        
        switch sender {
        case emailTextField:
            return emailIcon.image = .mail
        case passwordTextField:
            return passwordIcon.image = .lock
        default:
            break
        }
    }
    
    @objc
    func showPassword() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        passwordTextField.isSecureTextEntry ? showButton.setImage(UIImage(named: "show"), for: .normal) :  showButton.setImage(UIImage(named: "hide"), for: .normal)
    }
    
    @objc
    func register() {
        let registrationVC = RegistrationViewController()
        navigationController?.show(registrationVC, sender: self)
    }
    
    @objc
    func resetPassword() {
        let passwordResetVC = PasswordResetViewController()
        present(UINavigationController(rootViewController: passwordResetVC), animated: true)
    }
    
    @objc
    func signIn() {
        
        var email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        email = email.lowercased()
        
        if email.isEmpty || !email.contains("@") {
            emailTextField.bottomBorderColor = .red
            emailIcon.image = .mail.withTintColor(.red)
        }
        
       if password.isEmpty || password.range(of: "^[a-zA-Z0-9!@#$%^&*()-_=+\\|[{]};:'\",<.>/?]+$", options: .regularExpression) == nil {
            passwordTextField.bottomBorderColor = .red
            passwordIcon.image = .lock.withTintColor(.red)
           
        } else {
            let parameters = [
                "email": email,
                "password": password
            ]
            
            let headers: HTTPHeaders = [
                .authorization(bearerToken: "\(AuthService.shared.token)")
            ]
            
            AF.request(Endpoints.login.value, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseData {
                    response in
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        if let token = json["access_token"].string{
                            AuthService.shared.token = token
                        }
                        self.startApp()
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.emailTextField.bottomBorderColor = .red
                        self.emailIcon.image = .mail.withTintColor(.red)
                        self.passwordTextField.bottomBorderColor = .red
                        self.passwordIcon.image = .lock.withTintColor(.red)
                        self.showToast(type: .error, title: "Неправильный логин или пароль")
                    }
            }
        }
    }
    
    func startApp() {
        let tabBarVC = TabBarController()
        
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: true )
    }
}
