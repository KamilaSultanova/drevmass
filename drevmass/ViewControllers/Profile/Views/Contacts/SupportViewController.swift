//
//  SupportViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 17.03.2024.
//

import UIKit
import Alamofire
import SnapKit

class SupportViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - UI Elements
    
    var onMessageSent: (() -> Void)?
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.action = #selector(backButtonTapped)
        button.target = self
        button.image = .back
        return button
    }()
    
    private lazy var textView: UITextView = {
        let textview = UITextView()
       
        textview.textColor = .appDark90
        textview.backgroundColor = .white
        textview.font = .appFont(ofSize: 17, weight: .regular)
        textview.delegate = self
        textview.textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
        return textview
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 17, weight: .regular)
        label.textColor = .appGray60
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Опишите проблему"
        label.tag = 100
       
        return label
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отправить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBeige20
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.isEnabled = false
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.addTarget(self, action: #selector(sendMessage), for: .touchDown)
        
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .appBeige100
        view.backgroundColor = .white
        title = "Cлужба поддержки"
        setupUI()
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupUI(){
        view.addSubviews(textView, sendButton)
        textView.addSubview(placeholderLabel)
    }
    
    private func setupConstraints(){
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

extension SupportViewController{
    @objc
    func keyboardWillAppear() {
        sendButton.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-16)
                make.height.equalTo(48)
        }
    }
    
    @objc
    func keyboardWillHide() {
        sendButton.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
                make.height.equalTo(48)
        }
    }
    
    @objc
    func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        keyboardWillAppear()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.viewWithTag(100)?.isHidden = !textView.text.isEmpty
        if !textView.text.isEmpty{
            sendButton.isEnabled = true
            sendButton.backgroundColor = .appBeige100
        }else{
            sendButton.isEnabled = false
            sendButton.backgroundColor = .appBeige20
        }
    }
    
    @objc
    func sendMessage(){
        
        let textViewMessage = textView.text!
    
        let headers: HTTPHeaders = [
            .authorization(bearerToken: "\(AuthService.shared.token)")
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            if let textData = textViewMessage.data(using: .utf8) {
                    multipartFormData.append(textData, withName: "message")
                }
            },
            to: Endpoints.support.value,
            method: .post,
            headers: headers
        ).validate(statusCode: 200..<300).responseData { [self] response in
                switch response.result {
                case .success:
                    onMessageSent?()
                    dismiss(animated: true)
                    showToast(type: .success, title: "Ваше сообщение успешно отправлено")
                case .failure(let error):
                    print(error.localizedDescription)
                    showToast(type: .error, title: error.localizedDescription)
                }
            }
    }

}
