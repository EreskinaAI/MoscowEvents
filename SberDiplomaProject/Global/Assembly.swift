//
//  Assembly.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 11.07.2021.
//

import UIKit

// Класс который собирает ВьюКонтроллеры
final class Assembly {

	/// Собрать контроллер для показа Событий
	/// - Parameter category: категория события
	/// - Returns: ВьюКонтроллер
	static func makeEventsListVC(with category: String) -> UIViewController {
		let eventsListVC = EventsListVC()
		let presenter = EventListPresenter(networkService: NetworkService(), localStoredService: CoreDataService.shared, category: category)
		eventsListVC.presenter = presenter
		presenter.view = eventsListVC

		return eventsListVC
	}

	/// Собрать контроллер для показа Избранных событий
	/// - Returns: ВьюКонтроллер
	static func makeFavoutiteVC() -> UIViewController {
		let favouritesVC = EventsListVC()
		favouritesVC.isPagination = false
		let presenter = FavouritePresenter(localStoredService: CoreDataService.shared)
		favouritesVC.presenter = presenter
		presenter.view = favouritesVC

		return favouritesVC
	}

	/// Собрать контроллер для показа поиска событий
	/// - Returns: ВьюКонтроллер
	static func makeSearchVC() -> UIViewController {
		let searchVC = SearchVC()
		let presenter = SearchPresenter(networkService: NetworkService(), localStoredService: CoreDataService.shared)
		searchVC.presenter = presenter
		presenter.view = searchVC

		return searchVC
	}

	/// Собрать контроллер для показа детальной информации о событии
	/// - Parameter model: модель отображения события
	/// - Returns: ВьюКонтроллер
	static func makeDetailsVC(with model: EventViewModel) -> UIViewController {
		let detailsVC = EventDetailsVC()
		let presenter = EventDetailsPresenter(model: model, localStoredService: CoreDataService.shared, networkService: NetworkService())
		detailsVC.presenter = presenter
		presenter.view = detailsVC

		return detailsVC
	}

	/// Собрать контроллер для показа категорий
	/// - Returns: ВьюКонтроллер
	static func makeCategoriesVC() -> UIViewController {
		let categoriesVC = CategoriesVC()
		let presenter = CategoriesPresenter()
		categoriesVC.presenter = presenter
		presenter.view = categoriesVC

		return categoriesVC
	}

	/// Собрать контроллер для показа Promo-экрана
	/// - Returns: ВьюКонтроллер
	static func makePromoVC() -> UIViewController {
		let promoVC = PromoVC()
		let presenter = PromoPresenter()
		promoVC.presenter = presenter
		presenter.view = promoVC

		return promoVC
	}
}

extension Assembly {
	private static let keyForPromoShow = "isShowPromo"

	/// Создать стартовый ВьюКонтроллер
	/// - Returns: ВьюКонтроллер
	static func createStartVC() -> UIViewController {
		let isShowPromo = UserDefaults.standard.object(forKey: keyForPromoShow) as? Bool

		if let isShowPromo = isShowPromo, isShowPromo {
			return createTabBarVC()
		} else {
			return makePromoVC()
		}
	}

	/// Создать ТабБар контроллер
	/// - Returns: ВьюКонтроллер
	private static func createTabBarVC() -> UIViewController {
		setupAppApperanceFont()

		let eventsVC = Assembly.makeCategoriesVC()
		eventsVC.tabBarItem = UITabBarItem(title: "События", image: UIImage(named: "events"), tag: 0)

		let favouritesVC = Assembly.makeFavoutiteVC()
		favouritesVC.navigationItem.title = "Избранное"
		favouritesVC.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(named: "favourites"), tag: 1)

		let searchVC = Assembly.makeSearchVC()
		searchVC.tabBarItem = UITabBarItem(title: "Поиск", image: UIImage(named: "search"), tag: 2)

		let eventsNavVC = UINavigationController(rootViewController: eventsVC)
		let favouritesNavVC = UINavigationController(rootViewController: favouritesVC)
		let searchNavVC = UINavigationController(rootViewController: searchVC)

		let tabBarVC = UITabBarController()
		tabBarVC.tabBar.tintColor = #colorLiteral(red: 0.02914242074, green: 0.4192609787, blue: 0.03124724142, alpha: 1)
		tabBarVC.setViewControllers([eventsNavVC, favouritesNavVC, searchNavVC], animated: true)

		return tabBarVC
	}

	/// Установка глобальных шрифтов и цвета текста
	private static func setupAppApperanceFont() {
		if let font = UIFont(name: "Chalkboard SE", size: 10) {
			UITabBarItem.appearance().setTitleTextAttributes([.font: font], for: .normal)
		}

		if let font = UIFont(name: "ChalkboardSE-Bold", size: 22) {
			UINavigationBar.appearance().titleTextAttributes = [.font: font,
																.foregroundColor: #colorLiteral(red: 0.02914242074, green: 0.4192609787, blue: 0.03124724142, alpha: 1)]
			UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
		}

		if let font = UIFont(name: "ChalkboardSE-Bold", size: 16) {
			UIBarButtonItem.appearance().setTitleTextAttributes([.font: font, .foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)], for: .normal)
		}
	}
}
