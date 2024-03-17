//
//  AppInformationViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 17.03.2024.
//

import UIKit
import SnapKit

class AppInformationViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var closeButton: UIBarButtonItem = {
       let button = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(closeTapped))
      
       return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.layer.cornerRadius = 24
        imageview.clipsToBounds = true
        imageview.image = .app
        
        return imageview
    }()
    
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 22, weight: .bold)
        label.textColor = .appDark90
        label.text = "Древмасс"
       
        return label
    }()
    
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .regular)
        label.textColor = .appGray80
        label.text = "Версия 1.1.1(41)"
       
        return label
    }()
    private lazy var rightsLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .regular)
        label.textColor = .appGray80
        label.text = "© 2024 Name, Inc \nВсе права защищены"
        label.numberOfLines = 0
        label.textAlignment = .center
       
        return label
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = " "
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = closeButton
        title = "О приложении"
        setupUI()
        setupConstraints()
    }
    
    private func setupUI(){
        view.addSubviews(imageView, companyLabel, versionLabel, rightsLabel)
    }
    
    private func setupConstraints(){
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.centerX.equalToSuperview()
            make.size.equalTo(112)
        }
        companyLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(companyLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        rightsLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(36)
            make.centerX.equalToSuperview()
        }
    }
        
    @objc
    func closeTapped(){
        self.dismiss(animated: true)
    }
}
