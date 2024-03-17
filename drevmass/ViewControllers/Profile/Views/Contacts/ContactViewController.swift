//
//  ContactViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 14.03.2024.
//

import UIKit
import PanModal
import SnapKit
import Alamofire
import SwiftyJSON

class ContactViewController: UIViewController, PanModalPresentable {
    
    // MARK: - UI Elements
    
    var onMessageSent: (() -> Void)?
    
    var longFormHeight: PanModalHeight = .intrinsicHeight
    var cornerRadius: CGFloat = 24
    var panModalBackgroundColor: UIColor = .appModalBackground
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    private lazy var contactLabel: UILabel = {
        let label = UILabel()
                            
        label.font = .appFont(ofSize: 20, weight: .semiBold)
        label.textColor = .appDark90
        label.textAlignment = .left
        label.text = "Связаться с нами"
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var callButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Позвонить", for: .normal)
        button.setTitleColor(.appDark90, for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.contentHorizontalAlignment = .left
        button.setImage(.phone, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.appBeige40.cgColor
        button.layer.borderWidth = 2
        button.contentVerticalAlignment = .center
        let contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let titleInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        button.contentEdgeInsets = contentInset
        button.titleEdgeInsets = titleInset
        button.addTarget(self, action: #selector(tapCallButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Служба поддержки", for: .normal)
        button.setTitleColor(.appDark90, for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.contentHorizontalAlignment = .left
        button.setImage(.message, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.appBeige40.cgColor
        button.layer.borderWidth = 2
        button.contentVerticalAlignment = .center
        let contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let titleInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        button.contentEdgeInsets = contentInset
        button.titleEdgeInsets = titleInset
        button.addTarget(self, action: #selector(tapMessageButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var whatsappButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("WhatsApp", for: .normal)
        button.setTitleColor(.appDark90, for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.contentHorizontalAlignment = .left
        button.setImage(.whatsapp, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.appBeige40.cgColor
        button.layer.borderWidth = 2
        button.contentVerticalAlignment = .center
    
        let contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let titleInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        button.contentEdgeInsets = contentInset
        button.titleEdgeInsets = titleInset
        button.addTarget(self, action: #selector(tapWhatsappButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var StackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [callButton, messageButton, whatsappButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 8
   
        return stackView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupUI()
        setupConstraints()
    }
    
    private func setupUI(){
        view.addSubviews(contactLabel, StackView)
    }
    
    private func setupConstraints(){
        contactLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        StackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(contactLabel.snp.bottom).offset(5)
            make.height.equalTo(208)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
        }
        
    }
    
    @objc
    func tapCallButton(){
            AF.request(Endpoints.contacts.value, method: .get, headers: [
                .authorization(bearerToken: AuthService.shared.token)
            ]).responseData { [self] response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    if let phoneNumber = json["number"].string {
                        if let url = URL(string: "tel://\(phoneNumber)") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                    self.showToast(type: .error, title: error.localizedDescription)
                }
        }
        
    }
    
    @objc func tapWhatsappButton() {
        
        AF.request(Endpoints.contacts.value, method: .get, headers: [
            .authorization(bearerToken: AuthService.shared.token)
        ]).responseData { [self] response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                if let whatsappNumber = json["whatsapp"].string {
                    if let url = URL(string: "whatsapp://send?phone=\(whatsappNumber)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                
            case .failure(let error):
                print(error)
                self.showToast(type: .error, title: error.localizedDescription)
            }
      
        }
    }
    
    @objc
    func tapMessageButton(){
        let supportVC = SupportViewController()
        supportVC.onMessageSent = {
                self.onMessageSent?()
            }
        
        present(UINavigationController(rootViewController: supportVC), animated: true)
    }
    
}




