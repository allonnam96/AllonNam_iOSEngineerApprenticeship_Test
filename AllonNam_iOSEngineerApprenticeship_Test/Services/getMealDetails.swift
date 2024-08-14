import Foundation

// Asynchronous function to fetch detailed information about a meal using its ID.
func getMealDetails(idMeal: String) async throws -> MealDetail {
    // Construct the API endpoint URL using the meal ID.
    let endpoint = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(idMeal)"
    // Create a URL object from the endpoint string & throw an error if the URL is invalid.
    guard let url = URL(string: endpoint) else {
        throw MealError.invalidURL
    }
    
    // Perform the network request to fetch data from the URL.
    let (data, response) = try await URLSession.shared.data(from: url)

    // Ensure the response status code is 200 (OK).
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw MealError.invalidResponse // Throw an error if the response is invalid.
    }

    // Decode the meal details from the response data.
    let mealDetailResponse = try JSONDecoder().decode(MealDetailResponse.self, from: data)
    // Ensure that there is at least one meal detail in the response & throw an error if the meal data is not present.
    guard let mealDetail = mealDetailResponse.meals.first else {
        throw MealError.invalidData
    }

    return mealDetail
}
