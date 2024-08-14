import Foundation

// Struct representing a meal.
struct Meal: Codable, Identifiable {
    var idMeal: String
    var strMeal: String
    var strMealThumb: String
    
    // Computed property to conform to Identifiable protocol.
    var id: String { idMeal }
}
