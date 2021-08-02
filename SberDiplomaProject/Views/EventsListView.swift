//
//  EventsListView.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 10.07.2021.
//

import UIKit

// Делегат EventsListView
protocol EventsListViewDelegate {

	/// Нажали по ячейке
	/// - Parameter event: выбранное событие
	func didSelect(_ event: EventViewModel)

	/// Нажали на добавление/удаление в избранное
	/// - Parameter index: индекс ячейки
	func favouriteTapped(_ index: Int)

	/// Загрузить данные для следующей страницы
	func loadNextPage()
}

extension EventsListViewDelegate {
	/// Дефолтная реализация (метод опционален)
	func loadNextPage() { }
}

/// Вью для отображения списка событий
final class EventsListView: UIView {

	/// Делегат
	var delegate: EventsListViewDelegate?

	/// Массив событий
	var events: [EventViewModel] = [] {
		didSet {
			eventsTableView.reloadData()
			isLoading = false
			emptyImageView.isHidden = !events.isEmpty
		}
	}

	/// Нужно ли использовать пагинацию
	var isPagination: Bool = false

	/// Состояние загрузки страницы
	var isLoading = false {
		didSet {
			if isLoading {
				activityIndicatorView.startAnimating()
			} else {
				activityIndicatorView.stopAnimating()
			}
		}
	}

	/// Таблица
	lazy var eventsTableView : UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.separatorStyle = .none
		tableView.keyboardDismissMode = .onDrag
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseID)
		return tableView
	}()

	/// Картинка, когда  "пусто"
	private let emptyImageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(named: "noEvents"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.setImageColor(color: .lightGray)

		return imageView
	}()

	/// Индикатор загрузки
	private let activityIndicatorView: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(style: .large)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.hidesWhenStopped = true
		view.color = #colorLiteral(red: 0.02914242074, green: 0.4192609787, blue: 0.03124724142, alpha: 1)
		return view
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
		makeConstraints()
	}

	convenience init(isPagination: Bool) {
		self.init(frame: .zero)
		self.isPagination = isPagination
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/// Обновить ячейку
	/// - Parameter index: индекс ячейки
	func reloadCell(with index: Int) {
		eventsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
	}

	/// Обновить вью
	func update() {
		eventsTableView.reloadData()
	}
}

//MARK: - User methods
extension EventsListView {
	private func setupViews() {
		addSubview(eventsTableView)
		addSubview(emptyImageView)
		addSubview(activityIndicatorView)
	}

	private func makeConstraints() {
		NSLayoutConstraint.activate([
			eventsTableView.topAnchor.constraint(equalTo: topAnchor),
			eventsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
			eventsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
			eventsTableView.bottomAnchor.constraint(equalTo: bottomAnchor),

			emptyImageView.heightAnchor.constraint(equalToConstant: 240),
			emptyImageView.widthAnchor.constraint(equalToConstant: 240),
			emptyImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			emptyImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -22),

			activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
			activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
}

//MARK: - UITableViewDelegate
extension EventsListView: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.didSelect(events[indexPath.row])
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard isPagination else { return }
		if indexPath.row == events.count - 1, !isLoading {
			isLoading = true
			delegate?.loadNextPage()
		}
	}
}

//MARK: - UITableViewDataSource
extension EventsListView: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return events.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reuseID, for: indexPath) as? EventCell

		cell?.configure(with: events[indexPath.row])
		cell?.favouriteButtonHandler = { model in
			if let index = self.events.firstIndex(where: { $0 === model }) {
				self.delegate?.favouriteTapped(index)
			}
		}

		return cell ?? UITableViewCell()
	}
}
