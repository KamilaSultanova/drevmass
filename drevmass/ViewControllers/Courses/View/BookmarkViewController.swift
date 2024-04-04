//
// BookmarkViewController
// Created by Kamila Sultanova on 08.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class BookmarkViewController: UIViewController {

    // MARK: - Arrays
    
    var coursesArray: [Favorite] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var courseID:Int?

    // MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentInsetAdjustmentBehavior = .never
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var emptyPageView: UIView = {
        
        let view = UIView()
        let imageview = UIImageView()
        let title = UILabel()
        let subtitile = UILabel()
        
        imageview.image = .Course.empty
            
        title.text = "В закладках пока ничего нет"
        title.textAlignment = .center
        title.font = .appFont(ofSize: 17, weight: .semiBold)
        title.textColor = .appDark100
        
        subtitile.text = "Смотрите курсы и сохраняйте полезные уроки здесь"
        subtitile.textAlignment = .center
        subtitile.font = .appFont(ofSize: 16, weight: .regular)
        subtitile.textColor = .appGray70
        subtitile.numberOfLines = 2
        
        view.addSubviews(imageview, title, subtitile)
        
        imageview.snp.makeConstraints { make in
            make.size.equalTo(112)
            make.bottom.equalTo(title.snp.top).offset(-24)
            make.centerX.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        subtitile.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        return view
    }()
    
    private lazy var tableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: "BookmarkCell")

        return tableView
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        fetchFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Мои закладки"
        
    }
}

extension BookmarkViewController {
    func setupViews() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = UIColor(red: 0.71, green: 0.64, blue: 0.5, alpha: 1)
        view.backgroundColor = .white

        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubviews(tableView, emptyPageView)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        
        emptyPageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()}
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    func configureViews() {
        if coursesArray.isEmpty {
            emptyPageView.isHidden = false
            tableView.isHidden = true
        } else {
            emptyPageView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    func fetchFavorites() {
        
        AF.request(Endpoints.favorites.value, method: .get, headers: [.authorization(bearerToken: AuthService.shared.token)]).responseDecodable(of: [Favorite].self) { response in
            switch response.result {
            case .success(let favoritesArray):
                self.coursesArray = favoritesArray
                for item in favoritesArray{
                    self.courseID = item.course_id
                }
                self.configureViews()
            case .failure(let error):
                print(error.localizedDescription)
                self.showToast(type: .error, title: error.localizedDescription)
            }
        }
    }
    
    func updateData(){
        
        fetchFavorites()
    }
}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource, LessonCellProtocol {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return coursesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as? BookmarkTableViewCell
        else {
            fatalError("Unable to find a cell with identifier \"CourseCell\"")
        }
        
        cell.setData(course: coursesArray[indexPath.row])
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    
    func didSelectLesson(_ lesson: LessonProtocol) {
        let lessonVC = LessonViewController(lesson: lesson)
        lessonVC.courseId = courseID
        navigationController?.show(lessonVC, sender: self)
    }
}
