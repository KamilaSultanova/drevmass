//
// CalendarView
// Created by Kamila Sultanova on 16.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//
import UIKit
import SnapKit

protocol CalendarViewDelegate: AnyObject {
    func calendarViewSwitchChanged(isOn: Bool)
    func calendarViewDidTapDayButton()
    func calendarViewDidTapTimeButton()
}

protocol TimeViewControllerDelegate: AnyObject {
    func didSelectTime(_ time: Date)
}

protocol WeekViewControllerDelegate: AnyObject {
    func didSelectDays(_ selectedDays: [String])
}

class CalendarView: UIView {
    
    weak var delegate: CalendarViewDelegate?
    
    // MARK: - UI Elements

    private lazy var calendarLabel: UILabel = {
        let label = UILabel()
        
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .appDark100
        label.text = "Календарь занятий"
        
        return label
    }()
    
    private lazy var calendarImageview: UIImageView = {
        let imageview = UIImageView()
        
        imageview.contentMode = .scaleAspectFit
        imageview.image = .CourseButton.calendar
        
        return imageview
    }()
    
    private lazy var calendarSwitch: UISwitch = {
        let calendarSwitch = UISwitch()
        
        calendarSwitch.onTintColor = UIColor(red: 0.71, green: 0.64, blue: 0.5, alpha: 1)
        calendarSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        return calendarSwitch
    }()
    
    private lazy var daysView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dayButtonTapped))
        
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var trainingDaysLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Дни занятий"
        label.font = .appFont(ofSize: 17, weight: .regular)
        label.textColor = .appDark100
        label.numberOfLines = 1
      
        return label
    }()

    lazy var daysLabel: UILabel = {
        let label = UILabel()
        
        label.text = " "
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = UIColor(red: 0.71, green: 0.64, blue: 0.5, alpha: 1)
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var dayImageView: UIImageView = {
        let imageview = UIImageView()
        
        imageview.contentMode = .scaleAspectFit
        imageview.image = .CourseButton.arrow
        
        return imageview
    }()
    
    private lazy var timeView: UIView = {
        let view = UIView()
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(timeButtonTapped))
        
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Время"
        label.font = .appFont(ofSize: 17, weight: .regular)
        label.textColor = .appDark100
        
        return label
    }()
    
   lazy var timePickerLabel: UILabel = {
        let label = UILabel()
        
        label.text = " "
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = UIColor(red: 0.71, green: 0.64, blue: 0.5, alpha: 1)
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var timeImageView: UIImageView = {
        let imageview = UIImageView()
        
        imageview.contentMode = .scaleAspectFit
        imageview.image = .CourseButton.arrow
        
        return imageview
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubviews(calendarLabel, calendarImageview, calendarSwitch, daysView, timeView)
        daysView.addSubviews(daysLabel, trainingDaysLabel, dayImageView)
        timeView.addSubviews(timeLabel, timePickerLabel, timeImageView)
    }

    private func setupConstraints() {
        calendarImageview.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(16)
            make.size.equalTo(24)
            make.centerY.equalTo(calendarSwitch)
        }
        
        calendarLabel.snp.makeConstraints { make in
            make.left.equalTo(calendarImageview.snp.right).offset(12)
            make.centerY.equalTo(calendarSwitch)
        }
        
        calendarSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(calendarLabel.snp.right).offset(12)
            make.top.equalToSuperview().inset(16)
        }  
        
        trainingDaysLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.right.equalTo(daysLabel.snp.left)
            make.width.equalTo(100)
        }
        
        dayImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
            make.left.equalTo(daysLabel.snp.right).offset(4)
        }
        
        daysLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }

        timeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.right.equalTo(timePickerLabel.snp.left).offset(12)
        }
        
        timeImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
            make.left.equalTo(timePickerLabel.snp.right).offset(4)
        }
        
        timePickerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        daysView.snp.makeConstraints { make in
            make.top.equalTo(calendarSwitch.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        timeView.snp.makeConstraints { make in
            make.top.equalTo(daysView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }

    // MARK: - Action Methods

    @objc
    func switchChanged() {
        delegate?.calendarViewSwitchChanged(isOn: calendarSwitch.isOn)
    }
    
    @objc 
    func dayButtonTapped() {
        delegate?.calendarViewDidTapDayButton()
    }

    @objc
    func timeButtonTapped() {
        delegate?.calendarViewDidTapTimeButton()
    }
}
