//
//  PromocodeViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 14.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class PromocodeViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var infoButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .info.withTintColor(.appBeige100), style: .plain, target: self, action: #selector(infoTapped))
        
        return button
    }()
    
    private lazy var promocodeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.46, green: 0.34, blue: 0.34, alpha: 1.00)
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 20, weight: .semiBold)
        label.textColor = .white
        label.textAlignment = .left
        label.text = "Промокод для друга"
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.6)
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var promocodeLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "JD58KA6H"
        
        return label
    }()
    
    private lazy var lineImageView: UIImageView = {
        let image = UIImageView()
        image.image = .frame.withTintColor(.white)
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Поделиться", for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
        button.setImage(.CourseButton.share, for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        button.contentVerticalAlignment = .center
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        return button
    }()
    
    private lazy var copyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Скопировать", for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
        button.setImage(.copy, for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        button.contentVerticalAlignment = .center
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        return button
    }()
    
    private lazy var shareView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var sharedLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.94)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Вы поделились"
        
        return label
    }()
    
    private lazy var usedAttempedLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    private lazy var allAttemptLabel: UILabel = {
        let label = UILabel()
    
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .white.withAlphaComponent(0.6)
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var bonusInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .appBackground
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var bonusInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 13, weight: .regular)
        label.textColor = .appGray80
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "*начислим вам 500 бонусов при условии покупки массажера вашим другом"
        
        return label
    }()
    
    private lazy var promocodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("У меня есть промокод", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appBeige100
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(promocodeButtonTapped), for: .touchDown)
        return button
    }()
    
    private lazy var promocodeImageView: UIImageView = {
        let image = UIImageView()
        image.image = .promoPicture
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private lazy var noPromocodeLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .appDark90
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Действующих промокодов нет"
        
        return label
    }()
    
    private lazy var instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 16, weight: .regular)
        label.textColor = .appGray70
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Если у вас есть промокод, можете использовать его при оформлении заказа."
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigation()
        setupUI()
        setupConstraints()
        configureViews()
        fetchPromocode()
    }
}

private extension PromocodeViewController {
    private func setupUI(){
        view.addSubviews(promocodeView, bonusInfoView, bonusInfoLabel, promocodeButton, promocodeImageView, noPromocodeLabel, instructionsLabel)
        promocodeView.addSubviews(mainLabel, descriptionLabel, promocodeLabel, lineImageView, shareButton, copyButton, shareView)
        shareView.addSubviews(sharedLabel, usedAttempedLabel, allAttemptLabel)
    }
    
    private func setupConstraints(){
        promocodeView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(270)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        promocodeLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        lineImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(promocodeLabel.snp.bottom).offset(8)
            make.height.equalTo(2)
        }
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(lineImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(32)
            make.width.equalTo(129)
        }
        
        copyButton.snp.makeConstraints { make in
            make.top.equalTo(lineImageView.snp.bottom).offset(16)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(32)
            make.width.equalTo(129)
        }
        
        shareView.snp.makeConstraints { make in
            make.top.equalTo(copyButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(46)
        }
        
        sharedLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        usedAttempedLabel.snp.makeConstraints { make in
            make.left.equalTo(sharedLabel.snp.right).offset(16)
            make.right.equalTo(allAttemptLabel.snp.left)
            make.centerY.equalTo(sharedLabel)
        }
        allAttemptLabel.snp.makeConstraints { make in
            make.left.equalTo(usedAttempedLabel.snp.right)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(sharedLabel)
        }
        
        bonusInfoView.snp.makeConstraints { make in
            make.top.equalTo(promocodeView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        bonusInfoLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(bonusInfoView.snp.horizontalEdges).inset(16)
            make.centerY.equalTo(bonusInfoView)
        }
        
        promocodeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        
        noPromocodeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        promocodeImageView.snp.makeConstraints { make in
            make.bottom.equalTo(noPromocodeLabel.snp.top).offset(-24)
            make.centerX.equalToSuperview()
            make.size.equalTo(112)
        }
        
        instructionsLabel.snp.makeConstraints { make in
            make.top.equalTo(noPromocodeLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func setupNavigation(){
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .appBeige100
        navigationItem.largeTitleDisplayMode = .never
        title = "Промокоды"
        navigationItem.rightBarButtonItem = infoButton
    }
    
    func configureViews(){
        promocodeImageView.isHidden = true
        noPromocodeLabel.isHidden = true
        instructionsLabel.isHidden = true
    }
}

private extension PromocodeViewController {
    
    @objc
    func infoTapped() {
        let bonusInfoVC = InfoBonusViewController()
        present(UINavigationController(rootViewController: bonusInfoVC), animated: true)
    }
    
    @objc
    func shareButtonTapped(){
        let text = "Скачай приложение Drevmass и получи бонус 2500 рублей по промокоду: \(promocodeLabel.text ?? "") в приложении!"
        let image = UIImageView(image: .logoDrevmass)

        let activityViewController = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true) {
            let imageActivityViewController = UIActivityViewController(
                activityItems: [image as Any],
                applicationActivities: nil
            )
            imageActivityViewController.popoverPresentationController?.sourceView = self.view
            self.present(imageActivityViewController, animated: true)
        }
    }
    
    @objc
    func copyButtonTapped(){
        let pasteboard = UIPasteboard.general
        pasteboard.string = promocodeLabel.text
        showToast(type: .success, title: "Промокод успешно скопирован")
    }
    
    @objc
    func promocodeButtonTapped(){
        let enterPromocodeVC = EnterPromocodeViewController()
        presentPanModal(enterPromocodeVC)
    }
}

private extension PromocodeViewController{
    @objc
    func fetchPromocode() {
        
        AF.request(Endpoints.promocode.value, method: .get, headers: [
            .authorization(bearerToken: AuthService.shared.token)
        ]).responseDecodable(of: Promocode.self) { [self] response in
            switch response.result {
            case .success(let promocode):
                promocodeLabel.text = promocode.promocode
                usedAttempedLabel.text = "\(promocode.used)"
                allAttemptLabel.text = "/\(promocode.allAtempt)"
                descriptionLabel.text = "Промокод \(promocode.bonus) бонусов на покупку массажера для двух друзей!*"
                if promocode.used == promocode.allAtempt{
                    lineImageView.tintColor = .white.withAlphaComponent(0.6)
                    promocodeLabel.tintColor = .white.withAlphaComponent(0.6)
                    shareButton.tintColor = .white.withAlphaComponent(0.6)
                    shareButton.isEnabled = false
                    copyButton.tintColor = .white.withAlphaComponent(0.6)
                    copyButton.isEnabled = false
                }
            case .failure(let error):
                print(error)
                self.showToast(type: .error, title: error.localizedDescription)
            }
        }
    }
}

