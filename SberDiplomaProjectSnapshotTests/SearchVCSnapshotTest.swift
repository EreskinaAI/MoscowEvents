//
//  SearchVCSnapshotTest.swift
//  SberDiplomaProjectSnapshotTests
//
//  Created by Анна Ереськина on 26.07.2021.
//

import SnapshotTesting
import XCTest
@testable import SberDiplomaProject

class SearchVCSnapshotTest: XCTestCase {
	var sut: SearchVC!

	override func setUp() {
		sut = SearchVC()
	}

	func testSearchVCSnapsot() {
		assertSnapshot(matching: sut, as: .image(on: .iPhone8Plus))
	}

}
