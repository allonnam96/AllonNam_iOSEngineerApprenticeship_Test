import SwiftUI

struct HomeView: View {
    // StateObject for FavoritesManager to manage favorite items.
    @StateObject private var favoritesManager = FavoritesManager()
    
    var body: some View {
        // A TabView for switching between different views using tabs.
        TabView {
            FeedView()
                .tabItem {
                    Label("DESSERTS", systemImage: "list.bullet")
                }
            FavoritesView()
                .tabItem {
                    Label("FAVORITES", systemImage: "star.fill")
                }
        }
        // Passes the FavoritesManager environment object to all child views.
        .environmentObject(favoritesManager)
        .padding()
    }
}

#Preview {
    HomeView().environmentObject(FavoritesManager())
}
