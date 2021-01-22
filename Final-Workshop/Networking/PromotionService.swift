//
//  PromotionService.swift
//  Final-Workshop
//
//  Created by Yuehuan Lu on 2021/1/5.
//

import Foundation

class PromotionQueryService {
  let defaultSession = URLSession(configuration: .default)
  
  var dataTask: URLSessionDataTask?
  
  typealias JSONDictionary = [String: Any]
  typealias PromotionQueryResult = ([String]?, String) -> Void
  
  func getSearchResults(completion: @escaping PromotionQueryResult) {
    
    dataTask?.cancel()
    
    if let urlComponents = URLComponents(string: "https://tw-mobile-xian.github.io/pos-api/promotions.json") {
      guard let url = urlComponents.url else {
        return
      }
      dataTask =
        defaultSession.dataTask(with: url) { [weak self] data, response, error in
          defer {
            self?.dataTask = nil
          }
          var errorMessage = ""
          var promotionDatas: [String] = []
          if let error = error {
            errorMessage += "DataTask error: " +
              error.localizedDescription + "\n"
          } else if
            let promotion = data,
            let response = response as? HTTPURLResponse,
            response.statusCode == 200 {
            do {
              promotionDatas = try JSONDecoder().decode([String].self, from: promotion)
            } catch {
              print(error)
            }
          }
          DispatchQueue.main.async {
            completion(promotionDatas, errorMessage )
          }
        }
      dataTask?.resume()
    }
  }
}
