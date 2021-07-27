//
//  CoreDataService.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 18.07.2021.
//

import CoreData

/// Протокол локального хранища
protocol LocalStoredServiceProtocol {

	/// Сохранить событие
	/// - Parameters:
	///   - model: модель данных
	///   - completion: результат сохранения (успешно/не успешно)
	func saveEvent(for model: EventViewModel, completion: ((_ saved: Bool) -> Void)?)

	/// Удалить событие
	/// - Parameter model: модель удаляемого события
	func deleteEvent(for model: EventViewModel) -> Bool

	/// Получить все события
	func getAllEvents() -> [EventViewModel]
}

/// Сервис по работе с CoreData
final class CoreDataService {

	/// Синглтон
	static let shared = CoreDataService()
	private init() {}

	lazy var mainContext: NSManagedObjectContext = {
		return persistentContainer.viewContext
	}()

	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Model")
		container.loadPersistentStores { (storeDescription, error) in
			if let error = error {
				print(error.localizedDescription)
			}
		}
		return container
	}()

	/// Сохраняемое событие
	private var savingEvent: EventViewModel?
}

//MARK: - LocalStoredServiceProtocol
extension CoreDataService: LocalStoredServiceProtocol {
	func saveEvent(for model: EventViewModel, completion: ((_ saved: Bool) -> Void)?) {
		guard savingEvent !== model else { return }
		let context = mainContext
		savingEvent = model

		context.performAndWait {
			let eventObject = Event(context: context)
			eventObject.eventId = model.eventId
			eventObject.title = model.title
			eventObject.date = model.date
			eventObject.describing = model.description
			eventObject.bodyText = model.bodyText
			eventObject.place = model.place
			eventObject.price = model.priceText
			eventObject.image = model.image
			eventObject.imageURL = model.imageURL

			do {
				try context.save()
				model.managedObjectID = eventObject.objectID
				completion?(true)
			} catch let error {
				print(error.localizedDescription)
				completion?(false)
			}

			savingEvent = nil
		}
	}

	func deleteEvent(for model: EventViewModel) -> Bool {
		guard let managedObjectID = model.managedObjectID else { return false }
		let context = mainContext

		let managedObject = context.object(with: managedObjectID)
		context.delete(managedObject)

		do {
			try context.save()
			return true
		} catch let error {
			print(error.localizedDescription)
			return false
		}
	}

	func getAllEvents() -> [EventViewModel] {
		let context = mainContext
		let fetchRequest = NSFetchRequest<Event>()

		let entityDescription = NSEntityDescription.entity(forEntityName: "Event", in: context)

		fetchRequest.entity = entityDescription

		do {
			let events = try context.fetch(fetchRequest)
			return events.compactMap { EventViewModel(with: $0) }

		} catch {
			let fetchError = error as NSError
			print(fetchError)
			return []
		}
	}
}
