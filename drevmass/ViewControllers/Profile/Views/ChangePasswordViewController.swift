//
//  ChangePasswordViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 14.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - UI Elements
    
    private var typeOfInputs: [TextFieldWithPadding: UILabel] = [:]
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.action = #selector(backButtonTapped)
        button.target = self
        button.image = .back
        return button
    }()
    
    private lazy var currentPasswordTextField: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        
        textfield.borderStyle = .none
        textfield.autocorrectionType = .no
        textfield.isEnabled = true
        textfield.delegate = self

        textfield.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray60,
            .font: UIFont.appFont(ofSize: 17, weight: .semiBold)
        ]

        let attributedPlaceholder = NSAttributedString(string: "Введите текущий пароль", attributes: placeholderAttributes)

        textfield.attributedPlaceholder = attributedPlaceholder
        textfield.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textEditDidEnd), for: .editingDidEnd)
        textfield.addTarget(self, action: #selector(textEditDidBegin), for: .editingDidBegin)
        
        let typeOfInput = UILabel()
        typeOfInput.font = .appFont(ofSize: 13, weight: .medium)
        typeOfInput.text = "Введите текущий пароль"
        typeOfInput.textColor = .appGray70
        typeOfInput.textAlignment = .left
        
        
        textfield.addSubview(typeOfInput)
        typeOfInput.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }

        self.typeOfInputs[textfield] = typeOfInput
     
        return textfield
    }()
    
    private lazy var showCurrentPasswordButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.setImage(.show, for: .normal)
        button.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var forgottenPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Забыли пароль?", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.appBeige100, for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
        button.addTarget(self, action: #selector(forgottenPasswordTaped), for: .touchDown)
        return button
    }()
    
    private lazy var newPasswordTextField: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        
        textfield.borderStyle = .none
        textfield.autocorrectionType = .no
        textfield.isEnabled = true
        textfield.delegate = self
        textfield.isSecureTextEntry = true

        textfield.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray60,
            .font: UIFont.appFont(ofSize: 17, weight: .semiBold)
        ]

        let attributedPlaceholder = NSAttributedString(string: "Введите новый пароль", attributes: placeholderAttributes)

        textfield.attributedPlaceholder = attributedPlaceholder
        textfield.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textEditDidEnd), for: .editingDidEnd)
        textfield.addTarget(self, action: #selector(textEditDidBegin), for: .editingDidBegin)
        
        let typeOfInput = UILabel()
        typeOfInput.font = .appFont(ofSize: 13, weight: .medium)
        typeOfInput.text = "Введите новый пароль"
        typeOfInput.textColor = .appGray70
        typeOfInput.textAlignment = .left
        
        
        textfield.addSubview(typeOfInput)
        typeOfInput.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }

        self.typeOfInputs[textfield] = typeOfInput
     
        return textfield
    }()
    
    private lazy var showNewPasswordButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.setImage(.show, for: .normal)
        button.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        
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
        title = "Сменить пароль"
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .appBeige100
        configureViews()
        setupUI()
        setupConstraints()
        textfieldSetupDoneButton()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

private extension ChangePasswordViewController {
    private func setupUI() {
        view.addSubviews(currentPasswordTextField, resetButton, forgottenPasswordButton, showCurrentPasswordButton, newPasswordTextField, showNewPasswordButton)
    }
    
    private func setupConstraints() {
        currentPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        resetButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        forgottenPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(currentPasswordTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        
        showCurrentPasswordButton.snp.makeConstraints { make in
            make.centerY.equalTo(currentPasswordTextField)
            make.right.equalTo(currentPasswordTextField.snp.right)
            make.size.equalTo(24)
        }
        
        newPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(forgottenPasswordButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        
        showNewPasswordButton.snp.makeConstraints { make in
            make.centerY.equalTo(newPasswordTextField)
            make.right.equalTo(newPasswordTextField.snp.right)
            make.size.equalTo(24)
        }
    }
    
    private func configureViews() {
        if currentPasswordTextField.text!.isEmpty{
            if let typeOfInput = typeOfInputs[currentPasswordTextField] {
                typeOfInput.isHidden = true
            }else{
                if let typeOfInput = typeOfInputs[currentPasswordTextField] {
                    typeOfInput.isHidden = false
                }
            }
        }
        
        if newPasswordTextField.text!.isEmpty{
            if let typeOfInput = typeOfInputs[newPasswordTextField] {
                typeOfInput.isHidden = true
            }else{
                if let typeOfInput = typeOfInputs[newPasswordTextField] {
                    typeOfInput.isHidden = false
                }
            }
        }
    }
}

private extension ChangePasswordViewController{
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
    
    private func textfieldSetupDoneButton() {
        let currentPasswordToolbar = UIToolbar()
        currentPasswordToolbar.sizeToFit()
        let currentPasswordButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(currentPasswordButtonTapped))
        currentPasswordButton.tintColor = .appBeige100
        currentPasswordToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), currentPasswordButton]
        
        let newPasswordToolbar = UIToolbar()
        newPasswordToolbar.sizeToFit()
        let newPasswordButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(newPasswordButtonTapped))
        newPasswordButton.tintColor = .appBeige100
        newPasswordToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), newPasswordButton]
        
        currentPasswordTextField.inputAccessoryView = currentPasswordToolbar
        newPasswordTextField.inputAccessoryView = newPasswordToolbar
    }
    
    @objc func currentPasswordButtonTapped() {
        currentPasswordTextField.resignFirstResponder()
    }
    
    @objc func newPasswordButtonTapped() {
        newPasswordTextField.resignFirstResponder()
    }
    
    @objc
    func textEditDidBegin(_ sender: TextFieldWithPadding) {
        sender.bottomBorderColor = .appBeige100
    }
    
    @objc
    func textEditDidChanged(_ sender: TextFieldWithPadding) {
        resetButton.isEnabled = true
        resetButton.backgroundColor = .appBeige100
        sender.bottomBorderColor = .appBeige100
        if let typeOfInput = typeOfInputs[sender] {
            typeOfInput.textColor = .appBeige100
            typeOfInput.isHidden = false
        }
        configureViews()
    }
    
    
    @objc
    func textEditDidEnd(_ sender: TextFieldWithPadding) {
        if let typeOfInput = typeOfInputs[sender] {
            typeOfInput.textColor = .appGray70
            typeOfInput.isHidden = false
        }
        sender.bottomBorderColor = .appGray50
        
    }
    
    @objc
    func showPassword(_ sender : UIButton) {
        if sender.isEqual(showCurrentPasswordButton) {
            currentPasswordTextField.isSecureTextEntry = !currentPasswordTextField.isSecureTextEntry
        }
        else if sender.isEqual(showNewPasswordButton) {
            newPasswordTextField.isSecureTextEntry = !newPasswordTextField.isSecureTextEntry
        }
    }
    
    @objc
    func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func forgottenPasswordTaped(){
        let passwordResetVC = PasswordResetViewController()
        present(UINavigationController(rootViewController: passwordResetVC), animated: true)
    }
    
    @objc
    func reset(){
        var currentPassword: String = currentPasswordTextField.text!
        var newPassword: String = newPasswordTextField.text!
        
        let parameters: [String: Any] = [
            "current_password": currentPassword,
            "new_password": newPassword
        ]
        
        AF.request(Endpoints.changePassword.value, method: .post, parameters: parameters,  encoding: JSONEncoding.default, headers: [
            .authorization(bearerToken: AuthService.shared.token)]).responseData{ [self]
                response in
                
                var resultString = ""
                if let data = response.data{
                    resultString = String(data: data, encoding: .utf8)!
                    print(resultString)
                }
                
                if response.response?.statusCode == 200{
                    let json = JSON(response.data!)
                    print("JSON: \(json)")
                    
                    if let currentPassword = json["current_password"].string {
                        self.currentPasswordTextField.text = currentPassword
                    }
                    
                    if let newPassword = json["new_password"].string {
                        self.newPasswordTextField.text = newPassword
                    }
                    self.showToast(type: .success, title: "Пароль успешно изменен")
                    self.dismiss(animated: true)
                    
                }else {
                    self.showToast(type: .error, title: "Пароли не совпадают")
                    if currentPasswordTextField.text!.isEmpty {
                        currentPasswordTextField.bottomBorderColor = .red
                    }
                    if currentPasswordTextField.text!.isEmpty {
                        currentPasswordTextField.bottomBorderColor = .red
                    }
                    
                }
            }
        
    }
}
