import SwiftUI

struct HomeView: View {
    @EnvironmentObject var petStore: PetStore
    @State private var showingAddPet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Quick Stats
                    QuickStatsView()
                    
                    // My Pets Section
                    MyPetsSection()
                    
                    // Friends Section
                    FriendsSection()
                    
                    // Upcoming Events
                    UpcomingEventsSection()
                    
                    // Overdue Vaccinations
                    OverdueVaccinationsSection()
                }
                .padding()
            }
            .navigationTitle("Mi Mascota")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddPet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPet) {
                AddPetView()
                    .environmentObject(petStore)
            }
        }
    }
}

struct QuickStatsView: View {
    @EnvironmentObject var petStore: PetStore
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Resumen")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Mascotas",
                    value: "\(petStore.pets.count)",
                    icon: "pawprint.fill",
                    color: .blue
                )
                
                StatCard(
                    title: "Próximos Eventos",
                    value: "\(petStore.getUpcomingEvents().count)",
                    icon: "calendar",
                    color: .green
                )
                
                StatCard(
                    title: "Vacunas Vencidas",
                    value: "\(petStore.getOverdueVaccinations().count)",
                    icon: "exclamationmark.triangle.fill",
                    color: .red
                )
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct MyPetsSection: View {
    @EnvironmentObject var petStore: PetStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Mis Mascotas")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                
                if !petStore.pets.isEmpty {
                    NavigationLink("Ver todas", destination: PetsListView())
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            if petStore.pets.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "pawprint")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("No tienes mascotas registradas")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Agrega tu primera mascota para comenzar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(petStore.pets.prefix(3)) { pet in
                            PetCardView(pet: pet)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct PetCardView: View {
    let pet: Pet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                PetImageView(pet: pet, image: pet.image, size: 40)
                
                Spacer()
            }
            
            Text(pet.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(pet.breed)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("\(pet.age) años")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("\(String(format: "%.1f", pet.weight)) kg")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 150)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct UpcomingEventsSection: View {
    @EnvironmentObject var petStore: PetStore
    
    var body: some View {
        let upcomingEvents = petStore.getUpcomingEvents()
        
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Próximos Eventos")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                
                if !upcomingEvents.isEmpty {
                    NavigationLink("Ver todos", destination: CalendarView())
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            if upcomingEvents.isEmpty {
                Text("No hay eventos próximos")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            } else {
                ForEach(upcomingEvents.prefix(3)) { event in
                    EventRowView(event: event)
                }
            }
        }
    }
}

struct EventRowView: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: event.eventType.icon)
                .font(.title3)
                .foregroundColor(Color(event.eventType.color))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(event.eventType.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(event.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(event.daysUntilEvent) días")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct OverdueVaccinationsSection: View {
    @EnvironmentObject var petStore: PetStore
    
    var body: some View {
        let overdueVaccinations = petStore.getOverdueVaccinations()
        
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Vacunas Vencidas")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                
                if !overdueVaccinations.isEmpty {
                    NavigationLink("Ver todas", destination: VaccinationView())
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            if overdueVaccinations.isEmpty {
                Text("Todas las vacunas están al día")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            } else {
                ForEach(overdueVaccinations.prefix(3), id: \.1.id) { pet, vaccination in
                    VaccinationRowView(pet: pet, vaccination: vaccination)
                }
            }
        }
    }
}

struct VaccinationRowView: View {
    let pet: Pet
    let vaccination: Vaccination
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "syringe")
                .font(.title3)
                .foregroundColor(.red)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(vaccination.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(pet.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Vencida")
                    .font(.caption)
                    .foregroundColor(.red)
                    .fontWeight(.semibold)
                
                if let nextDue = vaccination.nextDueDate {
                    Text(nextDue, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    HomeView()
        .environmentObject(PetStore())
} 