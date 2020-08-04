//
//  APIClient.swift
//  ParsingJson-URLSession
//
//  Created by Brendon Cecilio on 8/4/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import Foundation

// TODO: convert to a Generic APIClient<Station>()
// conform APIClient to decodable

enum APIError: Error {
    case badURL(String)
    case networkError(Error)
    case decodingError(Error)
}

class APIClient {
    
    func fetchData(completion: @escaping (Result<[Station], APIError>) -> ()) {
        
        let endpoint = "https://gbfs.citibikenyc.com/gbfs/en/station_information.json"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.badURL(endpoint)))
            return
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(ResultWrapper.self, from: data)
                    completion(.success(result.data.stations))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        dataTask.resume()
    }
}
