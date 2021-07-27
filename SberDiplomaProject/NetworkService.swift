//
//  NetworkService.swift
//  SberDiplomaProject
//
//  Created by Анна Ереськина on 11.07.2021.
//

import Foundation

/// Ошибки сети
enum NetworkError: Error {
	/// нет данных
	case unknow
}

// Тип ответа сервера
typealias NetworkResponse<T: Codable> = Result<EventsModel<T>, NetworkError>

/// Протокол сервиса для работы с сетью
protocol NetworkServiceProtocol {
	/// Получить события по названию категории
	/// - Parameters:
	///   - category: категория
	///   - pageNumber: страница
	///   - completion: результат
	func loadEvents(for category: String, with pageNumber: Int, completion: @escaping (NetworkResponse<EventModel>) -> Void)

	/// Получить события для следующей страницы
	/// - Parameters:
	///   - pageURL: следующая страница
	///   - completion: результат
	func loadEvents(for pageURL: String?, completion: @escaping (NetworkResponse<EventModel>) -> Void)

	/// Получить события по строке поиска
	/// - Parameters:
	///   - searchText: строка поиска
	///   - completion: результат
	func loadEvents(with searchText: String, completion: @escaping (NetworkResponse<EventSearchModel>) -> Void)
}

/// Сервис по работе с сетью
final class NetworkService {

	/// Базовый адрес API
	private let baseURL = "https://kudago.com/public-api/v1.4/"
	/// Декодер
	private let decoder = JSONDecoder()
}

//MARK: - NetworkServiceProtocol
extension NetworkService: NetworkServiceProtocol {
	func loadEvents(for category: String, with pageNumber: Int, completion: @escaping (NetworkResponse<EventModel>) -> Void) {
		let params: [String: Any] = [
			"number": pageNumber,
			"categories": category,
			"expand": "place",
			"fields": "id,place,dates,short_title,description,is_free,images,price,body_text"
		]
		guard let request = makeRequest(for: "events", with: params) else {
			completion(.failure(.unknow))
			return
		}
		runRequest(request: request, completion: completion)
	}

	func loadEvents(for pageURL: String?, completion: @escaping (NetworkResponse<EventModel>) -> Void) {
		guard let urlString = pageURL, let url = URL(string: urlString) else {
			completion(.failure(.unknow))
			return
		}
		let request = URLRequest(url: url)
		runRequest(request: request, completion: completion)
	}

	func loadEvents(with searchText: String, completion: @escaping (NetworkResponse<EventSearchModel>) -> Void){

		let search = searchText
			.replacingOccurrences(of: " ", with: "_")
			.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

		let params: [String: Any] = [
			"q": search ?? "",
			"ctype": "event",
			"expand": "place",
			"fields": "id,place,dates,short_title,description,is_free"
		]
		guard let request = makeRequest(for: "search", with: params) else {
			completion(.failure(.unknow))
			return
		}
		runRequest(request: request, completion: completion)
	}

	private func makeRequest(for endpoint: String, with params: [String: Any]) -> URLRequest? {
		let queryString = params
			.sorted { $0.0 < $1.0 }
			.compactMap { "\($0.0)=\($0.1)" }
			.joined(separator: "&")
		let urlString = baseURL + endpoint + "/" + (params.count > 0 ? "?" + queryString : "")
		guard let url = URL(string: urlString) else { return nil }
		return URLRequest(url: url)
	}

	private func runRequest<T: Codable>(request: URLRequest, completion: @escaping (NetworkResponse<T>) -> Void) {
		URLSession.shared.dataTask(with: request) { (data, responce, error) in
			guard let data = data else {
				completion(.failure(.unknow))
				return
			}
			do {
				let object = try self.decoder.decode(EventsModel<T>.self, from: data)
				completion(.success(object))
			} catch let error {
				print(error.localizedDescription)
				completion(.failure(.unknow))
			}
		}.resume()
	}
}
