//
//  InformationViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 14.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class InformationViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var aboutCompanyButton: UIButton = {
        let button = UIButton()
        button.setTitle("О компании", for: .normal)
        button.setTitleColor(.appDark90, for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(aboutCompanyTapped), for: .touchUpInside)
        
        let imageview = UIImageView()
        imageview.image = .arrow.withTintColor(.appGray70)
        imageview.contentMode = .scaleAspectFit
        
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 0.93, green: 0.92, blue: 0.92, alpha: 1.00)
        
        button.addSubviews(imageview, divider)
        
        imageview.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.size.equalTo(16)
            make.centerY.equalToSuperview()
        }
        divider.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
        }
        
        return button
    }()
    
    private lazy var aboutAppButton: UIButton = {
        let button = UIButton()
        button.setTitle("О приложении", for: .normal)
        button.setTitleColor(.appDark90, for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(aboutAppTapped), for: .touchUpInside)
        
        let imageview = UIImageView()
        imageview.image = .arrow.withTintColor(.appGray70)
        imageview.contentMode = .scaleAspectFit
        
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 0.93, green: 0.92, blue: 0.92, alpha: 1.00)
        
        button.addSubviews(imageview, divider)
        
        imageview.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.size.equalTo(16)
            make.centerY.equalToSuperview()
        }
        divider.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
        }
        
        return button
    }()
    
    private lazy var youTubeButton: UIButton = {
        let button = UIButton()
        button.setImage(.youTubeIcon, for: .normal)
        button.addTarget(self, action: #selector(socialMediaButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var vkButton: UIButton = {
        let button = UIButton()
        button.setImage(.vkIcon, for: .normal)
        button.addTarget(self, action: #selector(socialMediaButton), for: .touchUpInside)
        
        return button
    }()
    
    private var vkURL: URL?
    
    private var youtubeURL: URL?
    
    private lazy var socialMediaLabel: UILabel = {
        let label = UILabel()
        label.text = "Мы в соцсетях:"
        label.font = .appFont(ofSize: 15, weight: .regular)
        label.textColor = .appGray80
        
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .appBeige100
        navigationItem.largeTitleDisplayMode = .never
        title = "Информация"
        setupUI()
        setupConstraints()
        fetchSocial()
    }
    
    private func setupUI(){
        view.addSubviews(aboutAppButton, aboutCompanyButton, youTubeButton, vkButton, socialMediaLabel)
    }
    
    private func setupConstraints(){
        aboutCompanyButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
        aboutAppButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(aboutCompanyButton.snp.bottom)
            make.height.equalTo(52)
        }
        youTubeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(36)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.centerX).inset(40)
            make.size.equalTo(64)
        }
        vkButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(36)
            make.left.equalTo(youTubeButton.snp.right).offset(16)
            make.size.equalTo(64)
        }
        socialMediaLabel.snp.makeConstraints { make in
            make.bottom.equalTo(youTubeButton.snp.top).offset(-16)
            make.centerX.equalToSuperview()
        }
    }
}

private extension InformationViewController{
    
    private func fetchSocial() {
        AF.request(Endpoints.social.value, method: .get, headers: [
            .authorization(bearerToken: AuthService.shared.token)
        ]).responseData { [self] response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                if let vkUrlString = json["vk"].string {
                        self.vkURL = URL(string: vkUrlString)
                    }
                if let youtubeUrlString = json["youtube"].string {
                        self.youtubeURL = URL(string: youtubeUrlString)
                    }
                
            case .failure(let error):
                print(error)
                self.showToast(type: .error, title: error.localizedDescription)
            }
        }
    }
    
    @objc func socialMediaButton(_ sender: UIButton) {
        var url: URL?
        switch sender{
        case vkButton:
            url = vkURL
        case youTubeButton:
            url = youtubeURL
        default:
                break
        }
        if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("URL is not available")
            }
        }

    
    @objc
    func aboutCompanyTapped(){
        let companyInfoVC = CompanyInformationViewController()
        present(UINavigationController(rootViewController: companyInfoVC), animated: true)
    }
    
    @objc
    func aboutAppTapped(){
        let appInfoVC = AppInformationViewController()
        present(UINavigationController(rootViewController: appInfoVC), animated: true)
    }
}

