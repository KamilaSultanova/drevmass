//
//  DataViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 14.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import KeychainSwift

class DataViewController: UIViewController, UIScrollViewDelegate{
    
    // MARK: - UI Elements
    
    weak var delegate: DataViewControllerDelegate?
    
    private var typeOfInputs: [TextFieldWithPadding: UILabel] = [:]
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isScrollEnabled = true
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view  = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var nameTextField: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        
        textfield.borderStyle = .none
        textfield.autocorrectionType = .no
        textfield.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray60,
            .font: UIFont.appFont(ofSize: 17, weight: .semiBold)
        ]

        let attributedPlaceholder = NSAttributedString(string: "Имя", attributes: placeholderAttributes)

        textfield.attributedPlaceholder = attributedPlaceholder
        
        let typeOfInput = UILabel()
        typeOfInput.font = .appFont(ofSize: 13, weight: .medium)
        typeOfInput.text = "Имя"
        typeOfInput.textColor = .appGray70
        typeOfInput.textAlignment = .left
        
        textfield.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textEditDidBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textEditDidEnd), for: .editingDidEnd)
        
        textfield.addSubview(typeOfInput)
        typeOfInput.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        self.typeOfInputs[textfield] = typeOfInput
        
        return textfield
    }()
    
    private lazy var phoneTextField: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        
        textfield.borderStyle = .none
        textfield.autocorrectionType = .no
        textfield.keyboardType = .phonePad
        textfield.delegate = self
       
        textfield.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray60,
            .font: UIFont.appFont(ofSize: 17, weight: .semiBold)
        ]

        let attributedPlaceholder = NSAttributedString(string: "Номер телефона", attributes: placeholderAttributes)

        textfield.attributedPlaceholder = attributedPlaceholder
        
        let typeOfInput = UILabel()
        typeOfInput.font = .appFont(ofSize: 13, weight: .medium)
        typeOfInput.text = "Номер телефона"
        typeOfInput.textColor = .appGray70
        typeOfInput.textAlignment = .left
        
        textfield.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textEditDidBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textEditDidEnd), for: .editingDidEnd)
        
        textfield.addSubview(typeOfInput)
        typeOfInput.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        self.typeOfInputs[textfield] = typeOfInput
        
        return textfield
    }()
    
    private lazy var emailTextField: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        
        textfield.borderStyle = .none
        textfield.autocorrectionType = .no
        textfield.isEnabled = false
        textfield.keyboardType = .emailAddress
        textfield.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let typeOfInput = UILabel()
        typeOfInput.font = .appFont(ofSize: 13, weight: .medium)
        typeOfInput.text = "Email"
        typeOfInput.textColor = .appGray70
        typeOfInput.textAlignment = .left
        
        
        textfield.addSubview(typeOfInput)
        typeOfInput.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        return textfield
    }()
    
    private lazy var birthdayDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var birthdayTextField: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        
        textfield.borderStyle = .none
        textfield.autocorrectionType = .no
        textfield.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray60,
            .font: UIFont.appFont(ofSize: 17, weight: .semiBold)
        ]

        let attributedPlaceholder = NSAttributedString(string: "Дата рождения", attributes: placeholderAttributes)

        textfield.attributedPlaceholder = attributedPlaceholder
        
        let typeOfInput = UILabel()
        typeOfInput.font = .appFont(ofSize: 13, weight: .medium)
        typeOfInput.text = "Дата рождения"
        typeOfInput.textColor = .appGray70
        typeOfInput.textAlignment = .left
        
        textfield.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textEditDidBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textEditDidEnd), for: .editingDidEnd)
        
        textfield.addSubview(typeOfInput)
        typeOfInput.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        self.typeOfInputs[textfield] = typeOfInput
        
        return textfield
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cохранить изменения", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBeige100
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.addTarget(self, action: #selector(saveChanges), for: .touchDown)
        
        return button
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
    
    private lazy var clearBirthdayButton: UIButton = {
        let button = UIButton()
        button.setImage(.clear, for: .normal)
        button.addTarget(self, action: #selector(clear), for: .touchDown)
        return button
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonTapped))
        button.tintColor = .appBeige100
        return button
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Пол"
        label.font = .appFont(ofSize: 13, weight: .medium)
        label.textColor = .appGray70
        return label
    }()
    
    private lazy var genderSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Не указано", "Мужской", "Женский"])
        segmentControl.layer.cornerRadius = 8
        segmentControl.clipsToBounds = true
        
        return segmentControl
    }()
    
    private lazy var heightTextField: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        
        textfield.borderStyle = .none
        textfield.autocorrectionType = .no
        textfield.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray60,
            .font: UIFont.appFont(ofSize: 17, weight: .semiBold)
        ]

        let attributedPlaceholder = NSAttributedString(string: "Рост", attributes: placeholderAttributes)

        textfield.attributedPlaceholder = attributedPlaceholder
        
        let typeOfInput = UILabel()
        typeOfInput.font = .appFont(ofSize: 13, weight: .medium)
        typeOfInput.text = "Рост"
        typeOfInput.textColor = .appGray70
        typeOfInput.textAlignment = .left
        
        textfield.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textEditDidBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textEditDidEnd), for: .editingDidEnd)
        
        textfield.addSubview(typeOfInput)
        typeOfInput.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        self.typeOfInputs[textfield] = typeOfInput
        
        return textfield
    }()
    
    private lazy var weightTextField: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        
        textfield.borderStyle = .none
        textfield.autocorrectionType = .no
        textfield.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray60,
            .font: UIFont.appFont(ofSize: 17, weight: .semiBold)
        ]

        let attributedPlaceholder = NSAttributedString(string: "Вес", attributes: placeholderAttributes)

        textfield.attributedPlaceholder = attributedPlaceholder
        
        let typeOfInput = UILabel()
        typeOfInput.font = .appFont(ofSize: 13, weight: .medium)
        typeOfInput.text = "Вес"
        typeOfInput.textColor = .appGray70
        typeOfInput.textAlignment = .left
        
        textfield.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textEditDidBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textEditDidEnd), for: .editingDidEnd)
        
        textfield.addSubview(typeOfInput)
        typeOfInput.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        self.typeOfInputs[textfield] = typeOfInput
        
        return textfield
    }()
    
    private lazy var clearHeightButton: UIButton = {
        let button = UIButton()
        button.setImage(.clear, for: .normal)
        button.addTarget(self, action: #selector(clear), for: .touchDown)
        return button
    }()
    
    private lazy var clearWeightButton: UIButton = {
        let button = UIButton()
        button.setImage(.clear, for: .normal)
        button.addTarget(self, action: #selector(clear), for: .touchDown)
        return button
    }()
    
    private lazy var heightPickerView: UIPickerView = {
         let pickerView = UIPickerView()
         pickerView.delegate = self
         pickerView.dataSource = self
         return pickerView
     }()
        
    private lazy var weightPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var activityLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваша активность"
        label.font = .appFont(ofSize: 13, weight: .medium)
        label.textColor = .appGray70
        return label
    }()
    
    private lazy var activitySegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Низкая", "Средняя", "Высокая"])
        segmentControl.layer.cornerRadius = 8
        segmentControl.clipsToBounds = true
        
        return segmentControl
    }()
    
    private lazy var deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить аккаунт", for: .normal)
       button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
       button.titleLabel?.textAlignment = .left
       button.contentVerticalAlignment = .center
       button.isUserInteractionEnabled = true
       button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
       button.setTitleColor(.Toast.error, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .appBeige100
        navigationItem.largeTitleDisplayMode = .never
        title = "Мои данные"
        setupUI()
        setupConstraints()
        configureViews()
        getUserInfo()
        setupDoneButton()
        textfieldSetupDoneButton()
        heightTextField.inputView = heightPickerView
        weightTextField.inputView = weightPickerView

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    private func setupUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(nameTextField, phoneTextField, emailTextField, birthdayTextField, saveButton, clearNameButton, clearPhoneButton, clearBirthdayButton, genderLabel, genderSegmentControl, heightTextField, weightTextField, clearHeightButton, clearWeightButton, activityLabel, activitySegmentControl, deleteAccountButton)
        birthdayTextField.inputView = birthdayDatePicker
    }

    private func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.bottom.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.horizontalEdges.equalToSuperview().inset(16)
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
            make.horizontalEdges.equalTo(nameTextField)
            make.top.equalTo(phoneTextField.snp.bottom).offset(16)
        }
        
        birthdayTextField.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.horizontalEdges.equalTo(nameTextField)
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
        }
        
        clearBirthdayButton.snp.makeConstraints { make in
            make.centerY.equalTo(birthdayTextField)
            make.right.equalTo(birthdayTextField.snp.right)
            make.size.equalTo(24)
        }
        
        saveButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(birthdayTextField.snp.bottom).offset(16)
        }
        
        genderSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }
        
        heightTextField.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(genderSegmentControl.snp.bottom).offset(16)
            make.width.equalTo(160)
        }
        
        weightTextField.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.equalTo(heightTextField.snp.right).offset(24)
            make.centerY.equalTo(heightTextField)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(160)
        }
        
        clearHeightButton.snp.makeConstraints { make in
            make.centerY.equalTo(heightTextField)
            make.right.equalTo(heightTextField.snp.right)
            make.size.equalTo(24)
        }
        
        clearWeightButton.snp.makeConstraints { make in
            make.centerY.equalTo(weightTextField)
            make.right.equalTo(weightTextField.snp.right)
            make.size.equalTo(24)
        }
        
        activityLabel.snp.makeConstraints { make in
            make.top.equalTo(heightTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        activitySegmentControl.snp.makeConstraints { make in
            make.top.equalTo(activityLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }
       
       deleteAccountButton.snp.makeConstraints { make in
          make.top.equalTo(activitySegmentControl.snp.bottom).offset(16)
          make.left.equalToSuperview().inset(16)
          make.width.equalTo(121)
          make.height.equalTo(44)
       }
    }
    
}

private extension DataViewController{
    
    func configureViews(){
        if nameTextField.state.isEmpty == true{
            clearNameButton.isHidden = true
        }
        if phoneTextField.state.isEmpty == true{
            clearPhoneButton.isHidden = true
        }
        if birthdayTextField.state.isEmpty == true{
            clearBirthdayButton.isHidden = true
        }
        if heightTextField.state.isEmpty == true{
            clearHeightButton.isHidden = true
        }
        
        if weightTextField.state.isEmpty == true{
            clearWeightButton.isHidden = true
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
        
        if sender == birthdayTextField {
            if birthdayTextField.text?.isEmpty == false{
                clearBirthdayButton.isHidden = false
            } else {
                clearBirthdayButton.isHidden = true
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
        
        if sender == heightTextField {
            let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(pickerDoneButtonTapped))
            doneButton.tintColor = .appBeige100
            
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            let toolbar = UIToolbar()
            toolbar.setItems([flexibleSpace, doneButton], animated: false)
            toolbar.sizeToFit()
            sender.inputAccessoryView = toolbar
            
            if heightTextField.text?.isEmpty == false{
                clearHeightButton.isHidden = false
            } else {
                clearHeightButton.isHidden = true
            }
        }
        
        if sender == weightTextField {
            let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(pickerDoneButtonTapped))
            doneButton.tintColor = .appBeige100
            
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            let toolbar = UIToolbar()
            toolbar.setItems([flexibleSpace, doneButton], animated: false)
            toolbar.sizeToFit()
            sender.inputAccessoryView = toolbar
            
            if weightTextField.text?.isEmpty == false{
                clearWeightButton.isHidden = false
            } else {
                clearWeightButton.isHidden = true
            }
        }
        
    }
    
    @objc
    func textEditDidEnd(_ sender: TextFieldWithPadding) {
        if let typeOfInput = typeOfInputs[sender] {
                typeOfInput.textColor = .appGray70
            }
        sender.bottomBorderColor = .appGray50
        if sender == nameTextField {
            clearNameButton.isHidden = true
        }
        if sender == phoneTextField {
            clearPhoneButton.isHidden = true
        }
        if sender == birthdayTextField {
            clearBirthdayButton.isHidden = true
        }
        if sender == heightTextField {
            clearHeightButton.isHidden = true
        }
        if sender == weightTextField {
            clearWeightButton.isHidden = true
        }
    }
    
    @objc
    func textEditDidChanged(_ sender: TextFieldWithPadding) {
        if let typeOfInput = typeOfInputs[sender] {
                typeOfInput.textColor = .appBeige100
            }
        sender.bottomBorderColor = .appBeige100
        
        configureViews()
        
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
        
        if sender == birthdayTextField {
            if birthdayTextField.text!.isEmpty {
                clearBirthdayButton.isHidden = true
            } else {
                clearBirthdayButton.isHidden = false
            }
        }
        if sender == heightTextField {
            if heightTextField.text!.isEmpty {
                clearHeightButton.isHidden = true
            } else {
                clearHeightButton.isHidden = false
            }
        }
        if sender == weightTextField {
            if weightTextField.text!.isEmpty {
                clearWeightButton.isHidden = true
            } else {
                clearWeightButton.isHidden = false
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
        
        if sender == clearBirthdayButton {
            birthdayTextField.text = ""
            clearBirthdayButton.isHidden = true
            configureViews()
        }
        
        if sender == clearHeightButton {
            heightTextField.text = ""
            clearHeightButton.isHidden = true
            if let typeOfInput = typeOfInputs[heightTextField] {
                typeOfInput.isHidden = true
            }
            configureViews()
        }
        if sender == clearWeightButton {
            weightTextField.text = ""
            clearWeightButton.isHidden = true
            if let typeOfInput = typeOfInputs[weightTextField] {
                typeOfInput.isHidden = true
            }
            configureViews()
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        birthdayTextField.text = dateFormatter.string(from: sender.date)
    }
    
    private func setupDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton]
        birthdayTextField.inputAccessoryView = toolbar
    }
    @objc func doneButtonTapped() {
        birthdayTextField.resignFirstResponder()
    }
    
   private func textfieldSetupDoneButton() {
       let nameToolbar = UIToolbar()
       nameToolbar.sizeToFit()
       let nameDoneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(nameDoneButtonTapped))
       nameDoneButton.tintColor = .appBeige100
       nameToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), nameDoneButton]

       let phoneToolbar = UIToolbar()
       phoneToolbar.sizeToFit()
       let phoneDoneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(phoneDoneButtonTapped))
       phoneDoneButton.tintColor = .appBeige100
       phoneToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), phoneDoneButton]

       nameTextField.inputAccessoryView = nameToolbar
       phoneTextField.inputAccessoryView = phoneToolbar
   }

   @objc func nameDoneButtonTapped() {
       nameTextField.resignFirstResponder()
   }

   @objc func phoneDoneButtonTapped() {
       phoneTextField.resignFirstResponder()
   }

    
    @objc func pickerDoneButtonTapped() {
            view.endEditing(true)
        }
   
   @objc
   func deleteTapped(){
       let alertController = UIAlertController(title: "Вы уверены, что хотите удалить аккаунт?", message: "Ваши личные данные и накопленные бонусы будут удалены без возможности восстановления.", preferredStyle: .alert)
   
       let cancelAction = UIAlertAction(title: "Оставить", style: .default, handler: nil)
       alertController.addAction(cancelAction)
       let logoutAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
           AF.request(Endpoints.user.value, method: .delete, headers: [
               .authorization(bearerToken: AuthService.shared.token)
           ]).responseData { response in
               switch response.result {
               case .success(_):
                   KeychainSwift().clear()
                   self.showToast(type: .success, title: "Аккаунт удален")
                   let onboardingVC = OnboardingViewController()
                   let rootVC = UINavigationController(rootViewController: onboardingVC)
                   UIApplication.shared.windows.first?.rootViewController = rootVC
                   UIApplication.shared.windows.first?.makeKeyAndVisible()
                   
               case .failure(let error):
                   self.showToast(type: .error)
               }
           }
       }
       alertController.addAction(logoutAction) 
       self.present(alertController, animated: true, completion: nil)
   }

}

private extension DataViewController{
    func getUserInfo(){
        
        AF.request(Endpoints.userInfo.value, method: .get, headers: [
            .authorization(bearerToken: AuthService.shared.token)
        ]).responseDecodable(of: User.self) { [self] response in
            switch response.result {
            case .success(let user):
                self.nameTextField.text = user.name
                self.emailTextField.text = user.email
                self.genderSegmentControl.selectedSegmentIndex = user.gender
                self.activitySegmentControl.selectedSegmentIndex = user.activity
                self.heightTextField.text = "\(user.height) см"
                self.weightTextField.text = "\(user.weight) кг"
                self.birthdayTextField.text = user.birth
                self.phoneTextField.text = user.phone_number
            case .failure(let error):
                print(error)
                self.showToast(type: .error, title: error.localizedDescription)
            }
        }
    }
    
    @objc func saveChanges(){
            var name: String = nameTextField.text ?? ""
            var gender: Int = genderSegmentControl.selectedSegmentIndex
            var birth: String = birthdayTextField.text ?? ""
            var activity: Int = activitySegmentControl.selectedSegmentIndex
            var phone_number: String = phoneTextField.text ?? ""

            var heightParameter: Int = 0
            var weightParameter: Int = 0
        
            if let heightString = heightTextField.text, let height = Int(heightString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                heightParameter = height
            }

            if let weightString = weightTextField.text, let weight = Int(weightString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                weightParameter = weight
            }
        
        let parameters: [String: Any] = [
            "birth": birth,
            "gender": gender,
            "name": name,
            "phone_number": phone_number,
            "height": heightParameter,
            "weight": weightParameter,
            "activity": activity,
        ]
        
        if nameTextField.text!.isEmpty {
            nameTextField.bottomBorderColor = .red
            saveButton.isEnabled = false
        }
        if phoneTextField.text!.isEmpty {
            phoneTextField.bottomBorderColor = .red
            saveButton.isEnabled = false
        }
        if birthdayTextField.text!.isEmpty {
            birthdayTextField.bottomBorderColor = .red
            saveButton.isEnabled = false
        }
        
        AF.request(Endpoints.userInfo.value, method: .post, parameters: parameters,  encoding: JSONEncoding.default, headers: [
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
                    
                    if let name = json["name"].string {
                        self.nameTextField.text = name
                    }
                    if let phone = json["phone_number"].string {
                        self.phoneTextField.text = phone
                    }
                    if let birth = json["birth"].string {
                        self.birthdayTextField.text = birth
                    }
                       
                    if let gender = json["gender"].int {
                        self.genderSegmentControl.selectedSegmentIndex = gender
                    }
                    if let activity = json["activity"].int {
                        self.activitySegmentControl.selectedSegmentIndex = activity
                    }

                    if let height = json["height"].int {
                        self.heightTextField.text = "\(height)"
                    }

                    if let weight = json["weight"].int {
                        self.weightTextField.text = "\(weight)"
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                    self.showToast(type: .success, title: "Данные успешно сохранены")
                    delegate?.didUpdateProfileData()
                    }else {
                        self.showToast(type: .error, title: "error")
                    }
                }
            }
        }
    


extension DataViewController : UITextFieldDelegate {
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

private extension DataViewController{
    @objc
    func keyboardWillAppear(_ notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
            let keyboardSize = keyboardInfo.cgRectValue.size
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc
    func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}

extension DataViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == heightPickerView {
            return 220 - 100 + 1
        } else if pickerView == weightPickerView {
            return 200 - 30 + 1
        } else {
            return 0
        }
    }
}

// UIPickerViewDelegate methods
extension DataViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == heightPickerView {
            let height = 100 + row
            return "\(height) см"
        } else if pickerView == weightPickerView {
            let weight = 30 + row
            return "\(weight) кг"
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == heightPickerView {
            let selectedHeight = 100 + row
            heightTextField.text = "\(selectedHeight) см"
        } else if pickerView == weightPickerView {
            let selectedWeight = 30 + row
            weightTextField.text = "\(selectedWeight) кг"
        }
    }
}
