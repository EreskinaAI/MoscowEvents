//
//  EventModel.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 10.07.2021.
//

/// Модель ответа сервера
struct EventsModel<T: Codable>: Codable {
	/// Общее количество данных
	let count: Int
	/// Следующая страница
	let next: String?
	/// Предыдущая страница
	let previous: String?
	/// Набор данных
	let results: [T]
}

/// Модель события для категории для загрузки из сети
struct EventModel: Codable {
	/// Идентификатор
	let id: Int
	/// Массив дат
	let dates: [Dates]
	/// Адрес
	let place: Place?
	/// Краткое описание
	let description: String
	/// Признак "бесплатно"
	let isFree: Bool
	/// Заголовок
	let title: String?
	/// Краткое название
	let shortTitle: String
	/// Массив картинок
	let images: [Images]
	/// Цена
	let price: String
	/// Полное описание
	let bodyText: String

	enum CodingKeys: String, CodingKey {
		case id
		case dates
		case place
		case description
		case isFree = "is_free"
		case title
		case shortTitle = "short_title"
		case images
		case price
		case bodyText = "body_text"
	}
}

/// Модель для даты для загрузки из сети
struct Dates: Codable {
	/// Дата начала
	let start: Int
	/// Дата окончания
	let end: Int
}

/// Модель места для загрузки из сети
struct Place: Codable {
	/// Адрес
	let address: String
	/// Метро
	let subway: String
}

/// Модель картинки для загрузки из сети
struct Images: Codable {
	/// Адрес картинки
	let image: String
}
