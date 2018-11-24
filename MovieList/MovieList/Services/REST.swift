//
//  REST.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/23/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import Foundation

enum ApiError {
    case invalidJson
    case url
    case noResponse
    case noData
    case httpError(code: Int)
}

class REST {
    static let basePath = "https://itunes.apple.com/search?media=movie&entity=movie&term="

    static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        // timeout de 10 segundos
        config.timeoutIntervalForResource = 10
        // wi-fi apenas
        config.allowsCellularAccess = false
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()

    static let session = URLSession(configuration: configuration)

    class func load(movieName: String, completion: @escaping (URL?, ApiError?) -> Void) {
        let newMovieName = movieName.replacingOccurrences(of: " ", with: "").lowercased()
        guard let url = URL(string: basePath + newMovieName) else {
            return completion(nil, .url)
        }

        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return completion(nil, .noResponse)
            } else {
                guard let response = response as? HTTPURLResponse else {
                    return completion(nil, .noResponse)
                }

                switch response.statusCode {
                case 200...299:
                    guard let data = data else {
                        return completion(nil, .noData)
                    }

                    do {
                        let result = try JSONDecoder().decode(ItunesApi.self, from: data)

                        guard let urlString = result.results.first?.previewUrl else {
                            return completion(nil, .invalidJson)
                        }

                        guard let url = URL(string: urlString) else {
                            return completion(nil, .invalidJson)
                        }

                        completion(url, nil)
                    } catch {
                        return completion(nil, .invalidJson)
                    }
                default:
                    return completion(nil, .httpError(code: response.statusCode))
                }
            }
        }

        task.resume()
    }
}
