//
//  CompanyInformationViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 17.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class CompanyInformationViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - UI Elements
    
    private lazy var closeButton: UIBarButtonItem = {
       let button = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(closeTapped))
      
       return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isScrollEnabled = true
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view  = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.layer.cornerRadius = 24
        imageview.clipsToBounds = true
        imageview.image = .company
        
        return imageview
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 16, weight: .regular)
        label.textColor = .appDark90
        label.numberOfLines = 0
        label.textAlignment = .natural
       
        return label
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = " "
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = closeButton
        title = "О Компании"
        setupUI()
        setupConstraints()
        fetchCompanyInfo()
    }
    
    private func setupUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(imageView, descriptionLabel)
    }
    
    private func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(189)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc
    func closeTapped(){
        self.dismiss(animated: true)
    }
    
    private func fetchCompanyInfo(){
        AF.request(Endpoints.company.value, method: .get, headers: [
            .authorization(bearerToken: AuthService.shared.token)
        ]).responseData { [self] response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                descriptionLabel.text = json["text"].stringValue
            case .failure(let error):
                print(error)
                showToast(type: .error, title: error.localizedDescription)
            }
        }
    }
}
