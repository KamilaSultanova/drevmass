//
//  EnterPromocodeViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 15.03.2024.
//

import UIKit
import PanModal
import SnapKit

class EnterPromocodeViewController: UIViewController, PanModalPresentable {
    
    // MARK: - UI Elements
    
    var longFormHeight: PanModalHeight = .intrinsicHeight
    var cornerRadius: CGFloat = 24
    var panModalBackgroundColor: UIColor = .appModalBackground
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    private var keyboardHeight: CGFloat = 0
    
    private lazy var promocodeTextField: UITextField = {
        let textfield = UITextField()
        
        textfield.borderStyle = .none
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray60,
            .font: UIFont.appFont(ofSize: 20, weight: .semiBold)
        ]

        let attributedPlaceholder = NSAttributedString(string: "Введите промокод", attributes: placeholderAttributes)

        textfield.attributedPlaceholder = attributedPlaceholder
        textfield.autocorrectionType = .no
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 56))
        textfield.leftView = leftPaddingView
        textfield.leftViewMode = .always
//        textfield.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
    
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
//        button.addTarget(self, action: #selector(alert), for: .touchDown)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    func setupUI(){
        view.addSubviews(promocodeTextField, applyButton, promocodeIcon, lineImageView)
    }
    
    func setupConstraints(){
        promocodeTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
    }
}

extension EnterPromocodeViewController {
    @objc
    func keyboardWillAppear() {

    }
    
    @objc
    func keyboardWillHide() {
       
    }
}
