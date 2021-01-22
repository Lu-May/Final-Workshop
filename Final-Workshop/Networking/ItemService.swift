//
//  ItemService.swift
//  Final-Workshop
//
//  Created by Yuehuan Lu on 2021/1/4.
//

import Foundation

class ItemQueryService {
  let defaultSession = URLSession(configuration: .default)
  
  var dataTask: URLSessionDataTask?
  
  typealias JSONDictionary = [String: Any]
  typealias ItemQueryResult = ([Item]?, String) -> Void
  
  func getSearchResults(completion: @escaping ItemQueryResult) {
    
    dataTask?.cancel()
    
    if let urlComponents = URLComponents(string: "https://tw-mobile-xian.github.io/pos-api/items.json") {
      guard let url = urlComponents.url else {
        return
      }
      dataTask =
        defaultSession.dataTask(with: url) { [weak self] data, response, error in
          defer {
            self?.dataTask = nil
          }
          var errorMessage = ""
          var itemDatas: [Item] = []
          if let error = error {
            errorMessage += "DataTask error: " +
              error.localizedDescription + "\n"
          } else if
            let tweet = data,
            let response = response as? HTTPURLResponse,
            response.statusCode == 200 {
            do {
              itemDatas = try JSONDecoder().decode([Item].self, from: tweet)
            } catch {
              print(error)
            }
          }
          DispatchQueue.main.async {
            completion(itemDatas, errorMessage )
          }
        }
      dataTask?.resume()
    }
  }
}

