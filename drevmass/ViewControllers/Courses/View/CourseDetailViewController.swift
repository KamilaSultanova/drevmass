//
// CourseDetailViewController
// Created by Kamila Sultanova on 07.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import UserNotifications
import PanModal
import Alamofire

class CourseDetailViewController: UIViewController {
    // MARK: - Local Notification variables
    
    var exerciseDays: [Int] = []
    
    var selectedHour: Int?
    
    var selectedMinute: Int?
    
    // MARK: - Arrays
    
    var lessonsArray: [CourseDetail.Lesson] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let course: Course
    
    // MARK: - UI Elements
    
    private lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .CourseButton.share, style: .plain, target: self, action: #selector(shareTapped))
        
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
        
        return view
    }()

    private lazy var courseView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true

        return view
    }()
    
    private lazy var posterImageview: UIImageView = {
        let imageview = UIImageView()
        
        imageview.contentMode = .scaleAspectFill
        imageview.sd_setImage(with: URL(string: "http://45.12.74.158/\(course.image)"))
        
        return imageview
    }()
    
    private lazy var gradientImageview: UIImageView = {
        let imageview = UIImageView()
        
        imageview.contentMode = .scaleAspectFill
        imageview.image = .Course.gradient
        
        return imageview
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = course.name
        label.textAlignment = .left
        label.font = .appFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var playImageview: UIImageView = {
        let imageview = UIImageView()
        
        imageview.contentMode = .scaleAspectFit
        imageview.image = .Course.play
        
        return imageview
    }()
    
    private lazy var lessonLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .appFont(ofSize: 13, weight: .bold)
        label.textColor = .white
        
        let lessonCount = course.number
        let (lessonString, suffix) = lessonCount.lessons()
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 13)
        ]
        let semiboldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 13, weight: .semiBold)
        ]
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.appFont(ofSize: 13, weight: .bold)
        ]
        
        let lessonCountAttributedString = NSAttributedString(string: "\(course.number)", attributes: boldAttributes)
        let lessonSuffixAttributedString = NSAttributedString(string: " \(lessonString)\(suffix)", attributes: regularAttributes)

        let attributedString = NSMutableAttributedString()
        attributedString.append(lessonCountAttributedString)
        attributedString.append(lessonSuffixAttributedString)
        attributedString.append(NSAttributedString(string: " · ", attributes: semiboldAttributes))
        attributedString.append(NSAttributedString(string: "\(Int(floor(Double(course.duration) / 60.0)))", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: " мин", attributes: regularAttributes))
        
        label.attributedText = attributedString
        
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Начать курс", for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(startLesson), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var progressView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .appBeige40
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var progressBar: UIProgressView = {
        let view = UIProgressView()
        
        view.progressTintColor = .appBeige100
        view.trackTintColor = .appBeige50
        view.progressViewStyle = .default
        
        return view
    }()
    
   var viewedLesson = 0
    
    private lazy var progressTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Пройдено уроков"
        label.textAlignment = .left
        label.font = .appFont(ofSize: 15, weight: .semiBold)
        label.textColor = .appDark100
    
        return label
    }()
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        
        label.text = "\(viewedLesson) из \(lessonsArray.count)"
        label.textAlignment = .right
        label.font = .appFont(ofSize: 15, weight: .semiBold)
        label.textColor = .appDark100
        label.textAlignment = .right
    
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .natural
        label.font = .appFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        label.numberOfLines = 0
        
        let attributedText = NSMutableAttributedString(string: "")
        let kernValue: CGFloat = 0.75
        attributedText.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attributedText.length))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    private lazy var fullDescriptionButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 16, weight: .regular)
        button.setTitle("подробнее", for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.textAlignment = .right
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(fullDescriptionTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var gradientView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = .Course.fade

        return imageView
    }()
    
    private lazy var bannerImageView: UIImageView = {
        let imageview = UIImageView()
        
        imageview.image = .Course.banner
        imageview.layer.cornerRadius = 20
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        
        return imageview
    }()
    
    private lazy var bannerLabel: UILabel = {
        let label = UILabel()
        
        label.font = .appFont(ofSize: 15, weight: .semiBold)
        label.textColor = .appDark90
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var bonusView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var bonusLabel: UILabel = {
        let label = UILabel()
        
        label.font = .appFont(ofSize: 13, weight: .semiBold)
        label.textColor = .appDark100
        
        return label
    }()
    
    private lazy var bonusImageview: UIImageView = {
        let imageview = UIImageView()
        
        imageview.contentMode = .scaleAspectFit
        imageview.image = .Course.bonus
        
        return imageview
    }()
    
    private lazy var calendarView: CalendarView = {
        let view = CalendarView()
        
        view.delegate = self
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.appBeige40.cgColor
        view.backgroundColor = .white

        return view
    }()  
    private lazy var lessonsListLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Уроки"
        label.font = .appFont(ofSize: 22, weight: .bold)
        label.textColor = .appDark90
        
        return label
    }()
    
    private lazy var tableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(LessonTableViewCell.self, forCellReuseIdentifier: "LessonCell")

        return tableView
    }()
    
    // MARK: - Lifecycle

    init(course: Course) {
        self.course = course
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        setupViews()
        setupConstraints()
        navigationItem.rightBarButtonItem = shareButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .white
        configureViews()
        fetchCourseDetail()
    }
    
}

extension CourseDetailViewController {
    
    // MARK: - Retrive Info
    
    func fetchCourseDetail() {
        let courseId = course.id
        
        AF.request(Endpoints.courseDetail(id: courseId).value, method: .get, headers: [
            .authorization(bearerToken: AuthService.shared.token)
        ]).responseDecodable(of: CourseDetail.self) { [self] response in
            switch response.result {
            case .success(let detailedCourse):
                
                if let bonus = detailedCourse.course?.bonus_info {
                    bonusLabel.text = " +\(bonus.price)"
                    bannerLabel.text = "Начислим \(bonus.price) бонусов за прохождение курса"
                }
                if let description = detailedCourse.course {
                    let attributedText = NSMutableAttributedString(string: "\(detailedCourse.course!.description)")
                    let kernValue: CGFloat = 0.75
                    attributedText.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attributedText.length))

                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 5
                    attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
                    
                    descriptionLabel.attributedText = attributedText
                }
                
                var viewedLessonCount = 0
                
                if let lessons = detailedCourse.course?.lessons {
                       lessonsArray = lessons
                       
            
                   for lesson in lessons {
                       if lesson.completed == true {
                           startLesson()
                           viewedLessonCount += 1
                           }
                       }
                   } else {
                       print("Lessons array is nil.")
                   }
                           
                   // Устанавливаем прогресс
                   let progress = Float(viewedLessonCount) / Float(lessonsArray.count)
                   progressBar.setProgress(progress, animated: false)
                   progressLabel.text = "\(viewedLessonCount) из \(lessonsArray.count)"
                   
                   // Проверяем, завершены ли все уроки
                   if viewedLessonCount == lessonsArray.count {
                       courseCompleted()
                   }
            case .failure(let error):
                print("\(error.localizedDescription)")
                print(String(data: response.data ?? Data(), encoding: .utf8))
            }
        }
    }
}

extension CourseDetailViewController {
    func setupViews() {
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(posterImageview, gradientImageview, courseView, titleLabel, playImageview, lessonLabel, startButton)
        courseView.addSubviews(progressView, descriptionLabel, fullDescriptionButton, gradientView, bannerImageView, calendarView, lessonsListLabel, tableView)
        progressView.addSubviews(progressLabel, progressTitleLabel, progressBar)
        bannerImageView.addSubviews(bannerLabel, bonusView)
        bonusView.addSubviews(bonusLabel, bonusImageview)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        
        posterImageview.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(400)
            make.bottom.equalTo(courseView.snp.top).inset(24)
        }
        
        gradientImageview.snp.makeConstraints { make in
            make.bottom.equalTo(posterImageview.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        courseView.snp.makeConstraints { make in
            make.top.equalTo(posterImageview.snp.bottom).inset(24)
            make.horizontalEdges.bottom.equalTo(contentView)
            make.bottom.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(66)
        }
        
        progressTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(progressLabel.snp.left).offset(8)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(progressTitleLabel.snp.right).offset(8)
        }
        
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(progressTitleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(19)
            make.height.equalTo(70)
        }
        
        playImageview.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalTo(lessonLabel)
            make.size.equalTo(12)
        }
        
        lessonLabel.snp.makeConstraints { make in
            make.left.equalTo(playImageview.snp.right).offset(6)
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.right.equalToSuperview().inset(16)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(lessonLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        fullDescriptionButton.snp.makeConstraints { make in
            make.right.equalTo(descriptionLabel.snp.right)
            make.bottom.equalTo(descriptionLabel)
            make.height.equalTo(20)
            make.left.equalTo(gradientView.snp.right)
        }
        
        gradientView.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.bottom)
        }
        
        bannerImageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(72)
        }
        
        bannerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(202)
        }
        
        bonusView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
        
        bonusLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.centerY.equalTo(bonusView)
        }
        
        bonusImageview.snp.makeConstraints { make in
            make.left.equalTo(bonusLabel.snp.right).offset(4)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
            make.right.equalToSuperview().inset(2)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(63)
        }
        
        lessonsListLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(lessonsListLabel.snp.bottom).offset(24)
            make.bottom.equalToSuperview().inset(100)
        }
    }
    
    private func configureViews() {
        
        descriptionLabel.layoutIfNeeded()
        if descriptionLabel.maxNumberOfLines < 4 {
            descriptionLabel.numberOfLines = 3
            fullDescriptionButton.isHidden = true
            gradientView.isHidden = true
        }
        descriptionLabel.numberOfLines = 3
        
        if course.bonus.price == 0 {
            bannerImageView.isHidden = true
            bannerLabel.isHidden = true
            bonusView.isHidden = true
            calendarView.snp.makeConstraints { make in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            }
        }
        if startButton.isHidden == true {
            startLesson()
        } else {
            progressView.isHidden = true
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LessonCell", for: indexPath) as? LessonTableViewCell else {
            fatalError("Unable to find a cell with identifier \"CourseCell\"")
        }
        
            let lesson = lessonsArray[indexPath.row]
            cell.setData(lesson: lesson, row: indexPath.row + 1)
            cell.selectionStyle = .none
            cell.delegateCourseDetailVC = self
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLesson = lessonsArray[indexPath.row]
        let LessonVC = LessonViewController(lesson: selectedLesson)
        LessonVC.courseId = course.id
        navigationController?.show(LessonVC, sender: self)
    }
}

// MARK: - UIScrollViewDelegate

extension CourseDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > titleLabel.frame.maxY {
            title = course.name
            navigationController?.navigationBar.tintColor = UIColor(red: 0.71, green: 0.64, blue: 0.5, alpha: 1)
            shareButton.image = .CourseButton.shareBeige
        } else {
            title = ""
            navigationController?.navigationBar.tintColor = .white
            shareButton.image = .CourseButton.share
        }
    }
}
// MARK: - Action Methods

extension CourseDetailViewController {
    
    @objc
    func shareTapped() {
        let text = course.name
        let image = course.image

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
    func startLesson() {
        startButton.isHidden = true
        progressView.isHidden = false
       
        titleLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(lessonLabel.snp.top).offset(-12)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(19)
            make.height.equalTo(70)
        }
        
        lessonLabel.snp.remakeConstraints { make in
            make.left.equalTo(playImageview.snp.right).offset(6)
            make.bottom.equalTo(courseView.snp.top).offset(-20)
            make.right.equalToSuperview().inset(16)
        }
        descriptionLabel.snp.remakeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    @objc
    func fullDescriptionTapped() {
        if descriptionLabel.numberOfLines > 3 {
            descriptionLabel.numberOfLines = 3
            fullDescriptionButton.isHidden = false
            gradientView.isHidden = false
        } else {
            descriptionLabel.numberOfLines = 20
            fullDescriptionButton.isHidden = true
            gradientView.isHidden = true
        }
    }
    
    @objc
    func courseCompleted() {
        let alertVC = AlertViewController(course: course)
        alertVC.modalPresentationStyle = .overFullScreen
        present(alertVC, animated: true)
    }
    
    func updateLessons(){
        fetchCourseDetail()
        configureViews()
    }
}

extension Int {
    func lessons() -> String {
        var lessonString: String!
        if self == 1 || (self % 10 == 1 && self % 100 != 11) {
            lessonString = "урок"
        } else if (2...4).contains(self % 10) && !(12...14).contains(self % 100) {
            lessonString = "урока"
        } else {
            lessonString = "уроков"
        }
        return "\(self) " + lessonString
    }
}

extension CourseDetailViewController: CalendarViewDelegate {
    
    func calendarViewDidTapDayButton() {
        let weekVC = WeekViewController()
        weekVC.modalPresentationStyle = .overFullScreen
        weekVC.delegate = self
        presentPanModal(weekVC)
    }
    
    func calendarViewDidTapTimeButton() {
        let timeVC = TimeViewController()
        timeVC.modalPresentationStyle = .overFullScreen
        timeVC.delegate = self
        presentPanModal(timeVC)
    }

    func calendarViewSwitchChanged(isOn: Bool) {
        if isOn {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    DispatchQueue.main.async {
                        self.showToast(type: .success, title: "Настройки успешно сохранены")
                    }
                }
            }
            calendarView.snp.remakeConstraints { make in
                if bannerImageView.isHidden == true {
                    make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
                }
                make.top.equalTo(bannerImageView.snp.bottom).offset(24)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.height.equalTo(163)}
        } else {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    DispatchQueue.main.async {
                        self.showToast(type: .success, title: "Настройки успешно сохранены")
                    }
                }
            }
        
            calendarView.snp.remakeConstraints { make in
                if bannerImageView.isHidden == true {
                    make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
                }
                make.top.equalTo(bannerImageView.snp.bottom).offset(24)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.height.equalTo(63)}
        }
        self.calendarView.layoutIfNeeded()
    }
    
    @objc
    func dayButtonTapped() {
        let weekVC = WeekViewController()
        weekVC.modalPresentationStyle = .overFullScreen
        weekVC.delegate = self
        present(weekVC, animated: true)
    }
    
    @objc
    func timeButtonTapped() {
        let timeVC = TimeViewController()
        timeVC.modalPresentationStyle = .overFullScreen
        timeVC.delegate = self
        present(timeVC, animated: true)
    }
}

extension CourseDetailViewController: TimeViewControllerDelegate, WeekViewControllerDelegate {
    
    func didSelectTime(_ time: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedTime = dateFormatter.string(from: time)
        calendarView.timePickerLabel.text = formattedTime
        
        var timeComponents = DateComponents()
        timeComponents.calendar = Calendar.current
        
        if let timeDate = dateFormatter.date(from: formattedTime) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: timeDate)
            
            selectedHour = components.hour
            selectedMinute = components.minute
            
        if let _ = selectedHour, let _ = selectedMinute, !exerciseDays.isEmpty {
            scheduleNotification()
            }
        }
    }
    func didSelectDays(_ selectedDays: [String]) {
        let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт"]
        let everyday = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        let weekend = ["Сб", "Вс"]
        
        if selectedDays == weekdays {
            calendarView.daysLabel.text = "Будние дни"
        } else if selectedDays == weekend {
            calendarView.daysLabel.text = "Выходные дни"
        } else if selectedDays == everyday {
            calendarView.daysLabel.text = "Каждый день"
        } else {
            calendarView.daysLabel.text = selectedDays.joined(separator: ", ")
        }
        
        let daysInNumbers: [String: Int] = ["Пн": 2, "Вт": 3, "Ср": 4, "Чт": 5, "Пт": 6, "Сб": 7, "Вс": 1]

        for day in selectedDays {
            if let value = daysInNumbers[day] {
                exerciseDays.append(value)
            }
        }
        
        if let _ = selectedHour, let _ = selectedMinute, !exerciseDays.isEmpty {
            scheduleNotification()
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Напоминание о тренировке"
        content.body = "Пора приступить к упражнениям!"
        content.sound = .default

        for selectedDay in exerciseDays {
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.weekday = selectedDay

        if let hour = selectedHour, let minute = selectedMinute {
            dateComponents.hour = hour
            dateComponents.minute = minute
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully!")
                }
            }
        }
    }
}
