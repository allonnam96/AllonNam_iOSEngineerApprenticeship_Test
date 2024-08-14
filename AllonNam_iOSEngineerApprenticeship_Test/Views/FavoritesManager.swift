import Foundation
import SwiftUI

class FavoritesManager: ObservableObject {
    // Use AppStorage to persist favorite meals data across app launches.
    @AppStorage("favoriteMeals") private var favoriteMealsData: Data = Data()
    // Published property to notify views of changes to favorite meals.
    @Published var favoriteMeals: [Meal] = []
    
    init() {
        // Load favorite meals from storage when the instance is initialized.
        loadFavorites()
    }
    
    func isFavorite(_ meal: Meal) -> Bool {
        // Check if the meal is in the list of favorite meals.
        favoriteMeals.contains { $0.idMeal == meal.idMeal }
    }
    
    func addFavorite(_ meal: Meal) {
        // Add a meal to the list of favorite meals and save the updated list.
        favoriteMeals.append(meal)
        saveFavorites()
    }
    
    func removeFavorite(_ meal: Meal) {
        // Remove a meal from the list of favorite meals and save the updated list.
        favoriteMeals.removeAll { $0.idMeal == meal.idMeal }
        saveFavorites()
    }
    
    private func saveFavorites() {
        // Encode the list of favorite meals to JSON data and store it using AppStorage.
        if let encoded = try? JSONEncoder().encode(favoriteMeals) {
            favoriteMealsData = encoded
        }
    }
    
    private func loadFavorites() {
        // Decode the JSON data from AppStorage to retrieve the list of favorite meals.
        if let decoded = try? JSONDecoder().decode([Meal].self, from: favoriteMealsData) {
            favoriteMeals = decoded
        }
    }
}
