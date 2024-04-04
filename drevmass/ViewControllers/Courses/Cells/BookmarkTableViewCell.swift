//
// BookmarkTableViewCell
// Created by Kamila Sultanova on 14.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class BookmarkTableViewCell: UITableViewCell {
    
    weak var delegate: BookmarkViewController?
    
    var lessonsArray: [Favorite.Lesson] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var delegateBookmarkVC: LessonCellProtocol?
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .appFont(ofSize: 20, weight: .semiBold)
        label.textColor = .appDark100
  
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MarkedLessonCollectionViewCell.self, forCellWithReuseIdentifier: "MarkedCell")
        
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")}
    
    func setData(course: Favorite) {
        titleLabel.text = course.course_name
        lessonsArray = course.lessons

    }
    
    func setupViews() {
        contentView.addSubviews(titleLabel, collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    func setDelegateForCells(_ cell: MarkedLessonCollectionViewCell) {
        cell.delegateBookmarkVC = delegate
    }
}
extension BookmarkTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lessonsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarkedCell", for: indexPath) as? MarkedLessonCollectionViewCell
        else {
            fatalError("Unable to find a cell with identifier \"CourseCell\"")
        }
        
        cell.setData(lesson: lessonsArray[indexPath.row])
        setDelegateForCells(cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 246)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedLesson = lessonsArray[indexPath.row]
        delegate?.didSelectLesson(selectedLesson)
    }
}
