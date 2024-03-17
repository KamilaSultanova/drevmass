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
    
    private lazy var promocodeTextField: UITextField = {
        let textfield = UITextField()
        
        textfield.borderStyle = .none
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appGray60,
            .font: UIFont.appFont(ofSize: 17, weight: .semiBold)
        ]

        let attributedPlaceholder = NSAttributedString(string: "Введите промокод", attributes: placeholderAttributes)

        textfield.attributedPlaceholder = attributedPlaceholder
        textfield.autocorrectionType = .no
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: textfield.frame.height))
        textfield.leftView = leftPaddingView
        textfield.leftViewMode = .always
//        textfield.addTarget(self, action: #selector(textEditDidChanged), for: .editingChanged)
    
        return textfield
    }()
    
    private lazy var lineImageView: UIImageView = {
        let image = UIImageView()
        image.image = .divider.withTintColor(.appBeige100)
        image.contentMode = .scaleAspectFit
        
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
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 48)
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
        
    }
    func setupUI(){
        view.addSubviews(promocodeTextField, applyButton, promocodeIcon, lineImageView)
    }
    
    func setupConstraints(){
        promocodeTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(48)
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
            make.top.equalTo(promocodeTextField.snp.bottom).offset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}
