//
//  EventListViewTests.swift
//  SberDiplomaProjectTests
//
//  Created by Анна Ереськина on 24.07.2021.
//

import XCTest
@testable import SberDiplomaProject

final class EventListViewTests: XCTestCase {

	func testWhenViewAppearsPresenterLoadsData() {
		//arrange
		let presenterMock = EventListPresenterMock()
		let eventListVC = EventsListVC()
		eventListVC.presenter = presenterMock

		//act
		eventListVC.viewWillAppear(true)

		//assert
		XCTAssertTrue(presenterMock.hasLoaded)
	}

	func testWhenViewCallFavoutiteMethodPresenterCallsMethod() {
		//arrange
		let presenterMock = EventListPresenterMock()
		let eventListVC = EventsListVC()
		eventListVC.presenter = presenterMock

		//act
		eventListVC.favouriteTapped(3)

		//assert
		XCTAssertTrue(presenterMock.favouriteWasTapped)
		XCTAssertEqual(presenterMock.favouriteIndex, 3)
	}

	func testThatPresenterCallsNextPageLoadedMethod() {
		//arrange
		let presenterMock = EventListPresenterMock()
		let eventListVC = EventsListVC()
		eventListVC.presenter = presenterMock
		presenterMock.view = eventListVC

		//act
		eventListVC.loadNextPage()

		//assert
		XCTAssertTrue(presenterMock.nextPageHasLoaded)
	}
	
}

final class EventListPresenterMock: EventsPresenterProtocol {

	var view: EventListViewProtocol?

	var hasLoaded = false
	var favouriteWasTapped = false
	var nextPageHasLoaded = false
	var favouriteIndex = -1

	func loadData() {
		hasLoaded = true
		view?.showEvents(with: [])
	}

	func favouriteTapped(_ index: Int) {
		favouriteWasTapped = true
		favouriteIndex = index
	}

	func loadNextPage() {
		nextPageHasLoaded = true
	}
}
