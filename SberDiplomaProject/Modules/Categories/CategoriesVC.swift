//
//  CategoriesVC.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 09.07.2021.
//

import UIKit

/// Контроллер экрана - список категорий
final class CategoriesVC: UIViewController {

	/// Презентер
	var presenter: CategoriesPresenterProtocol?

	/// Категории
	private var categories: [CategotyModel] = []

	/// Таймер для анимации картинки
	private var timer = Timer()

	/// Картинка в заголовке
	let titleImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = UIImage(named: "kremlin")
		imageView.contentMode = .scaleAspectFill

		return imageView
	}()

	/// Заголовок экрана
	let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "MОСКВА"
		label.textColor = #colorLiteral(red: 0.4717761278, green: 0.2234528661, blue: 0, alpha: 1)
		label.textAlignment = .left
		label.font = UIFont(name: "Marker Felt", size: 24)

		return label
	}()

	///  Коллекция
	private lazy var categoriesCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.itemSize = CGSize(width: 88, height: 88)
		layout.minimumInteritemSpacing = 60
		layout.minimumLineSpacing = 40

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.register(CategotyCell.self, forCellWithReuseIdentifier: CategotyCell.reuseID)
		collectionView.backgroundColor = .clear
		collectionView.contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
		collectionView.dataSource = self
		collectionView.delegate = self

		return collectionView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		makeConstraints()
		startTimerAnimation()

		presenter?.loadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
	}
}

//MARK: - User methods
extension CategoriesVC {
	private func setupViews() {
		view.backgroundColor = #colorLiteral(red: 0.9761093259, green: 0.952090919, blue: 0.7397835851, alpha: 1)
		navigationItem.title = "Категории"
		view.addSubview(titleImageView)
		view.addSubview(titleLabel)
		view.addSubview(categoriesCollectionView)
	}

	private func makeConstraints() {
		NSLayoutConstraint.activate([
			titleImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
			titleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
			titleImageView.widthAnchor.constraint(equalToConstant: 50),
			titleImageView.heightAnchor.constraint(equalToConstant: 50),

			titleLabel.bottomAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 4),
			titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			titleLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: 10),

			categoriesCollectionView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 60),
			categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			categoriesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}

	private func startTimerAnimation() {
		animateIcon()
		timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
			self.animateIcon()
		})
	}
	
	private func animateIcon() {
		var rotationAnimation = CABasicAnimation()
		rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.y")
		rotationAnimation.toValue = NSNumber(value: Double.pi)
		rotationAnimation.duration = 3.0
		self.titleImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
	}
}

//MARK: - UICollectionViewDelegate
extension CategoriesVC: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let eventsListVC = Assembly.makeEventsListVC(with: categories[indexPath.item].slug)
		eventsListVC.navigationItem.title = categories[indexPath.item].name
		navigationController?.pushViewController(eventsListVC, animated: true)
	}
}

//MARK: - UICollectionViewDataSource
extension CategoriesVC: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return categories.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategotyCell.reuseID, for: indexPath)
		(cell as? CategotyCell)?.configure(with: categories[indexPath.item])
		return cell
	}
}

//MARK: - CategoriesViewProtocol
extension CategoriesVC: CategoriesViewProtocol {
	func update(with models: [CategotyModel]) {
		categories = models
		categoriesCollectionView.reloadData()
	}
}
