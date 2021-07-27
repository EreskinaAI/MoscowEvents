//
//  PromoPresenterTests.swift
//  SberDiplomaProjectTests
//
//  Created by Анна Ереськина on 24.07.2021.
//

import XCTest
@testable import SberDiplomaProject

final class PromoPresenterTests: XCTestCase {

	func testWhenLoadsDataViewUpdates() {
		//arrange
		let viewMock = PromoViewMock()
		let promoPresenter = PromoPresenter()
		promoPresenter.view = viewMock

		//act
		promoPresenter.loadData()

		//assert
		XCTAssertTrue(viewMock.viewHasUpdated)
	}
}

final class PromoViewMock: PromoViewProtocol {
	var viewHasUpdated = false

	func update(with screens: [ContentVC]) {
		viewHasUpdated = true
	}

	func showScreen(with direction: UIPageViewController.NavigationDirection) { }
	func navigateToMainVC() { }
}
