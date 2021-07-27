//
//  EventListViewProtocol.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 23.07.2021.
//

/// Протокол Вью для Списка событий
protocol EventListViewProtocol: AnyObject {

	/// Отобразить события
	/// - Parameter models: модели событий
	func showEvents(with models: [EventViewModel])

	/// Обновить ячейку
	/// - Parameter index: индекс ячейки
	func updateCell(with index: Int)

	/// Остановить анимацию загрузки
	func stopLoadAnimating()
}
