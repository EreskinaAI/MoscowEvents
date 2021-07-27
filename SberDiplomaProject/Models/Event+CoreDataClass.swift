//
//  Event+CoreDataClass.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 18.07.2021.
//
//

import CoreData

/// Модель события для сохранения в КорДату
@objc(Event)
public class Event: NSManagedObject { }

extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

	/// Идентификатор
	@NSManaged public var eventId: Int
	/// Полное описание
	@NSManaged public var bodyText: NSAttributedString
	/// Дата проведения
	@NSManaged public var date: String
	/// Краткое описание события
	@NSManaged public var describing: NSAttributedString
	/// Картинка
	@NSManaged public var image: Data?
	/// Адрес картинки
	@NSManaged public var imageURL: String?
	/// Место проведения
	@NSManaged public var place: String
	/// Цена
	@NSManaged public var price: String
	/// Заголовок
    @NSManaged public var title: String

}
