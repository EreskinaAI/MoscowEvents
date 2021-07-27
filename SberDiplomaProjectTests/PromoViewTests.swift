//
//  PromoViewTests.swift
//  SberDiplomaProjectTests
//
//  Created by Анна Ереськина on 24.07.2021.
//

import XCTest
@testable import SberDiplomaProject

final class PromoViewTests: XCTestCase {

	func testWhenViewAppearsPresenterLoadsData() {
		//arrange
		let presenterMock = PromoPresenterMock()
		let promoVC = PromoVC()
		promoVC.presenter = presenterMock

		//act
		promoVC.viewWillAppear(true)

		//assert
		XCTAssertTrue(presenterMock.hasLoaded)
	}
}

final class PromoPresenterMock: PromoPresenterProtocol {

	var hasLoaded = false

	func loadData() {
		hasLoaded = true
	}
}
