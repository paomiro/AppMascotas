import SwiftUI

struct MainTabView: View {
    @StateObject private var petStore = PetStore()
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(petStore)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Inicio")
                }
            
            PetsListView()
                .environmentObject(petStore)
                .tabItem {
                    Image(systemName: "pawprint.fill")
                    Text("Mascotas")
                }
            
            CalendarView()
                .environmentObject(petStore)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendario")
                }
            
            VaccinationView()
                .environmentObject(petStore)
                .tabItem {
                    Image(systemName: "syringe")
                    Text("Vacunas")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
} 