//
//  SearchVC.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 09.07.2021.
//

import UIKit

/// Контроллер со списком событий из поисковой строки
final class SearchVC : UIViewController {

	// Презентер
	var presenter: SearchPresenterProtocol?

	/// Ввод строки поиска
	private let searchTF: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = "Введите текст поиска"
		textField.textAlignment = .center
		textField.layer.borderWidth = 2
		textField.layer.borderColor = #colorLiteral(red: 0.4717761278, green: 0.2234528661, blue: 0, alpha: 1)
		textField.layer.cornerRadius = 8
		textField.clipsToBounds = true
		textField.backgroundColor = #colorLiteral(red: 0.9761093259, green: 0.952090919, blue: 0.7397835851, alpha: 1)
		return textField
	}()

	/// Кнопка "Начать поиск"
	private lazy var searchButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named: "searchButton"), for: .normal)
		button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
		button.accessibilityLabel = "Search Button"
		return button
	}()

	/// Вью для отображения событий
	private lazy var eventsListView: EventsListView = {
		let eventsListView = EventsListView(isPagination: false)
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
	}
}

//MARK: - User methods
extension SearchVC {
	private func setupViews() {
		view.backgroundColor = .white
		navigationItem.title = "Поиск событий"
		view.addSubview(searchTF)
		view.addSubview(searchButton)
		view.addSubview(eventsListView)
	}

	private func makeConstraints() {
		NSLayoutConstraint.activate([

			searchTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
			searchTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			searchTF.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -12),
			searchTF.heightAnchor.constraint(equalToConstant: 32),

			searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
			searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			searchButton.widthAnchor.constraint(equalToConstant: 32),
			searchButton.heightAnchor.constraint(equalToConstant: 32),

			eventsListView.topAnchor.constraint(equalTo: searchTF.bottomAnchor, constant: 12),
			eventsListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			eventsListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			eventsListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
		])
	}

	@objc private func searchButtonTapped() {
		eventsListView.isLoading = true
		presenter?.loadData(with: searchTF.text ?? "")
	}
}

//MARK: - EventListViewProtocol
extension SearchVC: EventListViewProtocol {
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
extension SearchVC: EventsListViewDelegate {
	func favouriteTapped(_ index: Int) {
		presenter?.favouriteTapped(index)
	}

	func didSelect(_ event: EventViewModel) {
		let eventDetailsVC = Assembly.makeDetailsVC(with: event)
		navigationController?.pushViewController(eventDetailsVC, animated: true)
	}
}
