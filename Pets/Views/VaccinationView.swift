import SwiftUI

struct VaccinationView: View {
    @EnvironmentObject var petStore: PetStore
    @State private var showingAddVaccination = false
    @State private var selectedPet: Pet?
    @State private var filterStatus: VaccinationFilter = .all
    
    enum VaccinationFilter: String, CaseIterable {
        case all = "Todas"
        case overdue = "Vencidas"
        case upcoming = "Próximas"
        case completed = "Completadas"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filter Picker
                Picker("Filtro", selection: $filterStatus) {
                    ForEach(VaccinationFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Vaccination List
                VaccinationListView(
                    vaccinations: filteredVaccinations,
                    filterStatus: filterStatus,
                    onDelete: deleteVaccination
                )
            }
            .navigationTitle("Vacunas")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddVaccination = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddVaccination) {
                AddVaccinationView(selectedPet: selectedPet)
                    .environmentObject(petStore)
            }
        }
    }
    
    private var filteredVaccinations: [(Pet, Vaccination)] {
        var allVaccinations: [(Pet, Vaccination)] = []
        
        for pet in petStore.pets {
            let petVaccinations = petStore.getVaccinationsForPet(pet.id)
            for vaccination in petVaccinations {
                allVaccinations.append((pet, vaccination))
            }
        }
        
        switch filterStatus {
        case .all:
            return allVaccinations.sorted { $0.1.date > $1.1.date }
        case .overdue:
            return allVaccinations.filter { $0.1.isOverdue }.sorted { $0.1.date > $1.1.date }
        case .upcoming:
            return allVaccinations.filter { vaccination in
                guard let nextDue = vaccination.1.nextDueDate else { return false }
                let daysUntilDue = Calendar.current.dateComponents([.day], from: Date(), to: nextDue).day ?? 0
                return daysUntilDue > 0 && daysUntilDue <= 30
            }.sorted { $0.1.nextDueDate ?? Date() < $1.1.nextDueDate ?? Date() }
        case .completed:
            return allVaccinations.filter { !$0.1.isOverdue && ($0.1.nextDueDate == nil || $0.1.nextDueDate! <= Date()) }
                .sorted { $0.1.date > $1.1.date }
        }
    }
    
    private func deleteVaccination(_ vaccination: Vaccination, for pet: Pet) {
        petStore.deleteVaccination(vaccination, for: pet.id)
    }
}

struct VaccinationListView: View {
    let vaccinations: [(Pet, Vaccination)]
    let filterStatus: VaccinationView.VaccinationFilter
    let onDelete: (Vaccination, Pet) -> Void
    
    var body: some View {
        if vaccinations.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "syringe")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                
                Text(emptyStateMessage)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(emptyStateSubtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGray6))
        } else {
            List {
                ForEach(vaccinations, id: \.1.id) { pet, vaccination in
                    VaccinationRowView(pet: pet, vaccination: vaccination)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let (pet, vaccination) = vaccinations[index]
                        onDelete(vaccination, pet)
                    }
                }
            }
        }
    }
    
    private var emptyStateMessage: String {
        switch filterStatus {
        case .all:
            return "No hay vacunas registradas"
        case .overdue:
            return "No hay vacunas vencidas"
        case .upcoming:
            return "No hay vacunas próximas"
        case .completed:
            return "No hay vacunas completadas"
        }
    }
    
    private var emptyStateSubtitle: String {
        switch filterStatus {
        case .all:
            return "Agrega la primera vacuna de tu mascota"
        case .overdue:
            return "¡Excelente! Todas las vacunas están al día"
        case .upcoming:
            return "No hay vacunas programadas para los próximos 30 días"
        case .completed:
            return "No hay vacunas completadas"
        }
    }
}

struct VaccinationStatusBadge: View {
    let vaccination: Vaccination
    
    var body: some View {
        if vaccination.isOverdue {
            Text("VENCIDA")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.red)
                .cornerRadius(8)
        } else if let daysUntilDue = vaccination.daysUntilDue {
            if daysUntilDue <= 7 {
                Text("URGENTE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange)
                    .cornerRadius(8)
            } else if daysUntilDue <= 30 {
                Text("PRÓXIMA")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .cornerRadius(8)
            } else {
                Text("AL DÍA")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green)
                    .cornerRadius(8)
            }
        } else {
            Text("COMPLETADA")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gray)
                .cornerRadius(8)
        }
    }
}

struct AddVaccinationView: View {
    let selectedPet: Pet?
    @EnvironmentObject var petStore: PetStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPetId: UUID?
    @State private var vaccinationName = ""
    @State private var vaccinationDate = Date()
    @State private var veterinarian = ""
    @State private var clinic = ""
    @State private var notes = ""
    @State private var hasNextDue = false
    @State private var nextDueDate = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Mascota") {
                    Picker("Mascota", selection: $selectedPetId) {
                        Text("Seleccionar mascota").tag(nil as UUID?)
                        ForEach(petStore.pets) { pet in
                            Text(pet.name).tag(pet.id as UUID?)
                        }
                    }
                }
                
                Section("Detalles de la Vacuna") {
                    TextField("Nombre de la vacuna", text: $vaccinationName)
                    
                    DatePicker("Fecha de aplicación", selection: $vaccinationDate, displayedComponents: .date)
                    
                    TextField("Veterinario", text: $veterinarian)
                    
                    TextField("Clínica", text: $clinic)
                    
                    TextField("Notas (opcional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Próxima dosis") {
                    Toggle("Programar próxima dosis", isOn: $hasNextDue)
                    
                    if hasNextDue {
                        DatePicker("Fecha próxima dosis", selection: $nextDueDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Agregar Vacuna")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        saveVaccination()
                    }
                    .disabled(vaccinationName.isEmpty || veterinarian.isEmpty || clinic.isEmpty || selectedPetId == nil)
                }
            }
            .onAppear {
                if let pet = selectedPet {
                    selectedPetId = pet.id
                }
            }
        }
    }
    
    private func saveVaccination() {
        guard let petId = selectedPetId else { return }
        
        let vaccination = Vaccination(
            name: vaccinationName,
            date: vaccinationDate,
            nextDueDate: hasNextDue ? nextDueDate : nil,
            veterinarian: veterinarian,
            clinic: clinic,
            notes: notes.isEmpty ? nil : notes
        )
        
        petStore.addVaccination(vaccination, for: petId)
        dismiss()
    }
}

#Preview {
    VaccinationView()
        .environmentObject(PetStore())
} 