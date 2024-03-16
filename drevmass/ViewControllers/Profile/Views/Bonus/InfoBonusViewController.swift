//
//  InfoBonusViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 13.03.2024.
//

import UIKit
import SnapKit
import SwiftyJSON
import Alamofire

class InfoBonusViewController: UIViewController {
    
    // MARK: - UI Elements
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "Text"
        label.font = .appFont(ofSize: 16, weight: .regular)
        label.textColor = .appDark90
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.action = #selector(backButtonTapped)
        button.target = self
        button.image = .back
        return button
    }()
   
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .appBeige100
        navigationItem.leftBarButtonItem = backButton
        title = "Бонусная программа"
        setupUI()
        fetchBonusDescription()
    }
    
    func setupUI(){
        view.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    @objc
    func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchBonusDescription(){
        
        AF.request(Endpoints.bonusInfo.value, method: .get, headers: [
            .authorization(bearerToken: AuthService.shared.token)
        ]).responseData { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                self.descriptionLabel.text = json["text"].stringValue
            case .failure(let error):
                print(error)
                self.showToast(type: .error, title: error.localizedDescription)
            }
        }
    }
}
