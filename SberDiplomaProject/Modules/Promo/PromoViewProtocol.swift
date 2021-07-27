//
//  PromoViewProtocol.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 23.07.2021.
//

import UIKit

/// Протокол Вью для Promo-экрана
protocol PromoViewProtocol: AnyObject {
	/// Обновить содержимое
	/// - Parameter screens: набор экранов для отображения
	func update(with screens: [ContentVC])

	/// Показать экран
	/// - Parameter direction: следующий/предыдущий
	func showScreen(with direction: UIPageViewController.NavigationDirection)

	/// Перейти к главному экрану
	func navigateToMainVC()
}
