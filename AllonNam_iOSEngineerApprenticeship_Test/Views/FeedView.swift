import SwiftUI

struct FeedView: View {
    // State variables to manage the list of meals, the currently selected meal, and the search text.
    @State private var meals: [Meal] = []
    @State private var selectedMeal: Meal? = nil
    @State private var searchText: String = ""
    
    // EnvironmentObject to manage and access the favorites list.
    @EnvironmentObject var favoritesManager: FavoritesManager

    // Filter meals based on the search text.
    var filteredMeals: [Meal] {
        meals.filter { meal in
            searchText.isEmpty || meal.strMeal.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Custom view for search functionality.
                SearchView(searchText: $searchText)
                
                // List displaying the filtered meals, sorted alphabetically by meal name.
                List(filteredMeals.sorted(by: { $0.strMeal < $1.strMeal }), id: \.idMeal) { meal in
                    // Button to select a meal and show its details.
                    Button(action: {
                        selectedMeal = meal
                    }) {
                        HStack {
                            // Load and display meal images with a placeholder and error image.
                            AsyncImage(url: URL(string: meal.strMealThumb)) { phase in
                                if let image = phase.image {
                                    // Displays the image when loading is successful.
                                    image
                                        .resizable()
                                        .clipShape(Circle())
                                } else {
                                    // Placeholder while the image is loading.
                                    Circle().foregroundColor(.secondary)
                                }
                            }
                            .frame(width: 50, height: 50)
                            
                            // Displays the meal name.
                            Text(meal.strMeal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Displays a star icon if the meal is marked as a favorite.
                            if favoritesManager.isFavorite(meal) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Desserts")
        }
        // Task to asynchronously fetch the list of meals when the view appears & error handling.
        .task {
            do {
                meals = try await getMeals()
            } catch {
                print(error.localizedDescription)
            }
        }
        // Presents a sheet with the details of the selected meal.
        .sheet(item: $selectedMeal) { meal in
            MealDetailView(mealID: meal.idMeal)
                .environmentObject(favoritesManager)
        }
    }
}

#Preview {
    FeedView().environmentObject(FavoritesManager())
}
