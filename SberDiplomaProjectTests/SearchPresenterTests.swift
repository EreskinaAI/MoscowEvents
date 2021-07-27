//
//  SearchPresenterTests.swift
//  SberDiplomaProjectTests
//
//  Created by Анна Ереськина on 24.07.2021.
//

import XCTest
@testable import SberDiplomaProject

class SearchPresenterTests: XCTestCase {

	func testThatLoadsDataWithText() {
		//arrange
		let viewMock = EventListViewMock()
		let networkServiceMock = NetworkServiceMock()
		let localStoredServiceMock = LocalStoredServiceMock()
		let searchPresenter = SearchPresenter(networkService: networkServiceMock,
											  localStoredService: localStoredServiceMock)
		searchPresenter.view = viewMock

		//act
		searchPresenter.loadData(with: "moscow")

		//assert
		XCTAssertTrue(networkServiceMock.eventsForSearchTextHaveLoaded)
		XCTAssertEqual(networkServiceMock.searchText, "moscow")
	}
}
