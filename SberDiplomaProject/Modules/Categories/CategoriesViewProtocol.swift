//
//  CategoriesViewProtocol.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 23.07.2021.
//

/// Протокол Вью для Списка категорий
protocol CategoriesViewProtocol: AnyObject {
	/// Обновить содержимое
	/// - Parameter models: список моделей категорий
	func update(with models: [CategotyModel])
}
