import Foundation

// Struct representing detailed information about a meal, conforms to Decodable and Identifiable.
struct MealDetail: Decodable, Identifiable {
    // Properties to store meal details
    var idMeal: String
    var strMeal: String
    var strMealThumb: String
    var strInstructions: String
    
    // Directly initialized list of ingredients
    let ingredients: [Ingredient]

    // Computed property to satisfy the Identifiable protocol, using idMeal as the unique identifier.
    var id: String { idMeal }

    // Custom initializer to decode data from JSON using a Decoder.
    init(from decoder: Decoder) throws {
        // Create a container to decode values based on the CodingKeys enumeration.
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode each property from the container.
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        
        // Decode the list of ingredients using a simplified function.
        ingredients = try MealDetail.decodeIngredients(from: container)
    }
    
    // Simplified and optimized function to decode ingredients from the container.
    static private func decodeIngredients(from container: KeyedDecodingContainer<CodingKeys>) throws -> [Ingredient] {
        return try (1...20).compactMap { index in
            // Create keys for ingredient and measure based on the current index.
            let ingredientKey = CodingKeys(stringValue: "strIngredient\(index)")
            let measureKey = CodingKeys(stringValue: "strMeasure\(index)")
            
            // Decode ingredient and measure if keys are valid.
            guard let ingredientKey = ingredientKey, let measureKey = measureKey,
                  let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey),
                  let measure = try container.decodeIfPresent(String.self, forKey: measureKey),
                  !ingredient.isEmpty, !measure.isEmpty else {
                return nil
            }
            
            // Return an Ingredient object.
            return Ingredient(name: ingredient, measure: measure)
        }
    }
}

// Struct representing an ingredient and its measurement.
struct Ingredient {
    let name: String
    let measure: String
}

// Enumeration for JSON coding keys used in the MealDetail struct.
extension MealDetail {
    enum CodingKeys: String, CodingKey {
        // Keys for meal details.
        case idMeal
        case strMeal
        case strMealThumb
        case strInstructions
        
        // Keys for ingredients and their measurements (up to 20).
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5
        case strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10
        case strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        case strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5
        case strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10
        case strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
        case strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
        
        // Initialize CodingKeys from a string.
        init?(stringValue: String) {
            self.init(rawValue: stringValue)
        }
        
        // Return the string value of the coding key.
        var stringValue: String {
            return self.rawValue
        }
    }
}
