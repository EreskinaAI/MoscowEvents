//
//  CategoriesPresenter.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 18.07.2021.
//

/// Протокол Презентера экрана со списком категорий
protocol CategoriesPresenterProtocol {
	/// Загрузить данные
	func loadData()
}

/// Презентер списка категорий
final class CategoriesPresenter {

	/// Вью для отображения
	weak var view: CategoriesViewProtocol?

	/// Список категорий
	private var categories: [CategotyModel] = [
		CategotyModel(id: "1", name: "Концерты", slug: "concert"),
		CategotyModel(id: "3", name: "Обучение", slug: "education"),
		CategotyModel(id: "2", name: "Спектакли", slug: "theater"),
		CategotyModel(id: "6", name: "Выставки", slug: "exhibition"),
		CategotyModel(id: "7", name: "Экскурсии", slug: "tour"),
		CategotyModel(id: "9", name: "Киноафиша", slug: "cinema"),
		CategotyModel(id: "36", name: "С детьми", slug: "kids"),
		CategotyModel(id: "28", name: "Квесты", slug: "quest")
	]
}

//MARK: - CategoriesPresenterProtocol
extension CategoriesPresenter: CategoriesPresenterProtocol {
	func loadData() {
		view?.update(with: categories)
	}
}
