//
//  DetailsViewProtocol.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 23.07.2021.
//

/// Протокол Вью для экрана с детальной информацией о событии
protocol DetailsViewProtocol: AnyObject {
	/// Обновить вью
	/// - Parameter model: модель данных о событии
	func update(with model: EventViewModel)
}
