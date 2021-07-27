//
//  SberDiplomaProjectUITests.swift
//  SberDiplomaProjectUITests
//
//  Created by Анна Ереськина on 26.07.2021.
//

import XCTest

protocol Page {
	var app: XCUIApplication { get }

	init(app: XCUIApplication)
}

class TabBarPage: Page {
	var app: XCUIApplication
	
	var eventsButton: XCUIElement { return app.tabBars.buttons["События"] }
	var favouriteButton: XCUIElement { return app.tabBars.buttons["Избранное"] }
	var searchButton: XCUIElement { return app.tabBars.buttons["Поиск"] }

	required init(app: XCUIApplication) {
		self.app = app
	}

	func tapEventsButton() -> EventsPage {
		eventsButton.tap()
		return EventsPage(app: app)
	}

	func tapFavouriteButton() -> FavouritePage {
		favouriteButton.tap()
		return FavouritePage(app: app)
	}

	func tapSearchButton() -> SearchPage {
		searchButton.tap()
		return SearchPage(app: app)
	}
}

class EventsPage: Page {
	var app: XCUIApplication

	var eventsButton: XCUIElement { return app.tabBars.buttons["События"] }
	var favouriteButton: XCUIElement { return app.tabBars.buttons["Избранное"] }
	var searchButton: XCUIElement { return app.tabBars.buttons["Поиск"] }

	required init(app: XCUIApplication) {
		self.app = app
	}
}

class FavouritePage: Page {
	var app: XCUIApplication

	var eventsButton: XCUIElement { return app.tabBars.buttons["События"] }
	var favouriteButton: XCUIElement { return app.tabBars.buttons["Избранное"] }
	var searchButton: XCUIElement { return app.tabBars.buttons["Поиск"] }

	required init(app: XCUIApplication) {
		self.app = app
	}
}

class SearchPage: Page {
	var app: XCUIApplication

	var eventsButton: XCUIElement { return app.tabBars.buttons["События"] }
	var favouriteButton: XCUIElement { return app.tabBars.buttons["Избранное"] }
	var searchButton: XCUIElement { return app.tabBars.buttons["Поиск"] }

	var eventSearchButton: XCUIElement { return app.buttons["Search Button"] }
	var searchTextField: XCUIElement { return app.textFields.firstMatch }
	var activityIndicator: XCUIElement { return app.activityIndicators.firstMatch }

	required init(app: XCUIApplication) {
		self.app = app
	}

	func tapSearchEventButton() -> Self {
		eventSearchButton.tap()
		return self
	}

	func typeSearchText(_ text: String) -> Self {
		searchTextField.tap()
		searchTextField.typeText(text)
		return self
	}
}

class SberDiplomaProjectUITests: XCTestCase {

	var app: XCUIApplication!

	override func setUpWithError() throws {
		app = XCUIApplication()
		app.launch()
		continueAfterFailure = false
	}

	override func tearDownWithError() throws {
		app = nil
	}

	func testThatSearchTextEntered() throws {
		// Arrange
		let tabBarPage = TabBarPage(app: app)

		// Act
		let searchPage = tabBarPage
			.tapSearchButton()
			.typeSearchText("moscow")

		// Assert
		if let text = searchPage.searchTextField.value as? String {
			XCTAssertTrue(text == "moscow")
		}
	}

	func testThatSearchEventTap() throws {
		// Arrange
		let tabBarPage = TabBarPage(app: app)

		// Act
		let searchPage = tabBarPage
			.tapSearchButton()
			.typeSearchText("moscow")
			.tapSearchEventButton()

		// Assert
		XCTAssertTrue(searchPage.activityIndicator.exists)
	}
}
