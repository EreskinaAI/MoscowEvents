//
//  NSAttributedString+Extension.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 17.07.2021.
//

import Foundation

extension NSAttributedString {
	/// Конвертируем HTML-текст в NSAttributedString
	/// - Parameter html: HTML-текст
	internal convenience init(html: String) {
		guard
			let data = html.data(using: String.Encoding.utf16,
								 allowLossyConversion: false)
		else {
			self.init(string: "")
			return
		}

		let options : [DocumentReadingOptionKey : Any] = [
			.documentType: NSAttributedString.DocumentType.html,
			.characterEncoding: String.Encoding.utf8.rawValue
		]

		guard
			let string = try? NSMutableAttributedString(
				data: data,
				options: options,
				documentAttributes: nil)
		else {
			self.init(string: "")
			return
		}

		self.init(attributedString: string)
	}
}
