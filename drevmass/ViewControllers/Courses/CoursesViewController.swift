//
// CoursesViewController
// Created by Nurasyl on 22.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import Reachability
import SkeletonView

class CoursesViewController: UIViewController {
    
    // MARK: - Properties

    var coursesArray: [Course] = []{
		didSet {
			tableView.reloadData()
		}
	}
    
    var bannersArray: [Banner] = [
        Banner(
            title: "Получайте бонусы за прохождение курсов",
            subtitle: "Начислим до 1500 ₽ \nбонусами."
        )
    ]{
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    // MARK: - UI Elements
    
    private lazy var bookmarkButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .CourseButton.bookmark, style: .plain, target: self, action: #selector(bookmarkTapped))
        
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentInsetAdjustmentBehavior = .never
        
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true

        return view
    }()
    
    private lazy var bookmarkView: UIView = {
        let view = UIView()
       
        view.backgroundColor = .white
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.appBeige30.cgColor
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bookmarkTapped))
        
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var leftBookmarkImageView: UIView = {
        let imageView = UIImageView()
        
        imageView.image = .CourseButton.bookmark
        imageView.contentMode = .scaleAspectFit
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 12
        return imageView
    }()
    
    private lazy var bookmarkLabel: UILabel = {
        let label = UILabel()
        label.text = "Мои закладки"
        label.textAlignment = .left
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .appDark100
        label.isSkeletonable = true
        label.linesCornerRadius = 4
        
        return label
    }()
    
    private lazy var rightBookmarkImageView: UIView = {
        let imageView = UIImageView()
        
        imageView.image = .CourseButton.arrow
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        layout.sectionInset = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: "BannerCell")
        collectionView.isSkeletonable = true

        return collectionView
    }()
    
    private lazy var tableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(CourseTableViewCell.self, forCellReuseIdentifier: "CourseCell")
        tableView.isSkeletonable = true

        return tableView
    }()
    
    private lazy var noInternetView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var wifiImageView: UIImageView = {
        let imageview = UIImageView()
        
        imageview.image = .Toast.wifi
        imageview.contentMode = .scaleAspectFit
        
        return imageview
    }()
    
    private lazy var internetLabel: UILabel = {
        let label = UILabel()
        label.text = "Не удалось загрузить"
        label.textAlignment = .center
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .appDark100
        
        return label
    }()
    
    private lazy var reloadButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
        button.setTitle("Повторить попытку", for: .normal)
        button.backgroundColor = .appBeige100
        button.addTarget(self, action: #selector(reloadTapped), for: .touchUpInside)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        
        return button
    }()
    
    var isLoadingData: Bool = false
    
    let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
    
    let gradient = SkeletonGradient(baseColor: .appBeige40)
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        navigationItem.rightBarButtonItem = bookmarkButton
        hideBookmarkButton()
        checkNetworkStatus()
        fetchCourses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Курсы"
    }
    
    
    func showSkeleton() {
        bookmarkLabel.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation, transition: .crossDissolve(0.25))
        leftBookmarkImageView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation, transition: .crossDissolve(0.25))
        tableView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation, transition: .crossDissolve(0.25))
        collectionView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation, transition: .crossDissolve(0.25))
    }
    
    func hideAllSkeleton() {
        bookmarkLabel.hideSkeleton()
        leftBookmarkImageView.hideSkeleton()
        tableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
    }
}

private extension CoursesViewController {
    func setupViews() {
        navigationController?.navigationBar.barTintColor = .white
        view.backgroundColor = .appBackground
        view.addSubviews(scrollView, noInternetView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(bookmarkView, tableView, collectionView)
        bookmarkView.addSubviews(leftBookmarkImageView, rightBookmarkImageView, bookmarkLabel)
        noInternetView.addSubviews(wifiImageView, internetLabel, reloadButton)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(scrollView.contentLayoutGuide)
            make.top.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        
        noInternetView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        wifiImageView.snp.makeConstraints { make in
            make.size.equalTo(112)
            make.center.equalToSuperview()
        }
        
        internetLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(wifiImageView.snp.bottom).offset(24)
        }
        
        reloadButton.snp.makeConstraints { make in
            make.top.equalTo(internetLabel.snp.bottom).offset(24)
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(84)
        }
        
        bookmarkView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
        
        leftBookmarkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
        
        bookmarkLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(leftBookmarkImageView.snp.right).offset(12)
        }
        
        rightBookmarkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(bookmarkLabel.snp.right).offset(12)
            make.size.equalTo(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(bookmarkView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(172)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(250)
        }
    }
	
	func fetchCourses() {

        isLoadingData = true
        showSkeleton()
        
		AF.request(Endpoints.courses.value, method: .get, headers: [
			.authorization(bearerToken: AuthService.shared.token)
		]).responseDecodable(of: [Course].self) { response in
			switch response.result {
				case .success(let courses):
                self.coursesArray = courses
                self.hideAllSkeleton()
                self.isLoadingData = false
				case .failure(let error):
                    print("error")
					self.showToast(type: .error, title: error.localizedDescription)
			}
		}
	}
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension CoursesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as? BannerCollectionViewCell
        else {
            fatalError("Unable to find a cell with identifier \"BannerCell\"")
        }
        cell.setData(banner: bannersArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: collectionView.bounds.width - 32, height: 124)
    }
}
    extension CoursesViewController: SkeletonCollectionViewDataSource{
        func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
            return "BannerCell"
        }
    }
// MARK: - UITableViewDataSource, UITableViewDelegate

extension CoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesArray.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as? CourseTableViewCell else {
            fatalError("Unable to find a cell with identifier \"CourseCell\"")
        }
        cell.isSkeletonable = true
        if !isLoadingData && !coursesArray.isEmpty {
            cell.setData(course: coursesArray[indexPath.row])
        }else{
            cell.configureSkeleton()
        }
    
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCourse = coursesArray[indexPath.row]
        let DetailViewController = CourseDetailViewController(course: selectedCourse)
        navigationController?.show(DetailViewController, sender: self)
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CourseCell"
    }
}

// MARK: - UIScrollViewDelegate

extension CoursesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
                scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
                showBookmarkButton()
            } else if scrollView.contentOffset.y < 0 {
                hideBookmarkButton()
            }
        }
    }
}

extension CoursesViewController {
    @objc
    func bookmarkTapped() {
        let bookmarkViewController = BookmarkViewController()
        
        navigationController?.show(bookmarkViewController, sender: self)
    }
    
    private func showBookmarkButton() {
           navigationItem.rightBarButtonItem = bookmarkButton
       }

    private func hideBookmarkButton() {
           navigationItem.rightBarButtonItem = nil
       }
    
    @objc func reloadTapped() {
        fetchCourses()
    }
    
    private func checkNetworkStatus() {
        guard let reachability = try? Reachability() else {
            print("Unable to create Reachability object")
            return
        }

        if reachability.isReachable {
            noInternetView.isHidden = true
            fetchCourses()
            bookmarkView.isHidden = false
            tableView.isHidden = false
            collectionView.isHidden = false
        } else {
            noInternetView.isHidden = false
            bookmarkView.isHidden = true
            tableView.isHidden = true
            collectionView.isHidden = true
        }
    }
}
