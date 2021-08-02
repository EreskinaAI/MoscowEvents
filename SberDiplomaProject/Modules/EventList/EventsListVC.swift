//
//  EventsListVC.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 09.07.2021.
//

import UIKit

/// Контроллер экрана - список событий
final class EventsListVC: UIViewController {

	//  Презентер
	var presenter: EventsPresenterProtocol?
	/// Использовать ли пагинацию
	var isPagination: Bool = true

	/// Вью для отображения списка событий
	private lazy var eventsListView: EventsListView = {
		let eventsListView = EventsListView(isPagination: isPagination)
		eventsListView.translatesAutoresizingMaskIntoConstraints = false
		eventsListView.delegate = self
		return eventsListView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		makeConstraints()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)
		eventsListView.update()
		eventsListView.isLoading = true
		presenter?.loadData()
	}
}

//MARK: - User methods
extension EventsListVC {
	private func setupViews() {
		view.addSubview(eventsListView)
	}

	private func makeConstraints() {
		NSLayoutConstraint.activate([
			eventsListView.topAnchor.constraint(equalTo: view.topAnchor),
			eventsListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			eventsListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			eventsListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}

//MARK: - EventListViewProtocol
extension EventsListVC: EventListViewProtocol {
	func stopLoadAnimating() {
		DispatchQueue.main.async {
			self.eventsListView.isLoading = false
		}
	}
	
	func updateCell(with index: Int) {
		DispatchQueue.main.async {
			self.eventsListView.reloadCell(with: index)
		}
	}

	func showEvents(with models: [EventViewModel]) {
		DispatchQueue.main.async {
			self.eventsListView.isLoading = false
			self.eventsListView.events = models
		}
	}
}

//MARK: - EventsListViewDelegate
extension EventsListVC: EventsListViewDelegate {
	func favouriteTapped(_ index: Int) {
		presenter?.favouriteTapped(index)
	}

	func didSelect(_ event: EventViewModel) {
		let eventDetailsVC = Assembly.makeDetailsVC(with: event)
		navigationController?.pushViewController(eventDetailsVC, animated: true)
	}

	func loadNextPage() {
		presenter?.loadNextPage()
	}
}
