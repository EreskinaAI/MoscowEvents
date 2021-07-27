//
//  CategotyCell.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 09.07.2021.
//

import UIKit

/// Ячейка для отображения категории
final class CategotyCell: UICollectionViewCell {

	private enum Constants {
		static var imageSize: CGFloat = 64
	}

	/// Идентификатор переиспользования ячейки
	static var reuseID: String { String(describing: CategotyCell.self) }

	/// Модель данных
	private var model: CategotyModel?

	/// Картинка
	private let categoryImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		return imageView

	}()

	/// Название
	private let categoryNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = #colorLiteral(red: 0.4717761278, green: 0.2234528661, blue: 0, alpha: 1)
		label.textAlignment = .center
		label.font = UIFont(name: "ChalkboardSE-Bold", size: 16)
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
		makeConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/// Обновить ячейку в соответствии с моделью данных
	/// - Parameter model: модель данных
	func configure(with model: CategotyModel) {
		categoryImageView.image = UIImage(named: "category\(model.id)")
		categoryNameLabel.text = model.name
		categoryImageView.setImageColor(color: #colorLiteral(red: 0.02914242074, green: 0.4192609787, blue: 0.03124724142, alpha: 1))
	}
}

//MARK: - User methods
extension CategotyCell {
	private func setupViews() {
		contentView.addSubview(categoryImageView)
		contentView.addSubview(categoryNameLabel)
	}

	private func makeConstraints() {
		NSLayoutConstraint.activate([
			categoryImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			categoryImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
			categoryImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
			categoryImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

			categoryNameLabel.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor, constant: 4),
			categoryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			categoryNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			categoryNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
}
