//
// ToastView
// Created by Nurasyl Melsuly on 13.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit
import SnapKit

enum ToastType: String {
	case networkError = "Нет интернета"
	case error
	case warning
	case success
}

final class ToastView: UIView {
	
	// MARK: - Properties
	private let type: ToastType
	private let title: String?
	
	// MARK: - UI Elements
	private lazy var iconImageView: UIImageView = {
		let imageView = UIImageView()
		
		imageView.tintColor = .white
		imageView.image = switch type {
			case .error: .Toast.error
			case .networkError: .Toast.networkError
			case .warning: .Toast.warning
			case .success: .Toast.success
		}
		
		return imageView
	}()
	
	private lazy var label: UILabel = {
		let label = UILabel()
		
		label.text = title ?? type.rawValue
		label.font = .appFont(ofSize: 15, weight: .semiBold)
		label.textColor = .white
		
		return label
	}()
	
	// MARK: - Lifecycle
	
	init(type: ToastType, title: String?) {
		self.title = title
		self.type = type
		super.init(frame: .zero)
		setupView()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func dismiss() {
		UIView.animate(withDuration: 0.2, animations: {
			self.frame.origin.y = -self.bounds.height
			self.layer.opacity = 0
		}, completion: { _ in
			self.removeFromSuperview()
		})
	}
}

extension ToastView {
	private func setupView() {
		layer.cornerRadius = 20
		layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
		backgroundColor = switch type {
			case .error: .Toast.error
			case .networkError: .Toast.networkError
			case .warning: .Toast.warning
			case .success: .Toast.success
		}
		
		addSubviews(iconImageView, label)
	}
	
	private func setupConstraints() {
		iconImageView.snp.makeConstraints { make in
			make.size.equalTo(24)
			make.leading.bottom.equalToSuperview().inset(16)
		}
		
		label.snp.makeConstraints { make in
			make.centerY.equalTo(iconImageView)
			make.leading.equalTo(iconImageView.snp.trailing).offset(12)
			make.trailing.equalToSuperview().inset(16)
		}
	}
}
