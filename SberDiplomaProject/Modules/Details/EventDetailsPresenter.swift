//
//  EventDetailsPresenter.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 18.07.2021.
//

/// Протокол Презентера экрана с детальной информацией о событии
protocol EventDetailsPresenterProtocol {
	/// Загрузить данные
	func loadData()

	/// Нажатие на кнопку "Избранное"
	func favouriteTapped()
}

/// Презентер экрана с детальной информацией о событии
final class EventDetailsPresenter {
	
	/// Вью для отображения
	weak var view: DetailsViewProtocol?

	/// Модель данных для отображения
	private let viewModel: EventViewModel

	private let localStoredService: LocalStoredServiceProtocol
	private let networkService: NetworkServiceProtocol

	/// Инициализатор
	/// - Parameters:
	///   - model: Модель события
	///   - localStoredService: Сервис локального хранилища
	///   - networkService: Сервис по работе с сетью
	init(model: EventViewModel,
		 localStoredService: LocalStoredServiceProtocol,
		 networkService: NetworkServiceProtocol) {
		self.viewModel = model
		self.localStoredService = localStoredService
		self.networkService = networkService
	}
}

//MARK: - EventDetailsPresenterProtocol
extension EventDetailsPresenter: EventDetailsPresenterProtocol {
	func loadData() {
		view?.update(with: viewModel)
	}

	func favouriteTapped() {
		viewModel.isFavourite.toggle()
		view?.update(with: viewModel)

		if  viewModel.isFavourite {
			localStoredService.saveEvent(for: viewModel) { saved in
				if saved {
					self.viewModel.isFavourite = saved
					self.view?.update(with: self.viewModel)
				}
			}
		} else {
			let deleted = localStoredService.deleteEvent(for: viewModel)
			if deleted {
				self.viewModel.isFavourite = false
				self.view?.update(with: viewModel)
			}
		}
	}
}
