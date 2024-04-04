//
//  NotificationsViewController.swift
//  drevmass
//
//  Created by Kamila Sultanova on 14.03.2024.
//

import UIKit
import SnapKit
import UserNotifications

class NotificationsViewController: UIViewController {
    
    // MARK: - UI Elements

    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 17, weight: .semiBold)
        label.textColor = .appDark90
        label.textAlignment = .left
        label.text = "Напоминание о занятиях"
        
        return label
    }()
    
    private lazy var notificationSwitch: UISwitch = {
        let switchNotification = UISwitch()
        switchNotification.onTintColor = .appBeige100
        switchNotification.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        return switchNotification
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 15, weight: .medium)
        label.textColor = .appGray80
        label.textAlignment = .left
        label.text = "Отключение всех уведомлений"
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = .appBeige100
        navigationItem.largeTitleDisplayMode = .never
        title = "Уведомления"
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI(){
        view.addSubviews(mainLabel, notificationSwitch, descriptionLabel)
    }
    
    private func setupConstraints(){
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        notificationSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(mainLabel)
            make.left.equalTo(mainLabel.snp.right).offset(12)
            make.right.equalToSuperview().inset(16)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    @objc private func switchChanged() {
            if notificationSwitch.isOn {
                // Пользователь включил уведомления
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        DispatchQueue.main.async {
                            self.showToast(type: .success, title: "Уведомления включены")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showToast(type: .success, title: "Уведомления выключены")
                        }
                    }
                }
            } else {
                // Пользователь выключил уведомления
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    if settings.authorizationStatus == .authorized {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        DispatchQueue.main.async {
                            self.showToast(type: .success, title: "Уведомления отключены")
                        }
                    }
                }
            }
        }

}
