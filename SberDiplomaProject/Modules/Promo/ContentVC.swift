//
//  ContentVC.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 12.07.2021.
//

import UIKit

// Контроллер для отображения контента на Промо-экране
final class ContentVC: UIViewController {

	private var imageName: String
	private var text: String
	private var leftAction: (() -> Void)?
	private var rightAction: (() -> Void)?
	private var rightButtonImageName: String?
	private var rightButtonTitle: String?

	/// Текст описания
	private let textLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .center
		label.font = UIFont(name: "ChalkboardSE-Bold", size: 16)
		label.numberOfLines = 0
		label.textColor = #colorLiteral(red: 0.3054279089, green: 0.04050517827, blue: 0.5404698253, alpha: 1)
		return label
	}()

	/// Кнопка "Влево"
	private lazy var leftButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named: "leftButton"), for: .normal)
		button.setTitle("Назад", for: .normal)
		button.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 16)
		button.setTitleColor(#colorLiteral(red: 0.3054279089, green: 0.04050517827, blue: 0.5404698253, alpha: 1), for: .normal)
		button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
		button.layer.cornerRadius = 6
		button.clipsToBounds = true
		button.backgroundColor = #colorLiteral(red: 0.9761093259, green: 0.952090919, blue: 0.7397835851, alpha: 1)
		button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
		return button
	}()

	/// Кнопка "Вправо"
	private lazy var rightButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named: "rightButton"), for: .normal)
		button.setTitle("Далее", for: .normal)
		button.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 16)
		button.setTitleColor(#colorLiteral(red: 0.3054279089, green: 0.04050517827, blue: 0.5404698253, alpha: 1), for: .normal)
		button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
		button.layer.cornerRadius = 6
		button.semanticContentAttribute = .forceRightToLeft
		button.clipsToBounds = true
		button.backgroundColor = #colorLiteral(red: 0.9761093259, green: 0.952090919, blue: 0.7397835851, alpha: 1)
		button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
		return button
	}()

	/// Картинка
	private let contentImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		imageView.layer.cornerRadius = 12
		imageView.clipsToBounds = true
		imageView.backgroundColor = .clear
		return imageView
	}()

	/// Инициализатор
	/// - Parameters:
	///   - imageName: Название картинки
	///   - text: Текст описания
	///   - leftAction: Событие по нажатию на кнопку "Влево"
	///   - rightAction: Событие по нажатию на кнопку "Вправо"
	///   - rightButtonImageName: Картинка кнопки "Вправо"
	///   - rightButtonTitle: Заголовок кнопки "Вправо"
	init(
		with imageName: String,
		text: String,
		leftAction: (() -> Void)? = nil,
		rightAction: (() -> Void)? = nil,
		rightButtonImageName: String? = nil,
		rightButtonTitle: String? = nil)
	{
		self.imageName = imageName
		self.text = text
		self.leftAction = leftAction
		self.rightAction = rightAction
		self.rightButtonImageName = rightButtonImageName
		self.rightButtonTitle = rightButtonTitle
		super.init(nibName: nil, bundle: nil)

		setupViews()
		makeConstraints()
		configure()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

//MARK: - User methods
extension ContentVC {
	private func setupViews() {
		view.addSubview(textLabel)
		view.addSubview(leftButton)
		view.addSubview(rightButton)
		view.addSubview(contentImageView)
	}

	private func makeConstraints() {
		NSLayoutConstraint.activate([
			contentImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
			contentImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
			contentImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			contentImageView.heightAnchor.constraint(equalToConstant: 450),

			textLabel.topAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: 24),
			textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
			textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

			leftButton.topAnchor.constraint(greaterThanOrEqualTo: textLabel.bottomAnchor, constant: 24),
			leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
			leftButton.widthAnchor.constraint(equalToConstant: 120),
			leftButton.heightAnchor.constraint(equalToConstant: 40),
			leftButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),

			rightButton.topAnchor.constraint(greaterThanOrEqualTo: textLabel.bottomAnchor, constant: 24),
			rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
			rightButton.widthAnchor.constraint(equalToConstant: 120),
			rightButton.heightAnchor.constraint(equalToConstant: 40),
			rightButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),

		])
	}

	private func configure() {
		leftButton.isHidden = leftAction == nil
		contentImageView.image = UIImage(named: imageName)
		textLabel.text = text

		if let buttonImageName = rightButtonImageName {
			rightButton.setImage(UIImage(named: buttonImageName), for: .normal)
		}

		if rightButtonTitle != nil {
			rightButton.setTitle(rightButtonTitle, for: .normal)
		}
	}

	@objc private func leftButtonTapped() {
		leftAction?()
	}

	@objc private func rightButtonTapped() {
		rightAction?()
	}
}


