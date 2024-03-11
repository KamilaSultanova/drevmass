//
// UIViewController+Toast
// Created by Nurasyl Melsuly on 13.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import UIKit

extension UIViewController {
	/**
	 Показывает всплывающее сообщение (toast) на экране контроллера.

	 Этот метод создаёт и отображает всплывающее сообщение, которое можно настроить. Он прост в использовании и гибок, предлагая настройки по умолчанию и опции для кастомизации.

	 - Параметры:
		- type: Тип сообщения `ToastType`, определяющий стиль и содержание сообщения. Этот параметр обязателен. Возможные значения:
			- .networkError: Сообщение "Нет интернета", используется при ошибках сети.
			- .error: Общее сообщение об ошибке.
			- .warning: Предупреждение для пользователя.
			- .success: Сообщение об успешном действии.
		- title: Необязательная строка `String`, которая будет отображаться как заголовок сообщения. По умолчанию `nil`.
		- autoClose: Булево значение `Bool`, определяющее, должно ли сообщение исчезать автоматически. По умолчанию `true`.

	 - Возвращает: Замыкание типа `() -> Void`. Если `autoClose` равно `true`, вызов этого замыкания ничего не делает. Если `autoClose` равно `false`, вызов этого замыкания закроет сообщение.

	 - Использование:
		1. Вызовите `showToast` на любом экземпляре `UIViewController`.
		2. Передайте необходимый `type` и опциональные `title` и `autoClose`.
		3. Сообщение появится в верхней части контроллера или навигационного контроллера, если он присутствует.
		4. Если `autoClose` установлено в `false`, вы можете вручную закрыть сообщение, вызвав возвращаемое замыкание.
	 */
	@discardableResult
	func showToast(type: ToastType, title: String? = nil, autoClose: Bool = true) -> (() -> Void) {
		let toastView = ToastView(type: type, title: title)
		let window = UIApplication.shared.windows.first
		let topSpace = window?.safeAreaLayoutGuide.layoutFrame.minY ?? 0
		let toastHeight = topSpace + 54
		
		toastView.frame = CGRect(x: 0, y: -toastHeight, width: view.bounds.width, height: toastHeight)
		toastView.layer.opacity = 0
		
		if let navigationController {
			navigationController.view.addSubview(toastView)
		} else {
			view.addSubview(toastView)
		}
		
		UIView.animate(withDuration: 0.2, animations: {
			toastView.frame.origin.y = 0
			toastView.layer.opacity = 1
		}, completion: { _ in
			if autoClose {
				DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Constants.toastAutoCloseTime)) {
					toastView.dismiss()
				}
			}
		})
		
		return autoClose ? {} : toastView.dismiss
	}
}
