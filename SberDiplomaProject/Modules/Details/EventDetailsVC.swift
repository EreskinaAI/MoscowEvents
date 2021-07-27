//
//  EventDetailsVC.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 10.07.2021.
//

import UIKit

/// Контроллер с детальной информацией о событии
final class EventDetailsVC: UIViewController {

	/// Презентер
	var presenter: EventDetailsPresenterProtocol?

	private let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false

		return scrollView
	}()

	/// Вью содержащая все UI элементы
	private let contentView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	/// Картинка
	private let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 12
		imageView.clipsToBounds = true
		imageView.backgroundColor = .purple
		return  imageView
	}()

	/// Иконка для даты события
	private let calendarIcon: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 12
		imageView.clipsToBounds = true
		imageView.image = UIImage(named: "calendarIcon")
		return  imageView
	}()

	/// Иконка для адреса события
	private let locationIcon: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 12
		imageView.clipsToBounds = true
		imageView.image = UIImage(named: "locationIcon")
		return  imageView
	}()

	/// Дата события
	private let dateLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = #colorLiteral(red: 0.6326112747, green: 0.101905562, blue: 0, alpha: 1)
		label.textAlignment = .left
		label.font = UIFont(name: "ChalkboardSE-Bold", size: 16)
		return label
	}()

	/// Заголовок события
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = #colorLiteral(red: 0.02914242074, green: 0.4192609787, blue: 0.03124724142, alpha: 1)
		label.textAlignment = .center
		label.font = UIFont(name: "ChalkboardSE-Bold", size: 22)
		label.numberOfLines = 2
		return label
	}()

	/// Адрес события
	private let placeLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .left
		label.font = UIFont(name: "ChalkboardSE-Bold", size: 16)
		label.numberOfLines = 2
		return label
	}()

	/// Описание события
	private let descriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .black
		label.textAlignment = .left
		label.font = UIFont(name: "Chalkboard SE", size: 16)
		label.numberOfLines = 0
		return label
	}()

	/// Цена события
	private let priceLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = #colorLiteral(red: 0.6326112747, green: 0.101905562, blue: 0, alpha: 1)
		label.textAlignment = .left
		label.font = UIFont(name: "ChalkboardSE-Bold", size: 16)
		return label
	}()

	/// Кнопка добавления/удаления в избранное
	private lazy var favouriteButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named: "heart"), for: .normal)
		button.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		makeConstraints()

		presenter?.loadData()
	}
}

//MARK: - User methods
extension EventDetailsVC {

	private func setupViews() {
		view.backgroundColor = #colorLiteral(red: 0.9761093259, green: 0.952090919, blue: 0.7397835851, alpha: 1)

		view.addSubview(scrollView)
		scrollView.addSubview(contentView)

		contentView.addSubview(imageView)
		contentView.addSubview(calendarIcon)
		contentView.addSubview(locationIcon)
		contentView.addSubview(dateLabel)
		contentView.addSubview(titleLabel)
		contentView.addSubview(placeLabel)
		contentView.addSubview(descriptionLabel)
		contentView.addSubview(priceLabel)
		contentView.addSubview(favouriteButton)
	}

	private func makeConstraints() {
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			imageView.heightAnchor.constraint(equalToConstant: 360),

			calendarIcon.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
			calendarIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			calendarIcon.widthAnchor.constraint(equalToConstant: 24),
			calendarIcon.heightAnchor.constraint(equalToConstant: 24),

			favouriteButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
			favouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			favouriteButton.widthAnchor.constraint(equalToConstant: 24),
			favouriteButton.heightAnchor.constraint(equalToConstant: 24),

			dateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
			dateLabel.leadingAnchor.constraint(equalTo: calendarIcon.trailingAnchor, constant: 8),
			dateLabel.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -8),
			dateLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),

			locationIcon.topAnchor.constraint(equalTo: calendarIcon.bottomAnchor, constant: 12),
			locationIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			locationIcon.widthAnchor.constraint(equalToConstant: 24),
			locationIcon.heightAnchor.constraint(equalToConstant: 24),

			placeLabel.topAnchor.constraint(equalTo: calendarIcon.bottomAnchor, constant: 12),
			placeLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 8),
			placeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			placeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),

			titleLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: 12),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

			descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
			descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

			priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
			priceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)

		])
	}

	private func configure(with model: EventViewModel?) {
		if let image = model?.image {
			imageView.image = UIImage(data: image)
		} else {
			imageView.loadImage(with: model?.imageURL)
		}
		dateLabel.text = model?.date
		titleLabel.text = model?.title
		placeLabel.text = model?.place
		descriptionLabel.attributedText = makeDescription(from: model?.bodyText)
		priceLabel.text = model?.priceText
		favouriteButton.setImage(UIImage(named: (model?.isFavourite ?? false) ? "filledHeart" : "heart"), for: .normal)
	}

	@objc private func favouriteButtonTapped() {
		presenter?.favouriteTapped()
	}

	private func makeDescription(from text: NSAttributedString?) -> NSAttributedString? {
		guard let text = text else { return nil }
		let description = NSMutableAttributedString(attributedString: text)
		if let font = UIFont(name: "Chalkboard SE", size: 16) {
			let fontAttribute = [ NSAttributedString.Key.font: font ]
			description.addAttributes(fontAttribute, range: NSRange(location: 0, length: description.string.count))
			return description
		}
		return text
	}
}

//MARK: - DetailsViewProtocol
extension EventDetailsVC: DetailsViewProtocol {
	func update(with model: EventViewModel) {
		configure(with: model)
	}
}
