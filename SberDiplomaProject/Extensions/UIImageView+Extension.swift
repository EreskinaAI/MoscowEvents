//
//  UIImageView+Extension.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 24.07.2021.
//

import UIKit

extension UIImageView {
	/// Загрузить картинку по URL-адресу
	/// - Parameter url: адрес
	func loadImage(with url: String?) {
		guard let urlString = url, let url = URL(string: urlString) else { return }

		let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)

		URLSession.shared.dataTask(with: request) { (data, _, error) in
			guard let data = data,
				  error == nil,
				  let image = UIImage(data: data)
				else { return }
			DispatchQueue.main.async() { [weak self] in
				self?.image = image
			}
		}.resume()
	}

	/// Покрасить картинку в цвет
	/// - Parameter color: цвет
	func setImageColor(color: UIColor) {
		let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
		self.image = templateImage
		self.tintColor = color
	}
}
