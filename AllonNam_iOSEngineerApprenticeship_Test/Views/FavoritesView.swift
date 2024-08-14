import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        NavigationView {
            List(favoritesManager.favoriteMeals.sorted(by: { $0.strMeal < $1.strMeal }), id: \.idMeal) { meal in
                NavigationLink(destination: MealDetailView(mealID: meal.idMeal)) {
                    HStack {
                        // Check if the meal image URL is valid.
                        if let url = URL(string: meal.strMealThumb) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                            } placeholder: {
                                // Placeholder while the image is loading.
                                Circle()
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: 50, height: 50)
                        }
                        Text(meal.strMeal)
                            .bold()
                        Spacer()
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView().environmentObject(FavoritesManager())
}
