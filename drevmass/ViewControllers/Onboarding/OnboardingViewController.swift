//
// OnboardingViewController
// Created by Kamila Sultanova on 04.03.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SGSegmentedProgressBarLibrary
import SnapKit

class OnboardingViewController: UIViewController {
    
    private lazy var segmentBar: SGSegmentedProgressBar = {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width - 32, height: 2)

        self.segmentBar = SGSegmentedProgressBar(frame: rect, delegate: self, dataSource: self)

        return self.segmentBar
    }()
    
    var arraySlides: [[String]] = [["firstSlide", "Избавьтесь от боли в спине раз и навсегда!"], ["secondSlide", "Наша цель"], ["thirdSlide", "Спина требует ежедневного ухода!"]]
    
    private var currentPage: Int = 0
    
    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collView.showsHorizontalScrollIndicator = false
        collView.isPagingEnabled = true
        collView.delegate = self
        collView.dataSource = self
      
        collView.register(SlidesCollectionViewCell.self, forCellWithReuseIdentifier: "SlidesCell")
        return collView
    }()
    
    private lazy var enterButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Вход", for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .appBeige100
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.addTarget(self, action: #selector(enter), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Регистрация", for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.setTitleColor(.appBeige100, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.appBeige100.cgColor
        button.titleLabel?.font = .appFont(ofSize: 17, weight: .semiBold)
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = " "
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        view.backgroundColor = .white
        self.segmentBar.start()
    }
}

extension OnboardingViewController {
    func setupViews() {
        view.addSubviews(collectionView, enterButton, registerButton, segmentBar)
    }
    
    func setupConstraints() {
        enterButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        registerButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(enterButton.snp.right).offset(8)
            make.width.equalTo(enterButton)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.bottom.equalTo(enterButton.snp.top).offset(-16)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        segmentBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(2)
        }
    }
}

extension OnboardingViewController {
    @objc
    func enter() {
        self.segmentBar.pause()
        let signInVC = SignInViewController()
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    @objc
    func register() {
        self.segmentBar.pause()
        let signUpVC = RegistrationViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}

extension OnboardingViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySlides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlidesCell", for: indexPath) as? SlidesCollectionViewCell else {
            fatalError("Unable to find a cell with identifier SlidesCell!")
        }
        
        cell.setData(slide: arraySlides[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let touch = collectionView.panGestureRecognizer.location(in: collectionView.cellForItem(at: indexPath))
        let screenwidth = collectionView.cellForItem(at: indexPath)?.bounds.width
        if touch.x < screenwidth! / 2 {
            if currentPage > 0 {
                let prevIndexPath = IndexPath(item: currentPage - 1, section: 0)
                currentPage -= 1
                self.segmentBar.previousSegment()
                updateVisibleCells()
            }
        } else {
            if currentPage < arraySlides.count - 1 {
                let nextIndexPath = IndexPath(item: currentPage + 1, section: 0)
                currentPage += 1
                self.segmentBar.nextSegment()
                updateVisibleCells()
            }
        }
    }
}

extension OnboardingViewController: SGSegmentedProgressBarDelegate, SGSegmentedProgressBarDataSource {
    func segmentedProgressBarFinished(finishedIndex: Int, isLastIndex: Bool) {
       if currentPage < arraySlides.count - 1 {
           let nextIndexPath = IndexPath(item: currentPage + 1, section: 0)
           currentPage += 1
           updateVisibleCells()
       }
    }
    
    
    var numberOfSegments: Int {
        return 3
    }

    var segmentDuration: TimeInterval {
        return 3
    }

    var paddingBetweenSegments: CGFloat {
        return 2
    }

    var trackColor: UIColor {
        return UIColor.appDark90.withAlphaComponent(0.3)
    }

    var progressColor: UIColor {
        return UIColor.white
    }
    
    var roundCornerType: SGCornerType {
        return .roundCornerBar(cornerRadious: 1.5)
    }
}

extension OnboardingViewController {
    
private func updateVisibleCells() {
        for cell in collectionView.visibleCells {
            if let slidesCell = cell as? SlidesCollectionViewCell {
                slidesCell.setData(slide: arraySlides[currentPage])
            }
        }
    }
}
