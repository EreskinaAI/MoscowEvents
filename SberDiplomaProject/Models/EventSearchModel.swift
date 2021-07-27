//
//  EventSearchModel.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 17.07.2021.
//

/// Модель события для поиска для загрузки из сети
struct EventSearchModel: Codable {
	/// Идентификатор
	let id: Int
	/// Заголовок
	let title: String
	/// Описание
	let description: String
	/// Адрес
	let place: Place?
	/// Дата
	let daterange: Daterange
	/// Картинка
	let firstImage: FirstImage

	enum CodingKeys: String, CodingKey {
		case id
		case title
		case description
		case place
		case daterange
		case firstImage = "first_image"
	}
}

/// Модель даты для загрузки из сети
struct Daterange: Codable {
	/// Дата начала
	let start: Int
	/// Дата окочания
	let end: Int
}

/// Модель картинки для загрузки из сети
struct FirstImage: Codable {
	/// Адрес картинки
	let image: String
}
