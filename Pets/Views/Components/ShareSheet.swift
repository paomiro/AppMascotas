import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    
    init(activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct PetShareView: View {
    let pet: Pet
    @State private var showingShareSheet = false
    
    var body: some View {
        Button(action: {
            showingShareSheet = true
        }) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.blue)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: createShareContent())
        }
    }
    
    private func createShareContent() -> [Any] {
        var content: [Any] = []
        
        // Add pet information text
        let petInfo = """
        🐾 Información de \(pet.name)
        
        Especie: \(pet.species.rawValue)
        Raza: \(pet.breed)
        Edad: \(pet.age) años
        Peso: \(String(format: "%.1f", pet.weight)) kg
        Color: \(pet.color)
        
        Dueño: \(pet.ownerName)
        Teléfono: \(pet.ownerPhone)
        Email: \(pet.ownerEmail)
        """
        
        content.append(petInfo)
        
        // Add pet image if available
        if let image = pet.image {
            content.append(image)
        }
        
        return content
    }
}

struct VaccinationShareView: View {
    let vaccination: Vaccination
    let pet: Pet
    @State private var showingShareSheet = false
    
    var body: some View {
        Button(action: {
            showingShareSheet = true
        }) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.blue)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: createVaccinationShareContent())
        }
    }
    
    private func createVaccinationShareContent() -> [Any] {
        let vaccinationInfo = """
        💉 Registro de Vacunación
        
        Mascota: \(pet.name)
        Vacuna: \(vaccination.name)
        Fecha: \(vaccination.date.formatted(date: .long, time: .omitted))
        Próxima dosis: \(vaccination.nextDueDate.formatted(date: .long, time: .omitted))
        
        Veterinario: \(vaccination.veterinarian)
        Clínica: \(vaccination.clinic)
        """
        
        return [vaccinationInfo]
    }
}

struct EventShareView: View {
    let event: Event
    let pet: Pet
    @State private var showingShareSheet = false
    
    var body: some View {
        Button(action: {
            showingShareSheet = true
        }) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.blue)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: createEventShareContent())
        }
    }
    
    private func createEventShareContent() -> [Any] {
        let eventInfo = """
        📅 Evento de Mascota
        
        Mascota: \(pet.name)
        Evento: \(event.title)
        Fecha: \(event.date.formatted(date: .long, time: .shortened))
        Tipo: \(event.eventType.rawValue)
        
        Descripción: \(event.description)
        Ubicación: \(event.location)
        Contacto: \(event.contact)
        """
        
        return [eventInfo]
    }
} 