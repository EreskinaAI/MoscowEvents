//
//  EventListPresenter.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 18.07.2021.
//

/// Протокол Презентера экрана со списком событий
protocol EventsPresenterProtocol: AnyObject {
	/// Загрузить данные
	func loadData()

	/// Нажатие на добавление/удаление в избранное
	/// - Parameter index: индекс модели
	func favouriteTapped(_ index: Int)

	/// Загрузить данные для следующей страницы
	func loadNextPage()
}

extension EventsPresenterProtocol {
	/// Дефолтная реализация (метод опционален)
	func loadNextPage() { }
}

final class EventListPresenter {

	/// Вью для отображения
	weak var view: EventListViewProtocol?

	/// Массив моделей событий для отображения
	private var events: [EventViewModel] = []

	private let networkService: NetworkServiceProtocol
	private let localStoredService: LocalStoredServiceProtocol

	private let category: String
	private var nextPage: String?

	/// Инициализатор
	/// - Parameters:
	///   - networkService: Сервис по работе с сетью
	///   - localStoredService: Сервис локального хранилища
	///   - category: Категория событий
	init(networkService: NetworkServiceProtocol,
		 localStoredService: LocalStoredServiceProtocol,
		 category: String) {
		self.networkService = networkService
		self.localStoredService = localStoredService
		self.category = category
	}
}

//MARK: - EventsPresenterProtocol
extension EventListPresenter: EventsPresenterProtocol {
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

	func loadData() {
		guard events.isEmpty else {
			view?.stopLoadAnimating()
			return
		}
		networkService.loadEvents(for: category, with: 1) { response in
			switch response {
			case .success(let events):
				self.nextPage = events.next
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
				print(error.localizedDescription)
			}
		}
	}

	func loadNextPage() {
		networkService.loadEvents(for: nextPage) { response in
			switch response {
			case .success(let events):
				self.nextPage = events.next

				let localEvents = self.localStoredService.getAllEvents()
				let nextEvents = events.results.compactMap({ EventViewModel(with: $0) })

				nextEvents.forEach { event in
					if let localEvent = localEvents.first(where: { $0.eventId == event.eventId }) {
						event.managedObjectID = localEvent.managedObjectID
						event.isFavourite = true
					}
				}

				self.events += nextEvents
				self.view?.showEvents(with: self.events)
			case .failure(let error):
				self.view?.stopLoadAnimating()
				print(error.localizedDescription)
			}
		}
	}
}

