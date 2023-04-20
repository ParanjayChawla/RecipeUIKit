//
//  MealList.swift
//  Data model for a list of meals.
//  Recipe
//
//  Created by Jay Chawla on 4/13/23.
//

import Foundation
struct MealsListResponse: Codable {
    let meals: [MealDetail]
}
