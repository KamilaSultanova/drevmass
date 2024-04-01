//
//  SuccesOrderViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 01.04.2024.
//

import UIKit
import PanModal
import SnapKit

class SuccesOrderViewController: UIViewController, PanModalPresentable {
    
    // MARK: - UI Elements
    
    var longFormHeight: PanModalHeight = .intrinsicHeight
    var cornerRadius: CGFloat = 24
    var panModalBackgroundColor: UIColor = .appModalBackground
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    private lazy var cartImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = .CartButton.ordered
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    private lazy var cartLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш заказ принят"
        label.font = .appFont(ofSize: 22, weight: .bold)
        label.textColor = .appDark90
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var instrustionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Сейчас на ваш номер должна прийти смс с номера Drevmass. Наши менеджеры свяжутся с Вами в ближайшее время."
        label.font = .appFont(ofSize: 16, weight: .regular)
        label.textColor = .appGray70
        label.numberOfLines = 0

        let attributedText = NSMutableAttributedString(string: label.text!)
        let kernValue: CGFloat = 0.75
        attributedText.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attributedText.length))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Понятно", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBeige100
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.isEnabled = true
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
        
    }
}

private extension SuccesOrderViewController{
    private func setupUI(){
        view.addSubviews(cartLabel, cartImageView, instrustionsLabel, closeButton)
    }
    private func setupConstraints() {
        
        cartImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(32)
            make.size.equalTo(112)
        }
        
        cartLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.top.equalTo(cartImageView.snp.bottom).offset(24)
        }
        
        instrustionsLabel.snp.makeConstraints { make in
            make.top.equalTo(cartLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(cartLabel)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(instrustionsLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(cartLabel)
            make.height.equalTo(56)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
}
extension SuccesOrderViewController{
    @objc
    func closeButtonTapped(){
        let tabBarVC = TabBarController()
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.selectedIndex = 2
        self.present(tabBarVC, animated: true )
    }
}
