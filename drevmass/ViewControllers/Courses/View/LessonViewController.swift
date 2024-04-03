//
// LessonViewController
// Created by Kamila Sultanova on 11.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import youtube_ios_player_helper
import Alamofire

class LessonViewController: UIViewController, YTPlayerViewDelegate {

    var lesson: LessonProtocol
    
    var courseId: Int?
    
    var products: [LessonProducts.UsedProducts] = []

    // MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false

        return scrollView
    }()

    private lazy var contentView: UIView = UIView()
    
    private lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .CourseButton.shareBeige, style: .plain, target: self, action: #selector(shareTapped))
        
        return button
    }()
    
    private lazy var bookmarkBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .CourseButton.bookmark, style: .plain, target: self, action: nil)
        
        return button
    }()
    
    private lazy var lessonImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 16
        imageView.sd_setImage(with: URL(string: "http://45.12.74.158/\(lesson.image)"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()
    
    private lazy var playerView: YTPlayerView = {
        let player = YTPlayerView()
        
        player.layer.cornerRadius = 16
        player.contentMode = .scaleAspectFill
        player.clipsToBounds = true
        player.delegate = self
        
        return player
    }()
    
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.Course.playButton, for: .normal)
        button.addTarget(self, action: #selector(playButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .appFont(ofSize: 13, weight: .regular)
        label.textColor = .appGray60
        
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 13)
        ]
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 13, weight: .bold)
        ]
        
        let lessonTimeAttributedString = NSAttributedString(string: "\(Int(floor(Double(lesson.duration) / 60.0)))", attributes: boldAttributes)
        let attributedString = NSMutableAttributedString()
        attributedString.append(lessonTimeAttributedString)
        attributedString.append(NSAttributedString(string: " мин", attributes: regularAttributes))
        
        label.attributedText = attributedString
        
        return label
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
    
        button.setImage(.CourseButton.bookmark, for: .normal)
        button.addTarget(self, action: #selector(addToBookmark), for: .touchUpInside)

        return button
    }()
    
    private lazy var timeImageView: UIImageView = {
        let imageView = UIImageView()
    
        imageView.contentMode = .scaleAspectFill
        imageView.image = .CourseButton.time

        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = lesson.title
        label.textAlignment = .left
        label.font = .appFont(ofSize: 22, weight: .bold)
        label.textColor = .appDark90
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: lesson.description)
        let kernValue: CGFloat = 0.75
        attributedText.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attributedText.length))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        label.attributedText = attributedText
        label.textAlignment = .left
        label.font = .appFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var mentionedProductsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Товары используемые на видео"
        label.textAlignment = .left
        label.font = .appFont(ofSize: 20, weight: .semiBold)
        label.textColor = .appDark100
        
        return label
    }()
    
    private lazy var collectionView: SelfSizingCollectionView = {
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 0)
        layout.minimumInteritemSpacing = 10

        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ProductPlateCell.self, forCellWithReuseIdentifier: "ProductPlateCell")

        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    init(lesson: LessonProtocol) {
        self.lesson = lesson
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = " "
        navigationItem.title = lesson.name
        navigationController?.navigationBar.tintColor = UIColor(red: 0.71, green: 0.64, blue: 0.5, alpha: 1)
        navigationItem.rightBarButtonItem = shareButton
        setupViews()
        setupConstraints()
        configureViews()
        getProducts()
    }
}

private extension LessonViewController {
    func setupViews() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        view.addSubviews(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(playerView, lessonImageView, playButton, bookmarkButton, timeImageView, timeLabel, titleLabel, textLabel, mentionedProductsLabel, collectionView)
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
        lessonImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(212)
        }
        playerView.snp.makeConstraints { make in
            make.edges.equalTo(lessonImageView)
        }
        playButton.snp.makeConstraints { make in
            make.center.equalTo(lessonImageView)
            make.size.equalTo(44)
        }
        timeImageView.snp.makeConstraints { make in
            make.top.equalTo(lessonImageView.snp.bottom).offset(22)
            make.left.equalToSuperview().inset(16)
            make.size.equalTo(12)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeImageView)
            make.left.equalTo(timeImageView.snp.right).offset(6)
        }
        bookmarkButton.snp.makeConstraints { make in
            make.centerY.equalTo(timeImageView)
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeImageView.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(titleLabel)
        }
        mentionedProductsLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mentionedProductsLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(180)
            make.bottom.equalToSuperview().inset(32)
        }
    }
    
    func configureViews() {
        playerView.isHidden = true
        
        if lesson.isFavorite == true {
            bookmarkButton.setImage(UIImage.CourseButton.bookmarkBeige, for: .normal)
            bookmarkBarButton.image = .CourseButton.bookmarkBeige
        } else {
            bookmarkButton.setImage(UIImage.CourseButton.bookmark, for: .normal)
            bookmarkBarButton.image = .CourseButton.bookmark
        }
    }
}
extension LessonViewController {
    private func getProducts(){
        AF.request(Endpoints.courseIdLessons(courseId: courseId!, lessonId: lesson.id).value, method: .get, encoding: JSONEncoding.default, headers: [.authorization(bearerToken: AuthService.shared.token)])
            .responseDecodable(of: LessonProducts.self){ response in
                switch response.result {
                case .success(let products):
                    self.products = products.usedProducts
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                    self.showToast(type: .error, title:"\(error)")
                }
            }
    }
    
    @objc
    func addToBookmark() {
        var method = HTTPMethod.post
        var url = Endpoints.favorites.value
    
        if lesson.isFavorite {
            method = .delete
            url = "http://185.100.67.103/api/favorites/\(lesson.id)"
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: "\(AuthService.shared.token)")
        ]
            
        AF.upload(multipartFormData: { multipartFormData in
            if let textData = "\(self.lesson.id)".data(using: .utf8) {
                    multipartFormData.append(textData, withName: "lesson_id")
                }
            },
                to: url,
                method: method,
                headers: headers
            ).validate(statusCode: 200..<300).responseData {
                response in
                switch response.result {
                case .success:
                    print("Previous isFavorite: \(self.lesson.isFavorite)")
                    self.lesson.isFavorite.toggle()
                    self.configureViews()
                    print("New isFavorite: \(self.lesson.isFavorite)")
                case .failure(let error):
                    print(error.localizedDescription)
                    self.showToast(type: .error, title: error.localizedDescription)
                }
            }
    }


    @objc
    func shareTapped() {
        let text = lesson.title
        let image = lesson.image
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
    func playButtonClicked() {
        playerView.isHidden = false
        playButton.isHidden = true
        lessonImageView.isHidden = true
        self.playerView.delegate = self
        let playerVars: [String: Any] = [
                "autoplay": 1,
                "rel": 0
            ]
        self.playerView .load(withVideoId: "\(lesson.video)",playerVars: playerVars )
    }
    
    // MARK: - YTPlayerViewDelegate

    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .ended:
            markVideoAsWatched(courseId: courseId!, lessonId: lesson.id)
        default:
            break
        }
    }
    
    private func markVideoAsWatched(courseId: Int , lessonId: Int) {
        
        let parameters: [String: Int] = [
            "course_id": courseId,
            "lesson_id": lessonId
        ]
        
        AF.request(Endpoints.complete.value, method: .post, parameters: parameters, headers: [.authorization(bearerToken: AuthService.shared.token)])
            .response { response in
                switch response.result {
                case .success(_):
                    print("Video marked as completed")
                case .failure(let error):
              
                    print(error.localizedDescription)
                    self.showToast(type: .error, title: error.localizedDescription)
                }
            }
    }

    private func showBookmarkBarButton() {
        if navigationItem.rightBarButtonItems?.contains(bookmarkBarButton) == false {
            navigationItem.rightBarButtonItems = [shareButton, bookmarkBarButton]
        }
    }

    private func hideBookmarkBarButton() {
        if navigationItem.rightBarButtonItems?.contains(bookmarkBarButton) == true {
            navigationItem.rightBarButtonItems = [shareButton]
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension LessonViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductPlateCell" , for: indexPath) as? ProductPlateCell else {
            fatalError("Unable to find a cell with identifier ProductPlateCell!")
        }

        cell.setdata(product: products[indexPath.row])
        cell.productId = products[indexPath.row].id
        cell.delegateLessonVC = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165, height: 180)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailVC = ProductViewController(product: products[indexPath.row])
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension LessonViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > lessonImageView.frame.maxY {
            showBookmarkBarButton()
        } else {
            hideBookmarkBarButton()
        }
    }
}
