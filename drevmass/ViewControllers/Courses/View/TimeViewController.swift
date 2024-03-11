//
// TimeViewController
// Created by Kamila Sultanova on 12.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SnapKit
import PanModal

class TimeViewController: UIViewController, PanModalPresentable {
    
    var longFormHeight: PanModalHeight = .intrinsicHeight
    var cornerRadius: CGFloat = 24
    var panModalBackgroundColor: UIColor = .appModalBackground
    
    weak var delegate: TimeViewControllerDelegate?
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    private var userSelectedTime = false
    
   lazy var timePicker: UIDatePicker = {
        let time = UIDatePicker()
        
        time.datePickerMode = .time
        time.locale = Locale(identifier: "ru_RU")
        time.preferredDatePickerStyle = .wheels
        time.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        
        return time
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Время занятий"
        label.font = .appFont(ofSize: 20, weight: .semiBold)
        label.textColor = .appDark90
        
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
}

private extension TimeViewController {
    
    func setupViews() {
        view.addSubviews(timePicker, saveButton, timeLabel)
    }
    
    func setupConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(24)
        }
        timePicker.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(24)
            make.height.equalTo(208)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(timePicker.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
    
extension TimeViewController {
    
    @objc
    func timePickerValueChanged() {
        if userSelectedTime {
            delegate?.didSelectTime(timePicker.date)
        }
    }
    @objc
    func saveButtonTapped() {
        userSelectedTime = true
        timePickerValueChanged()
        self.dismiss(animated: true)
    }
}
