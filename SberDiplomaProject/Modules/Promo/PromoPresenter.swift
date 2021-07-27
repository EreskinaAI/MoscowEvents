//
//  PromoPresenter.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 18.07.2021.
//

/// Протокол Презентера Promo-экрана
protocol PromoPresenterProtocol {
	/// Загрузить данные
	func loadData()
}

/// Презентер Promo-экрана
final class PromoPresenter {

	/// Вью для отображения
	weak var view: PromoViewProtocol?

	/// Экраны
	private lazy var screens: [ContentVC] = [
		ContentVC(with: "firstScreen",
				  text: firstScreenText,
				  leftAction: nil,
				  rightAction: { [weak self] in
					self?.view?.showScreen(with: .forward)
				  },
				  rightButtonImageName: nil,
				  rightButtonTitle: nil),
		ContentVC(with: "secondScreen",
				  text: secondScreenText,
				  leftAction: { [weak self] in
					self?.view?.showScreen(with: .reverse)
				  }
				  ,
				  rightAction: { [weak self] in
					self?.view?.showScreen(with: .forward)
				  },
				  rightButtonImageName: nil,
				  rightButtonTitle: nil),
		ContentVC(with: "thirdScreen",
				  text: thirdScreenText,
				  leftAction: { [weak self] in
					self?.view?.showScreen(with: .reverse)
				  }
				  ,
				  rightAction: { [weak self] in
					self?.view?.showScreen(with: .forward)
				  },
				  rightButtonImageName: nil,
				  rightButtonTitle: nil),
		ContentVC(with: "fourthScreen",
				  text: fourthScreenText,
				  leftAction: { [weak self] in
					self?.view?.showScreen(with: .reverse)
				  }
				  ,
				  rightAction: { [weak self] in
					self?.view?.showScreen(with: .forward)
				  },
				  rightButtonImageName: nil,
				  rightButtonTitle: nil),
		ContentVC(with: "fifthScreen",
				  text: fifthScreenText,
				  leftAction: { [weak self] in
					self?.view?.showScreen(with: .reverse)
				  }
				  ,
				  rightAction: { [weak self] in
					self?.view?.navigateToMainVC()
				  },
				  rightButtonImageName: "startButton",
				  rightButtonTitle: "Начать")
	]
}

//MARK: - PromoPresenterProtocol
extension PromoPresenter: PromoPresenterProtocol {
	func loadData() {
		view?.update(with: screens)
	}
}

//MARK: - Статические данные
extension PromoPresenter {
	private var firstScreenText: String {
		"""
		ОСНОВНОЙ ЭКРАН С КАТЕГОРИЯМИ СОБЫТИЙ

		На свое усмотрение пользователь выбирает
		интересующую его категорию для планирования своего будущего досуга
		"""
	}

	private var secondScreenText: String {
		"""
		СПИСОК СОБЫТИЙ ПО ВЫБРАННОЙ КАТЕГОРИИ

		Представлен полный спектр событий в соответствие с
		выбранной катерией
		"""
	}

	private var thirdScreenText: String {
		"""
		ДЕТАЛЬНАЯ ИНФОРМАЦИЯ О СОБЫТИИ

		Здесь можно будет более подробно ознакомиться с интересующим событием, прочитав обширное описание со всеми деталями и ньюансами
		"""
	}

	private var fourthScreenText: String {
		"""
		ИЗБРАННЫЕ СОБЫТИЯ

		Содержится информация по событиям, которые были отмечены Вами как наиболее понравившиеся
		"""
	}

	private var fifthScreenText: String {
		"""
		ПОИСК СОБЫТИЙ

		Также не составит труда и отыскать событие по ключевым словам в поисковой строке
		"""
	}
}
