//
//  PromoVC.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 13.07.2021.
//
//

import UIKit

/// Контроллер Promo-экрана
final class PromoVC: UIPageViewController {

	/// Презентер
	var presenter: PromoPresenterProtocol?

	// Анимация pageСontrol идет/не идет
	private var isAnimating = false

	//Направление показа
	private var showDirection: UIPageViewController.NavigationDirection = .forward

	/// Текущий индекс экрана
	private var currentIndex: Int = 0

	/// Экраны
	private var screens: [ContentVC] = []

	override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
		super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: nil)
		view.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		dataSource = self
		delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presenter?.loadData()
	}

	// Блокировка действий пользователя
	private func blockUserActions(_ isBlock: Bool) {
		self.view.isUserInteractionEnabled = !isBlock
		self.isAnimating = isBlock
	}
}

//MARK: - UIPageViewControllerDelegate
extension PromoVC: UIPageViewControllerDelegate {
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

		guard let vc = previousViewControllers.first as? ContentVC else { return }
		guard let index = screens.firstIndex(of: vc) else { return }

		switch showDirection {
		case .forward:
			currentIndex = index + 1
		case .reverse:
			currentIndex = index - 1
		@unknown default:
			fatalError()
		}
	}
}

//MARK: - UIPageViewControllerDataSource
extension PromoVC: UIPageViewControllerDataSource {

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

		guard let vc = viewController as? ContentVC else { return nil }
		guard let index = screens.firstIndex(of: vc) else { return nil }
		guard index > 0 else { return nil }

		showDirection = .reverse

		return screens[index - 1]
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

		guard let vc = viewController as? ContentVC else { return nil }
		guard let index = screens.firstIndex(of: vc) else { return nil }
		guard index < screens.count - 1 else { return nil }

		showDirection = .forward

		return screens[index + 1]
	}

	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return screens.count
	}

	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		return currentIndex
	}
}

//MARK: - PromoViewProtocol
extension PromoVC: PromoViewProtocol {

	func update(with screens: [ContentVC]) {
		self.screens = screens
		if !screens.isEmpty {
			setViewControllers([screens[0]], direction: .forward, animated: true)
		}
	}

	func showScreen(with direction: UIPageViewController.NavigationDirection) {
		guard !isAnimating else { return }

		switch direction {
		case .forward:
			currentIndex += 1
			guard currentIndex < screens.count else { return }
		case .reverse:
			currentIndex -= 1
			guard currentIndex >= 0 else { return }
		@unknown default:
			fatalError()
		}

		blockUserActions(true)

		self.setViewControllers([screens[currentIndex]], direction: direction, animated: true) { _ in
			self.blockUserActions(false)
		}
	}

	func navigateToMainVC() {
		UserDefaults.standard.setValue(true, forKey: "isShowPromo")

		let tabBarVC = Assembly.createStartVC()
		tabBarVC.modalPresentationStyle = .fullScreen
		present(tabBarVC, animated: true, completion: nil)
	}
}
