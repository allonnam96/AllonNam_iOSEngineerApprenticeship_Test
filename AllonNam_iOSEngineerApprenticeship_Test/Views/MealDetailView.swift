import SwiftUI

struct MealDetailView: View {
    let mealID: String
    @State private var mealDetail: MealDetail?
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            // Check if meal details are available.
            if let meal = mealDetail {
                VStack(alignment: .leading) {
                    Text(meal.strMeal)
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom)
                    
                    // Button to add/remove meal from favorites.
                    Button(action: toggleFavorite) {
                        Text(favoritesManager.isFavorite(convertToMeal(from: meal)) ? "Remove from Favorites" : "Add to Favorites")
                            .foregroundColor(.blue)
                            .padding(.top)
                    }
                    
                    // Check if meal image URL is valid.
                    if let url = URL(string: meal.strMealThumb) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Rectangle()
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom)
                    }
                    
                    Text("Instructions")
                        .font(.headline)
                        .padding(.top)
                    
                    Text(meal.strInstructions)
                        .padding(.bottom, 10)
                    
                    Text("Ingredients")
                        .font(.headline)
                        .padding(.top)
                    
                    ForEach(meal.ingredients, id: \.name) { ingredient in
                        Text("\(ingredient.measure) \(ingredient.name)")
                            .padding(.bottom, 2)
                    }
                }
                .padding()
            } else {
                // Show a progress view while meal details are loading.
                CenteredProgressView()
                    .onAppear {
                        // Load meal details when the view appears.
                        loadMealDetail()
                    }
            }
        }
    }
    
    // Asynchronous function to load meal details.
    private func loadMealDetail() {
        // Fetch meal details and update state & error handling
        Task {
            do {
                mealDetail = try await getMealDetails(idMeal: mealID)
            } catch {
                print("Failed to load meal details:", error.localizedDescription)
            }
        }
    }
    
    // Function to toggle the favorite status of the meal.
    private func toggleFavorite() {
        guard let meal = mealDetail else { return }
        let favoriteMeal = convertToMeal(from: meal)
        if favoritesManager.isFavorite(favoriteMeal) {
            favoritesManager.removeFavorite(favoriteMeal)
        } else {
            favoritesManager.addFavorite(favoriteMeal)
        }
    }
    
    // Function to convert MealDetail to Meal.
    private func convertToMeal(from mealDetail: MealDetail) -> Meal {
        return Meal(idMeal: mealDetail.idMeal, strMeal: mealDetail.strMeal, strMealThumb: mealDetail.strMealThumb)
    }
}

// View for showing a centered progress indicator.
struct CenteredProgressView: View {
    var body: some View {
        ProgressView("Loading...")
            .progressViewStyle(CircularProgressViewStyle())
    }
}


#Preview {
    MealDetailView(mealID: "53082")
        .environmentObject(FavoritesManager())
}
