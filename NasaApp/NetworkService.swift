//
//  NetworkService.swift
//  NasaApp
//
//  Created by Ertürk Alan on 8.02.2023.
//

import Foundation
import Alamofire

class NetworkService {
    static let sharedInstance = NetworkService()
    
    typealias NasaCompletion = ([PhotoModel]) -> Void
    
    func fetchData(rover: String , pageNumber:Int, completion: @escaping NasaCompletion) {
        let url = "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover)/photos?sol=1000&api_key=JzCKeyNn3NW5nE0OPF0Dzfc4a5BYr5XTP2Sapdyl&page=\(pageNumber)"
        print(url)
        AF.request(url, method: .get, parameters: nil, headers: nil, interceptor: nil).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(Photos.self, from: data!)
                    completion(jsonData.photos)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}


