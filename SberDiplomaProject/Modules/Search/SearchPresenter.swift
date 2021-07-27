//
//  SearchPresenter.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 18.07.2021.
//

/// Протокол Презентера экрана со списком событий из поисковой строки
protocol SearchPresenterProtocol: AnyObject {

	/// Загрузить события
	/// - Parameter searchText: строка поиска
	func loadData(with searchText: String)

	/// Нажатие на кнопку добавления/удаления в избранное
	/// - Parameter index: индекс модели
	func favouriteTapped(_ index: Int)
}

/// Презентер экрана со списком событий из поисковой строки
final class SearchPresenter {

	/// Вью для отображения
	weak var view: EventListViewProtocol?

	/// Массив моделей для отображения
	private var events: [EventViewModel] = []

	private let networkService: NetworkServiceProtocol
	private let localStoredService: LocalStoredServiceProtocol

	/// Инициализатор
	/// - Parameters:
	///   - networkService: сервис по работе с сетью
	///   - localStoredService: сервис локального хранилища
	init(networkService: NetworkServiceProtocol,
		 localStoredService: LocalStoredServiceProtocol) {
		self.networkService = networkService
		self.localStoredService = localStoredService
	}
}

//MARK: - SearchPresenterProtocol
extension SearchPresenter: SearchPresenterProtocol {
	func favouriteTapped(_ index: Int) {
		guard events.indices.contains(index) else { return }
		let event = events[index]

		if  !events[index].isFavourite {
			localStoredService.saveEvent(for: event) { saved in
				if saved {
					event.isFavourite = saved
					self.view?.updateCell(with: index)
				}
			}
		} else {
			let deleted = localStoredService.deleteEvent(for: event)
			if deleted {
				event.isFavourite = false
				self.view?.updateCell(with: index)
			}
		}
	}

	func loadData(with searchText: String) {
		networkService.loadEvents(with: searchText) { response in
			switch response {
			case .success(let events):
				self.events = events.results.compactMap({ EventViewModel(with: $0) })
				let localEvents = self.localStoredService.getAllEvents()

				self.events.forEach { event in
					if let localEvent = localEvents.first(where: { $0.eventId == event.eventId }) {
						event.managedObjectID = localEvent.managedObjectID
						event.isFavourite = true
					}
				}

				self.view?.showEvents(with: self.events)
			case .failure(let error):
				self.view?.stopLoadAnimating()
				self.events = []
				self.view?.showEvents(with: self.events)
				print(error.localizedDescription)
			}
		}
	}
}

