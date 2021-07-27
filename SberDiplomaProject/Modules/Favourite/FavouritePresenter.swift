//
//  FavouritePresenter.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 18.07.2021.
//

final class FavouritePresenter {

	/// Вью для отображения
	weak var view: EventListViewProtocol?

	private let localStoredService: LocalStoredServiceProtocol
	private var events: [EventViewModel] = []

	/// Инициализатор
	/// - Parameter localStoredService: сервис локального хранилища
	init(localStoredService: LocalStoredServiceProtocol) {
		self.localStoredService = localStoredService
	}
}

//MARK: - EventsPresenterProtocol
extension FavouritePresenter: EventsPresenterProtocol {
	func favouriteTapped(_ index: Int) {
		let event = events[index]

		if events[index].isFavourite {
			let deleted = localStoredService.deleteEvent(for: event)
			if deleted {
				event.isFavourite = false
				self.loadData()
			}
		}
	}

	func loadData() {
		events = localStoredService.getAllEvents()
		view?.showEvents(with: events)
	}
}
