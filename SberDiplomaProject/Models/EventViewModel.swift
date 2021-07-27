//
//  EventViewModel.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 09.07.2021.
//

import CoreData

/// Модель События для отображения (DTO)
final class EventViewModel {

	/// Идентификатор
	let eventId: Int
	/// Адрес картинки
	let imageURL: String?
	/// Краткое описание
	let description: NSAttributedString
	/// Полное описание
	let bodyText: NSAttributedString

	/// признак в избранном или нет
	var isFavourite: Bool
	/// Загруженная картинка
	var image: Data?

	/// Заголовок
	var title: String {
		return makeTitle()
	}

	/// Дата
	var date: String {
		if dateLocal.isEmpty {
			return makeDate()
		} else {
			return dateLocal
		}
	}
	/// Адрес
	var place: String {
		if placeLocal.isEmpty {
			return makePlace()
		} else {
			return placeLocal
		}
	}

	/// Текст цены
	var priceText: String {
		price.isEmpty ? "free" : price
	}

	/// Идентификатор managed-объекта в хранилище
	var managedObjectID: NSManagedObjectID?

	private let mainTitle: String
	private let shortTitle: String
	private let price: String
	private let address: String?
	private let subway: String?
	private let startDateInt: Int?
	private let endDateInt: Int?
	private var placeLocal: String = ""
	private var dateLocal: String = ""

	/// Инициализатор для категории
	/// - Parameter model: модель События для категории
	init(with model: EventModel) {
		self.eventId = model.id
		self.imageURL = model.images.first?.image

		let date = model.dates.first
		self.startDateInt = date?.start
		self.endDateInt = date?.end
		self.mainTitle = model.title ?? ""
		self.shortTitle = model.shortTitle
		self.address = model.place?.address
		self.subway = model.place?.subway
		self.description = NSAttributedString(html: model.description)
		self.bodyText = NSAttributedString(html: model.bodyText)
		self.price = model.price
		self.isFavourite = false
	}

	/// Инициализатор для Поиска
	/// - Parameter model: модель События для поиска
	init?(with model: EventSearchModel) {
		self.eventId = model.id
		self.imageURL = model.firstImage.image
		let date = model.daterange
		self.startDateInt = date.start
		self.endDateInt = date.end

		self.mainTitle = model.title
		self.address = model.place?.address
		self.subway = model.place?.subway
		self.description = NSAttributedString(html: model.description)
		self.bodyText = NSAttributedString(html: model.description)
		self.shortTitle = ""
		self.price = ""
		self.isFavourite = false
	}

	/// Инициализатор для CoreDataModel
	/// - Parameter model: модель События из КорДаты
	init?(with model: Event) {
		eventId = model.eventId
		managedObjectID = model.objectID
		imageURL = model.imageURL
		image = model.image
		shortTitle = model.title
		dateLocal = model.date
		description = model.describing
		bodyText = model.bodyText
		placeLocal = model.place
		price = model.price
		isFavourite = true

		mainTitle = ""
		address = ""
		subway = ""
		startDateInt = 0
		endDateInt = 0
	}

	/// Подготовить дату в формате строки
	/// - Returns: дата
	private func makeDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.yyyy"

		let dates = [startDateInt, endDateInt]
			.compactMap { $0 }
			.compactMap { Date(timeIntervalSince1970: TimeInterval($0)) }
			.compactMap { dateFormatter.string(from: $0) }
			.joined(separator: " - ")

		return dates
	}

	/// Подготовить адрес
	/// - Returns: адрес
	private func makePlace() -> String {
		let place = [subway, address]
			.compactMap { $0 }
			.joined(separator: ", ")
		return place.isEmpty ? "Место проведения неизвестно" : place
	}

	/// подготовить заголовок
	/// - Returns: заголовок
	private func makeTitle() -> String {
		return shortTitle.isEmpty ? mainTitle : shortTitle
	}
}
