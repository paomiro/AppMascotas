import SwiftUI

struct PetsListView: View {
    @EnvironmentObject var petStore: PetStore
    @State private var showingAddPet = false
    @State private var searchText = ""
    
    var filteredPets: [Pet] {
        if searchText.isEmpty {
            return petStore.pets
        } else {
            return petStore.pets.filter { pet in
                pet.name.localizedCaseInsensitiveContains(searchText) ||
                pet.breed.localizedCaseInsensitiveContains(searchText) ||
                pet.species.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                if filteredPets.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "pawprint")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text(searchText.isEmpty ? "No tienes mascotas registradas" : "No se encontraron mascotas")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        if searchText.isEmpty {
                            Text("Agrega tu primera mascota para comenzar")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(filteredPets) { pet in
                        NavigationLink(destination: PetDetailView(pet: pet)) {
                            PetRowView(pet: pet)
                        }
                    }
                    .onDelete(perform: deletePets)
                }
            }
            .searchable(text: $searchText, prompt: "Buscar mascotas...")
            .navigationTitle("Mis Mascotas")
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
    
    private func deletePets(offsets: IndexSet) {
        for index in offsets {
            let pet = filteredPets[index]
            petStore.deletePet(pet)
        }
    }
}

struct PetRowView: View {
    let pet: Pet
    
    var body: some View {
        HStack(spacing: 12) {
            // Pet Photo
            PetImageView(pet: pet, image: pet.image, size: 50)
            
            // Pet Info
            VStack(alignment: .leading, spacing: 4) {
                Text(pet.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(pet.breed)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("\(pet.age) años")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text("\(String(format: "%.1f", pet.weight)) kg")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Status indicator
            VStack(alignment: .trailing, spacing: 4) {
                Text(pet.species.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct PetDetailView: View {
    let pet: Pet
    @EnvironmentObject var petStore: PetStore
    @State private var showingEditPet = false
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Pet Header
                PetHeaderView(pet: pet, onImageEdit: {
                    showingImagePicker = true
                })
                
                // Quick Actions
                QuickActionsView(pet: pet)
                
                // Pet Information
                PetInfoSection(pet: pet)
                
                // Upcoming Events
                PetEventsSection(pet: pet)
                
                // Vaccination Status
                PetVaccinationSection(pet: pet)
            }
            .padding()
        }
        .navigationTitle(pet.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Compartir") {
                        // Share functionality will be implemented
                    }
                    
                    Button("Editar") {
                        showingEditPet = true
                    }
                    
                    Button("Eliminar", role: .destructive) {
                        petStore.deletePet(pet)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditPet) {
            EditPetView(pet: pet)
                .environmentObject(petStore)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            if let newImage = newImage {
                petStore.updatePetImage(pet, image: newImage)
            }
        }
    }
}

struct PetHeaderView: View {
    let pet: Pet
    let onImageEdit: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Pet Avatar
            PetImageView(
                pet: pet,
                image: pet.image,
                size: 120,
                showEditButton: true,
                onEditTap: onImageEdit
            )
            
            VStack(spacing: 8) {
                Text(pet.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(pet.breed)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct QuickActionsView: View {
    let pet: Pet
    
    var body: some View {
        HStack(spacing: 16) {
            QuickActionButton(
                title: "Agregar Evento",
                icon: "calendar.badge.plus",
                color: .blue
            ) {
                // Action
            }
            
            QuickActionButton(
                title: "Agregar Vacuna",
                icon: "syringe",
                color: .green
            ) {
                // Action
            }
            
            QuickActionButton(
                title: "Ver Historial",
                icon: "clock.arrow.circlepath",
                color: .orange
            ) {
                // Action
            }
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct PetInfoSection: View {
    let pet: Pet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Información")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                InfoRow(title: "Especie", value: pet.species.rawValue)
                InfoRow(title: "Raza", value: pet.breed)
                InfoRow(title: "Edad", value: "\(pet.age) años")
                InfoRow(title: "Peso", value: "\(String(format: "%.1f", pet.weight)) kg")
                InfoRow(title: "Color", value: pet.color)
                if let microchip = pet.microchipNumber {
                    InfoRow(title: "Microchip", value: microchip)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

struct PetEventsSection: View {
    let pet: Pet
    @EnvironmentObject var petStore: PetStore
    
    var body: some View {
        let petEvents = petStore.getEventsForPet(pet.id).filter { $0.isUpcoming }
        
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Próximos Eventos")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                if !petEvents.isEmpty {
                    NavigationLink("Ver todos", destination: CalendarView())
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            if petEvents.isEmpty {
                Text("No hay eventos próximos")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            } else {
                ForEach(petEvents.prefix(3)) { event in
                    EventRowView(event: event)
                }
            }
        }
    }
}

struct PetVaccinationSection: View {
    let pet: Pet
    @EnvironmentObject var petStore: PetStore
    
    var body: some View {
        let petVaccinations = petStore.getVaccinationsForPet(pet.id)
        let overdueVaccinations = petVaccinations.filter { $0.isOverdue }
        
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Estado de Vacunas")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                if !petVaccinations.isEmpty {
                    NavigationLink("Ver todas", destination: VaccinationView())
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            if petVaccinations.isEmpty {
                Text("No hay vacunas registradas")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            } else {
                VStack(spacing: 8) {
                    HStack {
                        Text("Vacunas al día: \(petVaccinations.count - overdueVaccinations.count)")
                            .font(.subheadline)
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        if !overdueVaccinations.isEmpty {
                            Text("\(overdueVaccinations.count) vencidas")
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    if !overdueVaccinations.isEmpty {
                        ForEach(overdueVaccinations.prefix(2)) { vaccination in
                            VaccinationRowView(pet: pet, vaccination: vaccination)
                        }
                    }
                }
            }
        }
    }
}

struct EditPetView: View {
    let pet: Pet
    @EnvironmentObject var petStore: PetStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var species: PetSpecies
    @State private var breed: String
    @State private var birthDate: Date
    @State private var weight: String
    @State private var color: String
    @State private var microchipNumber: String
    @State private var ownerName: String
    @State private var ownerPhone: String
    @State private var ownerEmail: String
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    init(pet: Pet) {
        self.pet = pet
        _name = State(initialValue: pet.name)
        _species = State(initialValue: pet.species)
        _breed = State(initialValue: pet.breed)
        _birthDate = State(initialValue: pet.birthDate)
        _weight = State(initialValue: String(pet.weight))
        _color = State(initialValue: pet.color)
        _microchipNumber = State(initialValue: pet.microchipNumber ?? "")
        _ownerName = State(initialValue: pet.ownerName)
        _ownerPhone = State(initialValue: pet.ownerPhone)
        _ownerEmail = State(initialValue: pet.ownerEmail)
        _selectedImage = State(initialValue: pet.image)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Foto de la Mascota") {
                    HStack {
                        Spacer()
                        PetImageView(
                            pet: pet,
                            image: selectedImage ?? pet.image,
                            size: 120,
                            showEditButton: true
                        ) {
                            showingImagePicker = true
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                }
                
                Section("Información de la Mascota") {
                    TextField("Nombre", text: $name)
                    
                    Picker("Especie", selection: $species) {
                        ForEach(PetSpecies.allCases, id: \.self) { species in
                            Text(species.rawValue).tag(species)
                        }
                    }
                    
                    TextField("Raza", text: $breed)
                    
                    DatePicker("Fecha de Nacimiento", selection: $birthDate, displayedComponents: .date)
                    
                    TextField("Peso (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                    
                    TextField("Color", text: $color)
                    
                    TextField("Número de Microchip (opcional)", text: $microchipNumber)
                }
                
                Section("Información del Dueño") {
                    TextField("Nombre del Dueño", text: $ownerName)
                    
                    TextField("Teléfono", text: $ownerPhone)
                        .keyboardType(.phonePad)
                    
                    TextField("Email", text: $ownerEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("Editar Mascota")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        savePet()
                    }
                    .disabled(name.isEmpty || breed.isEmpty || weight.isEmpty || ownerName.isEmpty)
                }
            }
        }
    }
    
    private func savePet() {
        guard let weightValue = Double(weight) else { return }
        
        var updatedPet = pet
        updatedPet.name = name
        updatedPet.species = species
        updatedPet.breed = breed
        updatedPet.birthDate = birthDate
        updatedPet.weight = weightValue
        updatedPet.color = color
        updatedPet.microchipNumber = microchipNumber.isEmpty ? nil : microchipNumber
        updatedPet.ownerName = ownerName
        updatedPet.ownerPhone = ownerPhone
        updatedPet.ownerEmail = ownerEmail
        
        petStore.updatePet(updatedPet)
        dismiss()
    }
}

#Preview {
    PetsListView()
        .environmentObject(PetStore())
} 