//
// RegistrationViewController
// Created by Kamila Sultanova on 02.03.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import KeychainSwift

class RegistrationViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var registLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
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
    
    private lazy var nameTextField: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()

        textfield.borderStyle = .none
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray60,
            .font: UIFont.appFont(ofSize: 17, weight: .semiBold)
        ]

        let attributedPlaceholder = NSAttributedString(string: "Ваше имя", attributes: placeholderAttributes)

        textfield.attributedPlaceholder = attributedPlaceholder
        textfield.autocorrectionType = .no
        textfield.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textEditDidBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textEditDidEnd), for: .editingDidEnd)
        
        return textfield
    }()
    
    private lazy var nameIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .nameIcon
        
        return imageView
    }()
    
    private lazy var clearNameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "clear"), for: .normal)
        button.addTarget(self, action: #selector(clear), for: .touchDown)
        return button
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
    
    private lazy var clearEmailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "clear"), for: .normal)
        button.addTarget(self, action: #selector(clear), for: .touchDown)
        return button
    }()
    
    private lazy var phoneTextField: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()

        textfield.borderStyle = .none
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray60,
            .font: UIFont.appFont(ofSize: 17, weight: .semiBold)
        ]

        let attributedPlaceholder = NSAttributedString(string: "Номер телефона", attributes: placeholderAttributes)

        textfield.attributedPlaceholder = attributedPlaceholder
        textfield.keyboardType = .phonePad
        textfield.autocorrectionType = .no
        textfield.delegate = self
        textfield.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textEditDidBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textEditDidEnd), for: .editingDidEnd)
    
        return textfield
    }()
    
    private lazy var maxNumber = 11
    
    private lazy var phoneIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .phone
        
        return imageView
    }()
    
    private lazy var clearPhoneButton: UIButton = {
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

        let attributedPlaceholder = NSAttributedString(string: "Придумайте пароль", attributes: placeholderAttributes)

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
    
    private lazy var enterLabel: UILabel = {
        let label = UILabel()
        label.text = "Уже есть аккаунт?"
        label.font = .appFont(ofSize: 15, weight: .semiBold)
        label.textColor = .appDark90
        
        return label
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.appBeige100, for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
        button.addTarget(self, action: #selector(signIn), for: .touchDown)
        return button
    }()
        
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Продолжить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBeige20
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.addTarget(self, action: #selector(register), for: .touchDown)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .appBeige100
        configureViews()
        setupUI()
        setupConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupUI() {
        view.addSubviews(registLabel, greetLabel, nameTextField, nameIcon, clearNameButton, emailTextField, emailIcon, phoneTextField, phoneIcon, passwordTextField, passwordIcon, showButton, enterLabel, enterButton, continueButton, clearEmailButton, clearPhoneButton)
    }
    
    private func setupConstraints() {
        registLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        
        greetLabel.snp.makeConstraints { make in
            make.top.equalTo(registLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(registLabel)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(greetLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(greetLabel)
            make.height.equalTo(48)
        }
        
        nameIcon.snp.makeConstraints { make in
            make.centerY.equalTo(nameTextField)
            make.left.equalTo(nameTextField.snp.left)
            make.size.equalTo(24)
        }
        
        clearNameButton.snp.makeConstraints { make in
            make.centerY.equalTo(nameTextField)
            make.right.equalTo(nameTextField.snp.right)
            make.size.equalTo(24)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(nameTextField)
            make.height.equalTo(48)
        }
        
        emailIcon.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextField)
            make.left.equalTo(emailTextField.snp.left)
            make.size.equalTo(24)
        }
        
        clearEmailButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextField)
            make.right.equalTo(emailTextField.snp.right)
            make.size.equalTo(24)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(emailTextField)
            make.height.equalTo(48)
        }
        
        phoneIcon.snp.makeConstraints { make in
            make.centerY.equalTo(phoneTextField)
            make.left.equalTo(phoneTextField.snp.left)
            make.size.equalTo(24)
        }
        
        clearPhoneButton.snp.makeConstraints { make in
            make.centerY.equalTo(phoneTextField)
            make.right.equalTo(phoneTextField.snp.right)
            make.size.equalTo(24)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(phoneTextField)
            make.height.equalTo(48)
        }
        
        passwordIcon.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField)
            make.left.equalTo(passwordTextField.snp.left)
            make.size.equalTo(24)
        }
        
        showButton.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField)
            make.right.equalTo(phoneTextField.snp.right)
            make.size.equalTo(24)
        }
        
        enterLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.left.equalTo(continueButton.snp.left).inset(64)
        }
        
        enterButton.snp.makeConstraints { make in
            make.left.equalTo(enterLabel.snp.right).offset(4)
            make.centerY.equalTo(enterLabel)
        }
        
        continueButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(32)
            make.bottom.equalTo(enterLabel.snp.top).offset(-24)
            make.height.equalTo(56)
        }
    }
    
        private func configureViews() {
            if emailTextField.state.isEmpty == true{
                clearEmailButton.isHidden = true
            }
            if nameTextField.state.isEmpty == true{
                clearNameButton.isHidden = true
            }
            if phoneTextField.state.isEmpty == true{
                clearPhoneButton.isHidden = true
            }
            if emailTextField.state.isEmpty || passwordTextField.state.isEmpty || phoneTextField.state.isEmpty || nameTextField.state.isEmpty {
                continueButton.isEnabled = false
                continueButton.backgroundColor = .appBeige20
            }
    }
}

extension RegistrationViewController {
    @objc
    func keyboardWillAppear() {
        continueButton.snp.remakeConstraints { make in
            if #available(iOS 15.0, *) {
                make.horizontalEdges.equalToSuperview().inset(32)
                make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
                make.height.equalTo(56)
            }
        }
    }
    
    @objc
    func keyboardWillHide() {
        continueButton.snp.remakeConstraints { make in
            if #available(iOS 15.0, *) {
                make.horizontalEdges.equalToSuperview().inset(32)
                make.bottom.equalTo(enterLabel.snp.top).offset(-24)
                make.height.equalTo(56)
            }
        }
    }
    
    @objc
    func textEditDidBegin(_ sender: TextFieldWithPadding) {
        sender.bottomBorderColor = .appBeige100
        if sender == nameTextField {
            if nameTextField.text?.isEmpty == false{
                clearNameButton.isHidden = false
            } else {
                clearNameButton.isHidden = true
            }
        }
        if sender == emailTextField {
            emailIcon.image = .mail
            if emailTextField.text?.isEmpty == false{
                clearEmailButton.isHidden = false
            } else {
                clearEmailButton.isHidden = true
            }
        }
        if sender == phoneTextField {
            phoneIcon.image = .phone
            if phoneTextField.text?.isEmpty == false{
                clearPhoneButton.isHidden = false
            } else {
                clearPhoneButton.isHidden = true
            }
            
            if phoneTextField.text?.isEmpty ?? true {
                phoneTextField.text = "+"
            }
        }
    }
    
    @objc
    func textEditDidEnd(_ sender: TextFieldWithPadding) {
        sender.bottomBorderColor = .appGray50
        if sender == nameTextField {
            clearNameButton.isHidden = true
        }
        if sender == emailTextField {
            clearEmailButton.isHidden = true
        }
        if sender == phoneTextField {
            clearPhoneButton.isHidden = true
        }
    }
    
    @objc
    func textEditDidChanged(_ sender: TextFieldWithPadding) {
        configureViews()
        sender.bottomBorderColor = .appBeige100
        if !nameTextField.text!.isEmpty && !emailTextField.text!.isEmpty && !phoneTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
                continueButton.backgroundColor = .appBeige100
                continueButton.isEnabled = true
        }
        
        if sender == nameTextField {
            if nameTextField.text!.isEmpty {
                clearNameButton.isHidden = true
            } else {
                clearNameButton.isHidden = false
            }
            nameIcon.image = .nameIcon
        }
        
        if sender == emailTextField {
            if emailTextField.text!.isEmpty {
                clearEmailButton.isHidden = true
            } else {
                clearEmailButton.isHidden = false
            }
            emailIcon.image = .mail
        }
        
        if sender == phoneTextField {
            if phoneTextField.text!.isEmpty {
                clearPhoneButton.isHidden = true
            } else {
                clearPhoneButton.isHidden = false
            }
            phoneIcon.image = .phone
        }
        
        if sender == passwordTextField {
            passwordIcon.image = .lock
        }
    }
    
    @objc
    func clear(_ sender: UIButton) {
        if sender == clearNameButton {
            nameTextField.text = ""
            clearNameButton.isHidden = true
            configureViews()
        }
        if sender == clearEmailButton {
            emailTextField.text = ""
            clearEmailButton.isHidden = true
            configureViews()
        }
        if sender == clearPhoneButton {
            phoneTextField.text = ""
            clearPhoneButton.isHidden = true
            configureViews()
        }
    }
    
    @objc
    func showPassword() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if passwordTextField.isSecureTextEntry {
            showButton.setImage(UIImage(named: "show"), for: .normal)
        } else {
            showButton.setImage(UIImage(named: "hide"), for: .normal)
        }
    }
    
    @objc
    func signIn() {
        let signInVc = SignInViewController()
        navigationController?.show(signInVc, sender: self)
    }
    
    @objc
    func register() {
        
        let name = nameTextField.text ?? ""
        var email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let phoneNumber = phoneTextField.text ?? ""
        
        email = email.lowercased()
        
        if name.isEmpty {
            nameTextField.bottomBorderColor = .red
            nameIcon.image = .nameIcon.withTintColor(.red)
        }
        
        if email.isEmpty || !email.contains("@") {
            emailTextField.bottomBorderColor = .red
            emailIcon.image = .mail.withTintColor(.red)
        }
        
        if phoneNumber.isEmpty{
            phoneTextField.bottomBorderColor = .red
            phoneIcon.image = .phone.withTintColor(.red)
        }

        if password.isEmpty || password.count < 6||password.range(of: "^[a-zA-Z0-9!@#$%^&*()-_=+\\|[{]};:'\",<.>/?]+$", options: .regularExpression) == nil {
            passwordTextField.bottomBorderColor = .red
            passwordIcon.image = .lock.withTintColor(.red)
        } else {
            let parameters = [
                "email": email,
                "name": name,
                "password": password,
                "phone_number": phoneNumber]
            
            let headers: HTTPHeaders = [
                .authorization(bearerToken: "\(AuthService.shared.token)")
            ]
            
            AF.request(Endpoints.signUp.value, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON {
                    response in
                    switch response.result {
                    case .success:
                        KeychainSwift().set(AuthService.shared.token, forKey: "token")
                        self.startApp()
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.showToast(type: .error, title: error.localizedDescription)
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

extension RegistrationViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            guard let text = textField.text else {return false}
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = formatter(mask: "+X XXX XXX XX XX", phoneNumber: newString)
        }
        return false
    }
    
    func formatter(mask: String, phoneNumber: String) -> String{
        let number = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result: String = ""
        var index = number.startIndex
        
        for character in mask where index < number.endIndex {
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(character)
            }
        }
        
        return result
    }
}
