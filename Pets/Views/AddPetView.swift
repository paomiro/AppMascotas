import SwiftUI

struct AddPetView: View {
    @EnvironmentObject var petStore: PetStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var species = PetSpecies.dog
    @State private var breed = ""
    @State private var birthDate = Date()
    @State private var weight = ""
    @State private var color = ""
    @State private var microchipNumber = ""
    @State private var ownerName = ""
    @State private var ownerPhone = ""
    @State private var ownerEmail = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Foto de la Mascota") {
                    HStack {
                        Spacer()
                        PetImageView(
                            pet: Pet(
                                name: name.isEmpty ? "Mascota" : name,
                                species: species,
                                breed: breed,
                                birthDate: birthDate,
                                weight: Double(weight) ?? 0,
                                color: color,
                                ownerName: ownerName,
                                ownerPhone: ownerPhone,
                                ownerEmail: ownerEmail
                            ),
                            image: selectedImage,
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
            .navigationTitle("Agregar Mascota")
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
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    private func savePet() {
        guard let weightValue = Double(weight) else { return }
        
        var pet = Pet(
            name: name,
            species: species,
            breed: breed,
            birthDate: birthDate,
            weight: weightValue,
            color: color,
            microchipNumber: microchipNumber.isEmpty ? nil : microchipNumber,
            ownerName: ownerName,
            ownerPhone: ownerPhone,
            ownerEmail: ownerEmail
        )
        
        // Add image data if selected
        if let selectedImage = selectedImage,
           let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
            pet.imageData = imageData
        }
        
        petStore.addPet(pet)
        dismiss()
    }
}

#Preview {
    AddPetView()
        .environmentObject(PetStore())
} 