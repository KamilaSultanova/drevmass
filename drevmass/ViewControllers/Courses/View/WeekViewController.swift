//
// WeekViewController
// Created by Kamila Sultanova on 12.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//
import UIKit
import SnapKit
import PanModal

class DayCollectionViewCell: UICollectionViewCell {
    
     var dayView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.appBeige40.cgColor
       
        return view
    }()
    
   var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .appFont(ofSize: 15, weight: .semiBold)
        label.textColor = .appDark100
        
        return label
    }()
    
    var isSelectedCell: Bool = false {
        didSet {
            updateCellAppearance()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(dayView)
        dayView.addSubview(titleLabel)
        
        dayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateCellAppearance() {
           if isSelectedCell {
               dayView.backgroundColor = .appBeige30
               dayView.layer.borderColor = UIColor(red: 0.71, green: 0.64, blue: 0.5, alpha: 1).cgColor
               titleLabel.textColor = UIColor(red: 0.71, green: 0.64, blue: 0.50, alpha: 1.00)
           } else {
               dayView.backgroundColor = .white
               dayView.layer.borderColor = UIColor.appBeige40.cgColor
           }
       }
}

class WeekViewController: UIViewController, PanModalPresentable {
    
    var longFormHeight: PanModalHeight = .intrinsicHeight
    var cornerRadius: CGFloat = 24
    var panModalBackgroundColor: UIColor = .appModalBackground
    
    weak var delegate: WeekViewControllerDelegate?
    
    var daysOfWeek = [["Понедельник", "Пн"], ["Вторник", "Вт"], ["Среда", "Ср"], ["Четверг", "Чт"], ["Пятница", "Пт"], ["Суббота", "Сб"], ["Воскресенье", "Вс"]]
    var selectedDays: [String] = []
    
    var panScrollable: UIScrollView? {
        return nil
    }
     
    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Дни занятий"
        label.font = .appFont(ofSize: 20, weight: .semiBold)
        label.textColor = .appDark90
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .appFont(ofSize: 15, weight: .semiBold)
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = UIColor(red: 0.71, green: 0.64, blue: 0.5, alpha: 1)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: "DayCell")

        return collectionView
    }()
          
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
}

private extension WeekViewController {
    func setupViews() {
        view.addSubviews(daysLabel, saveButton, collectionView)
    }
    
    func setupConstraints() {
        daysLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(24)
        }
       
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(daysLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(232)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
extension WeekViewController {
      @objc
      func saveButtonTapped() {
          delegate?.didSelectDays(selectedDays)
          self.dismiss(animated: true)
      }
}

extension WeekViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysOfWeek.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as? DayCollectionViewCell else {
            fatalError("Unable to find a cell with identifier \"DayCell\"")
        }
        
        cell.titleLabel.text = daysOfWeek[indexPath.row][0]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 24 * 2 - 8) / 2, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DayCollectionViewCell else {
            fatalError("Unable to find a cell at indexPath \(indexPath)")
        }
        cell.dayView.backgroundColor = .appBeige30
        cell.dayView.layer.borderColor = UIColor(red: 0.71, green: 0.64, blue: 0.5, alpha: 1).cgColor
        
        let selectedDay = daysOfWeek[indexPath.row][1]
        
        cell.isSelectedCell.toggle()
        
        if cell.isSelectedCell {
                    selectedDays.append(selectedDay)
                } else {
                    if let index = selectedDays.firstIndex(of: selectedDay) {
                        selectedDays.remove(at: index)
                    }
                }
        
        selectedDays.sort { (day1, day2) -> Bool in
               guard let index1 = daysOfWeek.firstIndex(where: { $0[1] == day1 }),
                     let index2 = daysOfWeek.firstIndex(where: { $0[1] == day2 }) else {
                   return false
               }
               return index1 < index2
           }
    }
}
