//
//  OrderViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 25.03.2024.
//

import UIKit
import SnapKit
import Alamofire

class OrderViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private var typeOfInputs: [TextFieldWithPadding: UILabel] = [:]
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 22, weight: .bold)
        label.text = "Получатель"
        label.textColor = .appDark90
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Получу я", "Другой пользователь"])
        segmentControl.layer.cornerRadius = 8
        segmentControl.clipsToBounds = true
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.appFont(ofSize: 13, weight: .semiBold),
                .foregroundColor: UIColor.appDark100
            ]
            segmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
        
        return segmentControl
    }()
    
    private func configureTextField(_ textField: TextFieldWithPadding, placeholder: String, typeOfInputText: String) {
           textField.borderStyle = .none
           textField.autocorrectionType = .no
           textField.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
           let placeholderAttributes: [NSAttributedString.Key: Any] = [
               .foregroundColor: UIColor.appGray60,
               .font: UIFont.appFont(ofSize: 17, weight: .semiBold)
           ]
           let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
           textField.attributedPlaceholder = attributedPlaceholder
           
           let typeOfInput = UILabel()
           typeOfInput.font = .appFont(ofSize: 13, weight: .medium)
           typeOfInput.text = typeOfInputText
           typeOfInput.textColor = .appGray70
           typeOfInput.textAlignment = .left
                      
           textField.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
           textField.addTarget(self, action: #selector(textEditDidBegin), for: .editingDidBegin)
           textField.addTarget(self, action: #selector(textEditDidEnd), for: .editingDidEnd)
           
           textField.addSubviews(typeOfInput)
           typeOfInput.snp.makeConstraints { make in
               make.top.left.equalToSuperview()
           }
           
           self.typeOfInputs[textField] = typeOfInput
       }
       
       private lazy var nameTextField: TextFieldWithPadding = {
           let textfield = TextFieldWithPadding()
           configureTextField(textfield, placeholder: "Имя", typeOfInputText: "Имя")
           return textfield
       }()
       
       private lazy var phoneTextField: TextFieldWithPadding = {
           let textfield = TextFieldWithPadding()
           configureTextField(textfield, placeholder: "Номер телефона", typeOfInputText: "Номер телефона")
           textfield.keyboardType = .phonePad
           textfield.delegate = self
           return textfield
       }()
       
       private lazy var emailTextField: TextFieldWithPadding = {
           let textfield = TextFieldWithPadding()
           configureTextField(textfield, placeholder: "Email", typeOfInputText: "Email")
           textfield.keyboardType = .emailAddress
           return textfield
       }()
    
    
    private lazy var clearNameButton: UIButton = {
        let button = UIButton()
        button.setImage(.clear, for: .normal)
        button.addTarget(self, action: #selector(clear), for: .touchDown)
        return button
    }()
    
    private lazy var clearPhoneButton: UIButton = {
        let button = UIButton()
        button.setImage(.clear, for: .normal)
        button.addTarget(self, action: #selector(clear), for: .touchDown)
        return button
    }()
    
    private lazy var clearEmailButton: UIButton = {
        let button = UIButton()
        button.setImage(.clear, for: .normal)
        button.addTarget(self, action: #selector(clear), for: .touchDown)
        return button
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Оформление заказа"
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .appBeige100
        navigationController?.navigationBar.prefersLargeTitles = false
        setupUI()
        setupConstraints()
        configureViews()
        segmentControlValueChanged(segmentControl)
    }
}

extension OrderViewController{
    private func setupUI(){
        view.addSubviews(mainLabel, segmentControl, emailTextField, nameTextField, phoneTextField, clearNameButton, clearEmailButton, clearPhoneButton)
    }
    
    private func setupConstraints(){
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(16)
            make.height.equalTo(56)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        clearNameButton.snp.makeConstraints { make in
            make.centerY.equalTo(nameTextField)
            make.right.equalTo(nameTextField.snp.right)
            make.size.equalTo(24)
        }
                
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.horizontalEdges.equalTo(nameTextField)
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
        }
        
        clearPhoneButton.snp.makeConstraints { make in
            make.centerY.equalTo(phoneTextField)
            make.right.equalTo(phoneTextField.snp.right)
            make.size.equalTo(24)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.horizontalEdges.equalTo(phoneTextField)
            make.top.equalTo(phoneTextField.snp.bottom).offset(16)
        }
        
        clearEmailButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextField)
            make.right.equalTo(emailTextField.snp.right)
            make.size.equalTo(24)
        }
    }
}

extension OrderViewController{
    @objc
    private func segmentControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            getUserInfo()
            nameTextField.isEnabled = false
            if let typeOfInput = typeOfInputs[nameTextField] {
                typeOfInput.isHidden = false
            }
            phoneTextField.isEnabled = false
            if let typeOfInput = typeOfInputs[phoneTextField] {
                typeOfInput.isHidden = false
            }
            emailTextField.isEnabled = false
            if let typeOfInput = typeOfInputs[emailTextField] {
                typeOfInput.isHidden = false
            }
        case 1:
            clearTextFields()
        default:
            break
        }
    }
    
    private func clearTextFields() {
        nameTextField.isEnabled = true
        nameTextField.text = ""
        phoneTextField.isEnabled = true
        phoneTextField.text = ""
        emailTextField.isEnabled = true
        emailTextField.text = ""
        configureViews()
    }
    
    private func configureViews(){
        if nameTextField.state.isEmpty == true{
            clearNameButton.isHidden = true
        }
        if phoneTextField.state.isEmpty == true{
            clearPhoneButton.isHidden = true
        }
        if emailTextField.state.isEmpty == true{
            clearEmailButton.isHidden = true
        }
        
        if nameTextField.text!.isEmpty{
            if let typeOfInput = typeOfInputs[nameTextField] {
                typeOfInput.isHidden = true
            }else{
                if let typeOfInput = typeOfInputs[nameTextField] {
                    typeOfInput.isHidden = false
                }
            }
        }
        
        if phoneTextField.text!.isEmpty{
            if let typeOfInput = typeOfInputs[phoneTextField] {
                typeOfInput.isHidden = true
            }else{
                if let typeOfInput = typeOfInputs[phoneTextField] {
                    typeOfInput.isHidden = false
                }
            }
        }
        
        if emailTextField.text!.isEmpty{
            if let typeOfInput = typeOfInputs[emailTextField] {
                typeOfInput.isHidden = true
            }else{
                if let typeOfInput = typeOfInputs[emailTextField] {
                    typeOfInput.isHidden = false
                }
            }
        }
    
    }
    
    @objc
    func textEditDidBegin(_ sender: TextFieldWithPadding) {
        sender.bottomBorderColor = .appBeige100
        if let typeOfInput = typeOfInputs[sender] {
            typeOfInput.textColor = .appBeige100
        }
        if sender == nameTextField {
            if nameTextField.text?.isEmpty == false{
                clearNameButton.isHidden = false
            } else {
                clearNameButton.isHidden = true
            }
        }
        
        if sender == emailTextField {
            if emailTextField.text?.isEmpty == false{
                clearEmailButton.isHidden = false
            } else {
                clearEmailButton.isHidden = true
            }
            
        }
        
        if sender == phoneTextField {
            if phoneTextField.text?.isEmpty == false{
                clearPhoneButton.isHidden = false
            } else {
                clearPhoneButton.isHidden = true
            }
            
            if phoneTextField.text?.isEmpty ?? true {
                phoneTextField.text = "+"
            }
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
        if sender == nameTextField {
            clearNameButton.isHidden = true
        }
        if sender == phoneTextField {
            clearPhoneButton.isHidden = true
        }
        if sender == emailTextField {
            clearEmailButton.isHidden = true
        }
        
        configureViews()
    }
    
    @objc
    func textEditDidChanged(_ sender: TextFieldWithPadding) {
        sender.bottomBorderColor = .appBeige100
        if let typeOfInput = typeOfInputs[sender] {
            typeOfInput.textColor = .appBeige100
            typeOfInput.isHidden = false
        }
        
        if sender == nameTextField {
            if nameTextField.text!.isEmpty {
                clearNameButton.isHidden = true
            } else {
                clearNameButton.isHidden = false
            }
        }
        
        if sender == phoneTextField {
            if phoneTextField.text!.isEmpty {
                clearPhoneButton.isHidden = true
            } else {
                clearPhoneButton.isHidden = false
            }
        }
        
        if sender == emailTextField {
            if emailTextField.text!.isEmpty {
                clearEmailButton.isHidden = true
            } else {
                clearEmailButton.isHidden = false
            }
        }
    }
    
    @objc
    func clear(_ sender: UIButton) {
        if sender == clearNameButton {
            nameTextField.text = ""
            clearNameButton.isHidden = true
            configureViews()
        }
        
        if sender == clearPhoneButton {
            phoneTextField.text = ""
            clearPhoneButton.isHidden = true
            configureViews()
        }
        
        if sender == clearEmailButton {
            emailTextField.text = ""
            clearEmailButton.isHidden = true
            configureViews()
        }
    }
}

extension OrderViewController : UITextFieldDelegate {
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

extension OrderViewController{
    func getUserInfo(){
        
        AF.request(Endpoints.userInfo.value, method: .get, headers: [
            .authorization(bearerToken: AuthService.shared.token)
        ]).responseDecodable(of: User.self) { [self] response in
            switch response.result {
            case .success(let user):
                self.nameTextField.text = user.name
                self.emailTextField.text = user.email
                self.phoneTextField.text = user.phone_number
            case .failure(let error):
                print(error)
                self.showToast(type: .error, title: error.localizedDescription)
            }
        }
    }

}
