//
//  EventListPresenterTests.swift
//  SberDiplomaProjectTests
//
//  Created by Анна Ереськина on 24.07.2021.
//

import XCTest
@testable import SberDiplomaProject

final class EventListPresenterTests: XCTestCase {

	func testWhenLoadsDataViewUpdates() {
		//arrange
		let networkServiceMock = NetworkServiceMock()
		let localStoredServiceMock = LocalStoredServiceMock()
		let viewMock = EventListViewMock()
		let eventListPresenter = EventListPresenter(networkService: networkServiceMock,
												localStoredService: localStoredServiceMock, category: "events")
		eventListPresenter.view = viewMock

		//act
		eventListPresenter.loadData()

		//assert
		XCTAssertTrue(networkServiceMock.eventsForCategoryHaveLoaded)
		XCTAssertTrue(viewMock.eventsWereShown)
	}

	func testWhenLoadsDataForNextPageViewUpdates() {
		//arrange
		let networkServiceMock = NetworkServiceMock()
		let localStoredServiceMock = LocalStoredServiceMock()
		let promoPresenter = EventListPresenter(networkService: networkServiceMock,
												localStoredService: localStoredServiceMock, category: "events")

		//act
		promoPresenter.loadNextPage()

		//assert
		XCTAssertTrue(networkServiceMock.eventsForNextPageHaveLoaded)
	}
}

final class EventListViewMock: EventListViewProtocol {

	var presenter: EventsPresenterProtocol?

	var animationWasStopped = false
	var eventsWereShown = false
	var updatedCellIndex = -1

	func showEvents(with models: [EventViewModel]) {
		eventsWereShown = true
	}

	func updateCell(with index: Int) {
		updatedCellIndex = index
	}

	func stopLoadAnimating() {
		animationWasStopped = true
	}

	func favouriteTapped(_ index: Int) {
		presenter?.favouriteTapped(index)
	}
}

final class NetworkServiceMock: NetworkServiceProtocol {

	var eventsForCategoryHaveLoaded = false
	var eventsForNextPageHaveLoaded = false
	var eventsForSearchTextHaveLoaded = false
	var searchText = ""

	let model = EventsModel<EventModel>(count: 1,
							next: nil,
							previous: nil,
							results: [])

	func loadEvents(for category: String, with pageNumber: Int, completion: @escaping (NetworkResponse<EventModel>) -> Void) {
		eventsForCategoryHaveLoaded = true
		completion(.success(model))
	}

	func loadEvents(for pageURL: String?, completion: @escaping (NetworkResponse<EventModel>) -> Void) {
		eventsForNextPageHaveLoaded = true
	}

	func loadEvents(with searchText: String, completion: @escaping (NetworkResponse<EventSearchModel>) -> Void) {
		eventsForSearchTextHaveLoaded = true
		self.searchText = searchText
	}
}

final class LocalStoredServiceMock: LocalStoredServiceProtocol {
	var eventWasSaved = false

	func saveEvent(for model: EventViewModel, completion: ((Bool) -> Void)?) {
		eventWasSaved = true
	}

	func deleteEvent(for model: EventViewModel) -> Bool {
		return true
	}

	func getAllEvents() -> [EventViewModel] {
		return []
	}
}
