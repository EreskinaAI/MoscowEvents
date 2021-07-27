//
//  EventCell.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 09.07.2021.
//

import UIKit

/// Ячейка отображения события
final class EventCell: UITableViewCell {

	/// Идентификатор переиспользования ячейки
	static var reuseID: String { String(describing: EventCell.self) }

	/// Нажатие на "Избранное"
	var favouriteButtonHandler: ((_ model: EventViewModel) -> Void)?
	/// Загрузка картинки
	var loadImage: ((_ imageView: UIImageView) -> Void)?

	/// Модель отображаемых данных
	private var viewModel: EventViewModel?

	/// Подложка
	private let backView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .lightGray
		view.layer.cornerRadius = 12
		view.clipsToBounds = true
		view.backgroundColor = #colorLiteral(red: 0.9761093259, green: 0.952090919, blue: 0.7397835851, alpha: 1)

		return view
	}()

	/// Картинка события
	private let eventImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 12
		imageView.clipsToBounds = true
		return imageView
	}()

	/// Дата
	private let dateLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = #colorLiteral(red: 0.6326112747, green: 0.101905562, blue: 0, alpha: 1)
		label.textAlignment = .left
		label.font = UIFont(name: "ChalkboardSE-Bold", size: 12)
		return label
	}()

	/// Заголовок
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .left
		label.font = UIFont(name: "ChalkboardSE-Bold", size: 14)
		label.textColor = #colorLiteral(red: 0.02914242074, green: 0.4192609787, blue: 0.03124724142, alpha: 1)
		label.numberOfLines = 2
		return label
	}()

	/// Адрес
	private let placeLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .left
		label.font = UIFont(name: "ChalkboardSE-Bold", size: 12)
		label.numberOfLines = 2
		return label
	}()

	/// Описание события
	private let descriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .red
		label.textAlignment = .left
		label.font = UIFont(name: "Chalkboard SE", size: 14)
		label.numberOfLines = 2
		return label
	}()

	/// Цена
	private let priceLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 2
		label.textColor = #colorLiteral(red: 0.6326112747, green: 0.101905562, blue: 0, alpha: 1)
		label.textAlignment = .left
		label.font = UIFont(name: "ChalkboardSE-Bold", size: 12)
		return label
	}()

	/// Кнопка "Избранное"
	private lazy var favouriteButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named: "heart"), for: .normal)
		button.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)

		return button
	}()


	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
		makeConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/// Обновить ячейку из модели
	/// - Parameter model: модель данных
	func configure(with model: EventViewModel) {
		viewModel = model

		if let image = model.image {
			eventImageView.image = UIImage(data: image)
		} else {
			eventImageView.loadImage(with: model.imageURL)
		}

		dateLabel.text = model.date
		titleLabel.text = model.title
		placeLabel.text = model.place
		descriptionLabel.attributedText = makeDescription(from: model.description)
		priceLabel.text = model.priceText
		favouriteButton.setImage(UIImage(named: model.isFavourite ? "filledHeart" : "heart"), for: .normal)
	}
}

//MARK: - User methods
extension EventCell {

	private func setupViews() {
		selectionStyle = .none

		contentView.addSubview(backView)
		backView.addSubview(eventImageView)
		backView.addSubview(dateLabel)
		backView.addSubview(titleLabel)
		backView.addSubview(placeLabel)
		backView.addSubview(descriptionLabel)
		backView.addSubview(priceLabel)
		backView.addSubview(favouriteButton)
	}

	private func makeConstraints() {
		NSLayoutConstraint.activate([
			backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

			eventImageView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
			eventImageView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
			eventImageView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -16),
			eventImageView.widthAnchor.constraint(equalToConstant: 100),
			eventImageView.heightAnchor.constraint(equalToConstant: 150),

			favouriteButton.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
			favouriteButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
			favouriteButton.widthAnchor.constraint(equalToConstant: 24),
			favouriteButton.heightAnchor.constraint(equalToConstant: 24),

			dateLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
			dateLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 8),
			dateLabel.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -8),
			dateLabel.heightAnchor.constraint(equalToConstant: 16),

			titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
			titleLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 8),
			titleLabel.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -8),
			titleLabel.heightAnchor.constraint(equalToConstant: 16),

			descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
			descriptionLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 8),
			descriptionLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),

			placeLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
			placeLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 8),
			placeLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),

			priceLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -16),
			priceLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
			priceLabel.topAnchor.constraint(greaterThanOrEqualTo: placeLabel.bottomAnchor, constant: 8)
		])
	}

	private func makeDescription(from text: NSAttributedString?) -> NSAttributedString? {
		guard let text = text else { return nil }
		let description = NSMutableAttributedString(attributedString: text)
		if let font = UIFont(name: "Chalkboard SE", size: 12) {
			let fontAttribute = [ NSAttributedString.Key.font: font ]
			description.addAttributes(fontAttribute, range: NSRange(location: 0, length: description.string.count))
			return description
		}
		return text
	}

	@objc private func favouriteButtonTapped() {
		guard let model = viewModel else { return }
		favouriteButtonHandler?(model)
	}
}
