//
//  APIEndpoints.swift
//  A file that contains the API endpoint URLs.
//  Recipe
//
//  Created by Jay Chawla on 4/13/23.
//

import Foundation
struct APIEndpoints {
    static let base = "https://www.themealdb.com/api/json/v1/1"
    static let category = "\(base)/filter.php?c="
    static let mealDetail = "\(base)/lookup.php?i="
}

