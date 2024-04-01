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

class InfoBonusViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
     
        return view
    }()
    
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(descriptionLabel)
        
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(scrollView.contentLayoutGuide)
            make.top.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
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
