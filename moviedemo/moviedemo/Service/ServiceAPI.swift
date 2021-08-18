//
//  ServiceAPI.swift
//  moviedemo
//
//  Created by Maria Yu on 7/28/21.
//

import Foundation

class ServiceAPI {
    public static let shared = ServiceAPI()
    private init() {}
    private let urlSession = URLSession.shared
    private let popularURLString =  "https://api.themoviedb.org/3/movie/popular?api_key=a1cf40a6cca6479e5f858538e65ee78c&language=en-US&page="
    private let jsonDecoder = JSONDecoder()
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
        case downloadImageError
        case downloadTrackError
    }
    
    typealias JSONDictionary = [String: Any]
    
    public func fetchConfiguration(result: @escaping (Result<ConfigurationResponse, APIServiceError>) -> Void) {
        guard let fetchURL = URL(string: "https://api.themoviedb.org/3/configuration?api_key=a1cf40a6cca6479e5f858538e65ee78c") else { return
        }
           
        guard let urlComponents = URLComponents(url: fetchURL, resolvingAgainstBaseURL: true) else {
               return
        }
        
        fetchResources(urlComponents: urlComponents, completion: result)
    }
    
    public func fetchPopular(for page: Int, result: @escaping (Result<SearchResponse, APIServiceError>) -> Void) {
        guard let fetchURL = URL(string: popularURLString + "\(page)") else { return }
        
        guard let urlComponents = URLComponents(url: fetchURL, resolvingAgainstBaseURL: true) else {
            return
        }
        
        fetchResources(urlComponents: urlComponents, completion: result)
    }

    private func fetchResources<T: Decodable>(urlComponents: URLComponents, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
     
        urlSession.dataTask(with: url) { (result) in
            switch result {
                case .failure:
                    completion(.failure(.apiError))
            
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200
                    else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    
                    do {
                        let values = try self.jsonDecoder.decode(T.self, from: data)
                        completion(.success(values))
                    } catch {
                        completion(.failure(.decodeError))
                    }
            }
         }.resume()
    }
    
    public func downloadImage(url: URL, completion: @escaping (Result<Data, APIServiceError>) -> Void) {
        urlSession.dataTask(with: url) { (result) in
           switch result {
               case .failure:
                   completion(.failure(.downloadImageError))
           
               case .success(let (response, data)):
                   guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200
                       else {
                           completion(.failure(.invalidResponse))
                       return
                   }
                   
                   DispatchQueue.main.async() {
                       completion(.success(data))
                   }
           }
        }.resume()
    }
    
    public func downloadTrack(url: URL, completion: @escaping (Result<Data, APIServiceError>) -> Void) {
        urlSession.dataTask(with: url) { (result) in
           switch result {
               case .failure:
                   completion(.failure(.downloadTrackError))
           
               case .success(let (response, data)):
                   guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200
                       else {
                           completion(.failure(.invalidResponse))
                       return
                   }
                   
                   DispatchQueue.main.async() {
                       completion(.success(data))
                   }
           }
        }.resume()
    }
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}

