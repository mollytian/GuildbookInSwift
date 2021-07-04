//
//  NetworkService.swift
//  GuidebookChallenge
//
//  Created by Mengyuan Tian on 2021/7/2.
//

import Foundation

protocol NetworkServiceProvider {
    func fetchGuides(completion: @escaping (Result<[Guide], Error>) -> Void)
}

struct NetworkService: NetworkServiceProvider {
    
    let session = URLSession.shared
    
    func fetchGuides(completion: @escaping (Result<[Guide], Error>) -> Void) {
        
        let guidesURLString = "https://www.guidebook.com/service/v2/upcomingGuides/"
        let url = URL(string: guidesURLString)
        
        let task = session.dataTask(with: url!, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            if let jsonData = data {
                let resultArray: ResultArray = try! JSONDecoder().decode(ResultArray.self, from: jsonData)
                completion(.success(resultArray.guides))
            }
        })
        task.resume()
    }
        
        
        
    
        
        
        
//
//        { data, response, error in
//            if let fetchError = error {
//                completion(.failure(fetchError))
//            }
//            if let jsonData = data {
//                let resultArray: ResultArray = try! JSONDecoder().decode(ResultArray.self, from: jsonData)
//                DispatchQueue.main.async {
//                    completion(.success(resultArray.guides))
//                }
//            }
//        }
//        task.resume()
//    }
}
