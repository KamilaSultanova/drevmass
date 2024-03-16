//
// ProfileViewController
// Created by Nurasyl on 22.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import KeychainSwift
import SwiftyJSON


class ProfileViewController: UIViewController, UIScrollViewDelegate {
    
    var bonus: Bonus?
    
    // MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isScrollEnabled = true
        
        return scrollView
    }()
    
    private lazy var infoView: UIView = {
        let view  = UIView()
        view.backgroundColor = .appBeige100
        
        return view
    }()
    
    private lazy var settingsView: UIView = {
        let view  = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .semiBold)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var gradientView: GradientView = {
        let view  = GradientView()
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.horizontalMode = false
        view.startColor = UIColor(red: 0.80, green: 0.73, blue: 0.58, alpha: 1.00)
        view.endColor = UIColor(red: 0.75, green: 0.68, blue: 0.53, alpha: 1.00)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBonus))
        
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        return view
    }()
  
    private lazy var logoImageView: UIImageView = {
        let image = UIImageView()
        image.image = .group
        image.alpha = 0.3
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        
        return image
    }()
    
    private lazy var bonusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Мои баллы", for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(.white, for: .normal)
        button.setImage(.arrow, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentVerticalAlignment = .center
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(tapBonus), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var bonusImageView: UIImageView = {
        let image = UIImageView()
        image.image = .bonusIcon
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        
        return image
    }()
    
    private lazy var bonusLabel: UILabel = {
        let label = UILabel()
        label.text = "500"
        label.font = .appFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private lazy var promocodeButton: CustomButton = {
        let button = CustomButton()
        button.addTwoImagesButton(leftImage: .promocode, rightImage: .CourseButton.arrow, title: "Промокоды")
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.appBeige30.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(tapPromocodeButton), for: .touchUpInside)

        return button
    }()
    
    private lazy var dataButton: CustomButton = {
        let button = CustomButton()
        button.addTwoImagesButton(leftImage: .data, rightImage: .CourseButton.arrow, title: "Мои данные")
        button.addTarget(self, action: #selector(tapDataButton), for: .touchUpInside)

        return button
    }()
    
    private lazy var changePasswordButton: CustomButton = {
        let button = CustomButton()
        button.addTwoImagesButton(leftImage: .lock, rightImage: .CourseButton.arrow, title: "Сменить пароль")
        button.addTarget(self, action: #selector(tapPasswordButton), for: .touchUpInside)

        return button
    }()
    
    private lazy var notificationButton: CustomButton = {
        let button = CustomButton()
        button.addTwoImagesButton(leftImage: .notifications, rightImage: .CourseButton.arrow, title: "Уведомления")
        button.addTarget(self, action: #selector(tapNotificationButton), for: .touchUpInside)

        return button
    }()
    
    private lazy var userStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dataButton, changePasswordButton, notificationButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.layer.cornerRadius = 20
        stackView.layer.borderColor = UIColor.appBeige30.cgColor
        stackView.layer.borderWidth = 2
        return stackView
    }()
    
    private lazy var contactUsButton: CustomButton = {
        let button = CustomButton()
        button.addTwoImagesButton(leftImage: .contactUs, rightImage: .CourseButton.arrow, title: "Связаться с нами")
        button.addTarget(self, action: #selector(tapContactButton), for: .touchUpInside)

        return button
    }()
    
    private lazy var feedbackButton: CustomButton = {
        let button = CustomButton()
        button.addTwoImagesButton(leftImage: .star, rightImage: .CourseButton.arrow, title: "Оставить отзыв")
//        button.addTarget(self, action: #selector(tapBonus), for: .touchUpInside)

        return button
    }()
    
    private lazy var infoButton: CustomButton = {
        let button = CustomButton()
        button.addTwoImagesButton(leftImage: .info.withTintColor(.appBeige100), rightImage: .CourseButton.arrow, title: "Информация")
        button.addTarget(self, action: #selector(tapInfoButton), for: .touchUpInside)

        return button
    }()
    
    private lazy var clientStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [contactUsButton, feedbackButton, infoButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.layer.cornerRadius = 20
        stackView.layer.borderColor = UIColor.appBeige30.cgColor
        stackView.layer.borderWidth = 2
        return stackView
    }()
    
    private lazy var logoutButton: CustomButton = {
        let button = CustomButton()
        button.addTwoImagesButton(leftImage: .logout, rightImage: nil, title: "Выйти")
        button.setTitleColor(.appGray80, for: .normal)
        button.addTarget(self, action: #selector(tapLogout), for: .touchUpInside)

        return button
    }()
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        setupUI()
        setupConstraints()
        fetchUserInfo()
        fetchBonus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

private extension ProfileViewController {
    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(infoView)
        infoView.addSubviews(settingsView, nameLabel, numberLabel, gradientView)
        gradientView.addSubviews(logoImageView, bonusLabel, bonusButton, bonusImageView)
        settingsView.addSubviews(promocodeButton, userStackView, clientStackView, logoutButton)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }

        infoView.snp.makeConstraints { make in
            make.horizontalEdges.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        
        settingsView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(infoView.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(gradientView.snp.bottom).offset(24)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(infoView.safeAreaLayoutGuide).inset(46)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }
        
        gradientView.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(bonusButton.snp.right).offset(5)
            make.size.equalTo(245)
        }
        
        bonusButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(24)
            make.height.equalTo(20)
            make.width.equalTo(97)
        }
        
        bonusImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(bonusButton.snp.bottom).offset(13)
            make.size.equalTo(32)
        }
        
        bonusLabel.snp.makeConstraints { make in
            make.left.equalTo(bonusImageView.snp.right).offset(9)
            make.right.equalToSuperview().inset(24)
            make.centerY.equalTo(bonusImageView)
        }
        
        promocodeButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
        
        userStackView.snp.makeConstraints { make in
            make.top.equalTo(promocodeButton.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(160)
        }
        
        clientStackView.snp.makeConstraints { make in
            make.top.equalTo(userStackView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(160)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(clientStackView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(32)
        }
    }
}

private extension ProfileViewController {
    @objc 
    func tapBonus(){
        let myBonusVC = MyBonusViewController()
        navigationController?.pushViewController(myBonusVC, animated: true)
    }
    
    @objc
    func tapPromocodeButton(){
        let promocodeVC = PromocodeViewController()
        navigationController?.pushViewController(promocodeVC, animated: true)
    }
    
    @objc
    func tapDataButton(){
        let dataVC = DataViewController()
        dataVC.delegate = self 
        navigationController?.pushViewController(dataVC, animated: true)
    }
    @objc
    func tapPasswordButton(){
        let changePasswordVC = ChangePasswordViewController()
        navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
    @objc
    func tapNotificationButton(){
        let notificationsVC = NotificationsViewController()
        navigationController?.pushViewController(notificationsVC, animated: true)
    }
    
    @objc
    func tapContactButton(){
        let contactVC = ContactViewController()
        navigationController?.pushViewController(contactVC, animated: true)
    }
    
    @objc
    func tapInfoButton(){
        let infoVC = InformationViewController()
        navigationController?.pushViewController(infoVC, animated: true)
    }
    @objc
    func tapLogout(){
        let alertController = UIAlertController(title: nil, message: "Вы действительно хотите выйти?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Остаться", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        let logoutAction = UIAlertAction(title: "Выйти", style: .destructive) { _ in

            KeychainSwift().clear()
            let onboardingVC = OnboardingViewController()
            let rootVC = UINavigationController(rootViewController: onboardingVC)
            UIApplication.shared.windows.first?.rootViewController = rootVC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
           
        }
        alertController.addAction(logoutAction)
        present(alertController, animated: true, completion: nil)
    }
}

private extension ProfileViewController {
    @objc
    func fetchUserInfo() {
        
            AF.request(Endpoints.user.value, method: .get, headers: [
                .authorization(bearerToken: AuthService.shared.token)
            ]).responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    self.nameLabel.text = json["name"].stringValue
                    self.numberLabel.text = self.formatter(mask: "+X XXX XXX XX XX", phoneNumber: json["phone_number"].stringValue)
                case .failure(let error):
                    print(error)
                    self.showToast(type: .error, title: error.localizedDescription)
                }
            }
    }
    
    @objc
    func fetchBonus() {
        
        AF.request(Endpoints.bonus.value, method: .get, headers: [
            .authorization(bearerToken: AuthService.shared.token)
        ]).responseDecodable(of: Bonus.self) { response in
            switch response.result {
            case .success(let bonus):
                self.bonusLabel.text = "\(bonus.bonus)"
            case .failure(let error):
                print(error)
                self.showToast(type: .error, title: error.localizedDescription)
            }
        }
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
extension ProfileViewController: DataViewControllerDelegate {
    func didUpdateProfileData() {
        fetchUserInfo()
    }
}


