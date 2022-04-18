//
//  APICaller.swift
//  RickAndMortyAPI
//
//  Created by Sungur on 17.04.2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://rickandmortyapi.com/api/character")
    }
    
    private init() {}
    
    public func getCharacters(completion: @escaping (Result<[Results], Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Characters: \(result.results.count)")
                    completion(.success(result.results))
                } catch  {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}


//Models
struct APIResponse: Codable {
    let results: [Results]
}

struct Results: Codable {
    let name: String
    let species: String
    let gender: String
    let image: String
    let status: String?
    let episode: [String]
    let location: Location
}

struct Location: Codable {
    let name: String
}


