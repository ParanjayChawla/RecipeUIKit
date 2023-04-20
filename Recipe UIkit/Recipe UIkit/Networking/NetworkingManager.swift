//
//  NetworkManager.swift
//  A dedicated networking layer that handles all API calls.
//  Recipe
//
//  Created by Jay Chawla on 4/13/23.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let session = URLSession.shared
    
    func fetchMeals(for category: String, completion: @escaping (Result<[MealDetail], Error>) -> Void) {
        let endpoint = "\(APIEndpoints.category)" + category
        let url = URL(string: endpoint)!
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MealsListResponse.self, from: data)
                let meals = response.meals
                
                completion(.success(meals))
            } catch let error {
                print("error happened in the FetchMEALS")
                completion(.failure(error))
            }
            
        }
        
        task.resume()
        
    }
    
    func fetchMealDetails(for id: String, completion: @escaping (Result<MealDetailResponse, Error>) -> Void) {
        let endpoint = "\(APIEndpoints.mealDetail)" + "\(id)"
        let url = URL(string: endpoint)!
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(MealDetailResponse.self, from: data)
                
                var mealDetails = response
                mealDetails.meals[0].displayString = self.cleanUp(nsListIng: mealDetails.meals[0].nsListIng , nsListMea: mealDetails.meals[0].nsListMea)
                
                completion(.success(mealDetails))
            } catch let error {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    private func cleanUp(nsListIng: Array<String> , nsListMea: Array<String> ) -> String {
        var count = 0
        var l = [] as Array
        var m = [] as Array
        var display_string: String = ""
        for value in nsListIng {
            let value_s = "\(value)".capitalized
            if ( value_s != "" && value_s != "null" && value_s != " "){
                
                l.append(value_s)
                count = count + 1
            }
        }
        for value in nsListMea {
                let value_s = "\(value)"
                if ( value_s != "" && value_s != "null" && value_s != " "){
                    m.append(value_s)
                }
        }
        
        for i in 0...(count-1) {
            let s = "\(l[i]) ( \(m[i]) )\n"
            display_string.append(s)
        }
        return display_string
    }
    
}
