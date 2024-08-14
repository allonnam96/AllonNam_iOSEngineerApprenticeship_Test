import Foundation

// Endpoint URL to fetch meal data.
private let mealsEndpoint = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"

// Cache configuration for URL requests.
private let cache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: nil)

// Asynchronous function to fetch meals from the API.
func getMeals() async throws -> [Meal] {
    // Create a URL object from the endpoint string & throw an error if the URL is invalid.
    guard let url = URL(string: mealsEndpoint) else {
        throw MealError.invalidURL
    }
    
    // Create a URLRequest object for the URL.
    let request = URLRequest(url: url)
    
    // Check if there's a cached response for the request.
    if let cachedResponse = cache.cachedResponse(for: request) {
        // Decode and return the cached meal data.
        return try JSONDecoder().decode(MealResponse.self, from: cachedResponse.data).meals
    }
    
    // Perform the network request to fetch data from the URL.
    let (data, response) = try await URLSession.shared.data(from: url)
    
    // Ensure the response status code is 200 (OK).
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw MealError.invalidResponse // Throw an error if the response is invalid.
    }
    
    // Decode the meal data from the response data.
    let mealResponse = try JSONDecoder().decode(MealResponse.self, from: data)
    
    // Cache the network response for future use.
    cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
    
    // Return the list of meals from the decoded response.
    return mealResponse.meals
}

// Enum to define possible errors that can occur during meal fetching.
enum MealError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
