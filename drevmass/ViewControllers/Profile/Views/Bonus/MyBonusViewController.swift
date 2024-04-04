//
//  MyBonusViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 11.03.2024.
//

import UIKit
import SnapKit
import Alamofire

class MyBonusViewController: UIViewController, UIScrollViewDelegate {
    
    var bonusArray: [Bonus.Transactions] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    // MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isScrollEnabled = true
        
        return scrollView
    }()
    
    private lazy var bonusView: UIView = {
        let view  = UIView()
        view.backgroundColor = .appBeige100
        
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let image = UIImageView()
        image.image = .group2
        image.alpha = 0.3
        image.contentMode = .scaleAspectFit
   
        return image
    }()
    
    private lazy var historyView: UIView = {
        let view  = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    private lazy var bonusImageView: UIImageView = {
        let image = UIImageView()
        image.image = .bonusIcon
        image.contentMode = .scaleAspectFit
    
        return image
    }()
    
    private lazy var bonusLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .appFont(ofSize: 34, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var infoButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .info, style: .plain, target: self, action: #selector(infoTapped))
        
        return button
    }()
    
    private lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.text = "1 балл = 1 ₽"
        label.font = .appFont(ofSize: 15, weight: .semiBold)
        label.textColor = .white
     
        return label
    }()
    
    private lazy var historyLabel: UILabel = {
        let label = UILabel()
        label.text = "История баллов"
        label.font = .appFont(ofSize: 20, weight: .semiBold)
        label.textColor = .appDark100
     
        return label
    }()
    
    private lazy var burningBonusView: UIView = {
        let view = UIView()
        view.backgroundColor = .appDark90.withAlphaComponent(0.2)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var burningImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = .burning
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    private lazy var burningBonusLabel: UILabel = {
        let label = UILabel()
        label.text = "300"
        label.font = .appFont(ofSize: 13, weight: .medium)
        label.textColor = .white
     
        return label
    }()
    
    private lazy var burningDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .appFont(ofSize: 13, weight: .regular)
        
        return label
    }()
    
    private lazy var emptyBonusImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = .emptyBonus
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    private lazy var emptyHistoryLabel: UILabel = {
        let label = UILabel()
        label.text = "В истории баллов пока пусто"
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .appDark90
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var instrustionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Совершайте покупки, проходите видеоуроки и получайте за это баллы."
        label.font = .appFont(ofSize: 16, weight: .regular)
        label.textColor = .appGray70
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var tableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(BonusTableViewCell.self, forCellReuseIdentifier: "BonusCell")
        tableView.isUserInteractionEnabled = false

        return tableView
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigation()
        setupUI()
        setupConstraints()
        configureViews()
        fetchBonus()
        
    }
}
private extension MyBonusViewController {
    func setupNavigation(){
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .white
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = infoButton
        title = "Мои баллы"
        navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                .font: UIFont.appFont(ofSize: 17, weight: .semiBold)
            ]
    }
    
    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(bonusView)
        bonusView.addSubviews( logoImageView, bonusLabel, bonusImageView, moneyLabel, historyView, historyLabel, burningBonusView)
        burningBonusView.addSubviews(burningImageView,burningBonusLabel, burningDateLabel)
        historyView.addSubviews(emptyBonusImageView, emptyHistoryLabel, instrustionsLabel, tableView)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        bonusView.snp.makeConstraints { make in
            make.horizontalEdges.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        
        bonusImageView.snp.makeConstraints { make in
            make.top.equalTo(bonusView.safeAreaLayoutGuide).inset(36)
            make.left.equalToSuperview().inset(16)
            make.size.equalTo(32)
        }
        
        bonusLabel.snp.makeConstraints { make in
            make.left.equalTo(bonusImageView.snp.right).offset(8)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(bonusImageView)
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.top.equalTo(bonusLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        historyView.snp.makeConstraints { make in
            make.top.equalTo(bonusView.safeAreaLayoutGuide).inset(128)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        historyLabel.snp.makeConstraints { make in
            make.top.equalTo(historyView.snp.top).inset(20)
            make.horizontalEdges.equalTo(historyView).inset(16)
        }
        
        burningBonusView.snp.makeConstraints { make in
            make.top.equalTo(moneyLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        burningImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(18)
            make.width.equalTo(15)
        }
        
        burningBonusLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(burningImageView.snp.right).offset(8)
        }
        
        burningDateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(burningBonusLabel.snp.right)
            make.right.equalToSuperview().inset(8)
        }
        
        emptyBonusImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(historyView.snp.centerY)
            make.height.equalTo(112)
        }
        
        emptyHistoryLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyBonusImageView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        instrustionsLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyHistoryLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(emptyHistoryLabel)
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(historyLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview()
        }
        
    }
}

private extension MyBonusViewController {
    
    func configureViews(){
        if bonusArray.isEmpty {
            burningBonusView.isHidden = true
            emptyBonusImageView.isHidden = false
            emptyHistoryLabel.isHidden = false
            instrustionsLabel.isHidden = false
            tableView.isHidden = true
        }
        burningBonusView.isHidden = true
        emptyBonusImageView.isHidden = true
        emptyHistoryLabel.isHidden = true
        instrustionsLabel.isHidden = true
        tableView.isHidden = false
    }
    
    @objc
    func infoTapped() {
        let bonusInfoVC = InfoBonusViewController()
        present(UINavigationController(rootViewController: bonusInfoVC), animated: true)
    }
}

extension MyBonusViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bonusArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BonusCell", for: indexPath) as? BonusTableViewCell
        else {
            fatalError("Unable to find a cell with identifier \"BonusCell\"")
        }
        
        cell.setData(bonus: bonusArray[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

private extension MyBonusViewController {
    @objc
    func fetchBonus() {
        
        AF.request(Endpoints.bonus.value, method: .get, headers: [
            .authorization(bearerToken: AuthService.shared.token)
        ]).responseDecodable(of: Bonus.self) { [self] response in
            switch response.result {
            case .success(let bonus):
                self.bonusLabel.text = "\(bonus.bonus)"
                self.bonusArray = bonus.transactions
                if let burningBonusArray = bonus.burning{
                    if burningBonusArray.isEmpty{
                        self.burningBonusView.isHidden = true
                    }else{
                        self.burningBonusView.isHidden = false
                        if let burningAmount = burningBonusArray.first?.burningBonus, let burningDate = burningBonusArray.first?.endDate{
                            burningBonusLabel.text = "\(burningAmount)"
                            burningDateLabel.text = " сгорят \(burningDate)"
                                        }
                        self.historyView.snp.remakeConstraints { make in
                            make.top.equalTo(burningBonusView.snp.bottom).offset(32)
                            make.horizontalEdges.bottom.equalToSuperview()
                        }
                    }
                }
            case .failure(let error):
                print(error)
                self.showToast(type: .error, title: error.localizedDescription)
            }
        }
    }
}
