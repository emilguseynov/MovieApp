//
//  Service.swift
//  MovieApp
//
//  Created by Emil Guseynov on 13.10.2022.
//

import Foundation

class Service {
    fileprivate var apiKey = "80fa93faf695fb77673a8fa32efa11cc"
    
    static let shared = Service()
    
    var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private init() {
    }
    
    func fetchPopularMovies(completion: @escaping (Content?, Error?) -> Void) {
        fetchGenericJSONData(
            urlString: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1&region=US",
            completion: completion)
    }
    
    func fetchPopularTVShows(completion: @escaping (Content?, Error?) -> Void) {
        fetchGenericJSONData(
            urlString: "https://api.themoviedb.org/3/tv/popular?api_key=\(apiKey)&language=en-US$region=US&page=1",
            completion: completion)
    }
    
    fileprivate func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [self] data, resp, err in
            if let err = err {
                completion(nil, err)
                return
            }
            
            do {
                let objects = try decoder.decode(T.self, from: data!)
                completion(objects, nil)
            } catch {
                completion(nil, error)
                print("Failed to decode: ", error)
            }
        }.resume()
    }
    
}
