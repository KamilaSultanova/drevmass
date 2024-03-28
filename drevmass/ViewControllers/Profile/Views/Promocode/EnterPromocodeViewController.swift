//
//  EnterPromocodeViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 15.03.2024.
//

import UIKit
import PanModal
import SnapKit
import Alamofire

class EnterPromocodeViewController: UIViewController, PanModalPresentable {
    
    // MARK: - UI Elements
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(490)
        }
    
    var cornerRadius: CGFloat = 24
    var panModalBackgroundColor: UIColor = .appModalBackground
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    private lazy var promocodeTextField: UITextField = {
        let textfield = UITextField()
        
        textfield.borderStyle = .none
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray60,
            .font: UIFont.appFont(ofSize: 20, weight: .semiBold)
        ]
        
        let attributedPlaceholder = NSAttributedString(string: "Введите промокод", attributes: placeholderAttributes)
        textfield.textColor = .appDark100
        textfield.font = .appFont(ofSize: 20, weight: .semiBold)
  
        textfield.attributedPlaceholder = attributedPlaceholder
        textfield.autocorrectionType = .no
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 56))
        textfield.leftView = leftPaddingView
        textfield.leftViewMode = .always
        textfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
       
        return textfield
    }()
    
    private lazy var lineImageView: UIImageView = {
        let image = UIImageView()
        image.image = .frame.withTintColor(.appBeige100)
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    private lazy var promocodeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .promocode
        
        return imageView
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Применить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBeige100
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.addTarget(self, action: #selector(applyPromocode), for: .touchDown)
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Неверный промокод"
        label.textColor = UIColor(red: 0.98, green: 0.36, blue: 0.36, alpha: 1.00)
        label.textAlignment = .left
        label.font = .appFont(ofSize: 13, weight: .medium)
        
        return label
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
        errorLabel.isHidden = true
        promocodeTextField.becomeFirstResponder()
    }
    func setupUI(){
        view.addSubviews(promocodeTextField, applyButton, promocodeIcon, lineImageView, errorLabel)
    }
    
    func setupConstraints(){
        promocodeTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        
        lineImageView.snp.makeConstraints { make in
            make.bottom.equalTo(promocodeTextField.snp.bottom)
            make.horizontalEdges.equalTo(promocodeTextField)
            make.height.equalTo(2)
        }
        
        promocodeIcon.snp.makeConstraints { make in
            make.centerY.equalTo(promocodeTextField)
            make.left.equalTo(promocodeTextField.snp.left)
            make.size.equalTo(24)
        }
        
        applyButton.snp.makeConstraints { make in
            make.top.equalTo(promocodeTextField.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(promocodeTextField)
            make.bottom.equalTo(applyButton.snp.top).offset(-10)
        }
    }
}

extension EnterPromocodeViewController{
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.text = textField.text?.uppercased()
        errorLabel.isHidden = true
        lineImageView.image = .frame.withTintColor(.appBeige100)
        promocodeIcon.image = .promocode
    }
    
    @objc
    func applyPromocode(){
        var promocode = promocodeTextField.text ?? ""
        
        if promocode.isEmpty{
            errorLabel.isHidden = false
            errorLabel.text = "Введите промокод"
            lineImageView.image = .frame.withTintColor(UIColor(red: 0.98, green: 0.36, blue: 0.36, alpha: 1.00))
            promocodeIcon.image = .promocode.withTintColor(UIColor(red: 0.98, green: 0.36, blue: 0.36, alpha: 1.00))
            
        }else{
            let parameters = ["promocode": promocode]
            
            AF.request(
                Endpoints.activatePromocode.value,
                method: .post,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: [.authorization(bearerToken: AuthService.shared.token)]
            ).validate(statusCode: 200..<300).response { [self] response in
                switch response.result {
                case .success(_):
                    if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let message = json["message"] as? String {
                        dismiss(animated: true)
                        showToast(type: .success, title: message)
                    } else {
                        dismiss(animated: true)
                        showToast(type: .success, title: "Промокод успешно применен!")
                    }
                case .failure(let error):
                    if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let message = json["message"] as? String {
                        errorLabel.isHidden = false
                        errorLabel.text = "\(message)"
                        lineImageView.image = .frame.withTintColor(UIColor(red: 0.98, green: 0.36, blue: 0.36, alpha: 1.00))
                        promocodeIcon.image = .promocode.withTintColor(UIColor(red: 0.98, green: 0.36, blue: 0.36, alpha: 1.00))
                    } else {
                        print("Unknown server error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
