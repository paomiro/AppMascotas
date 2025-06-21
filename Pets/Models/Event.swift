import Foundation

struct Event: Identifiable, Codable {
    let id = UUID()
    var title: String
    var date: Date
    var eventType: EventType
    var description: String?
    var location: String?
    var contact: String?
    var isCompleted: Bool = false
    var reminderDate: Date?
    var petId: UUID
    
    var isUpcoming: Bool {
        return date > Date()
    }
    
    var daysUntilEvent: Int {
        return Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
    }
}

enum EventType: String, CaseIterable, Codable {
    case veterinary = "Veterinario"
    case grooming = "Peluquería"
    case spa = "Spa"
    case training = "Entrenamiento"
    case vaccination = "Vacunación"
    case checkup = "Revisión"
    case surgery = "Cirugía"
    case other = "Otro"
    
    var icon: String {
        switch self {
        case .veterinary: return "stethoscope"
        case .grooming: return "scissors"
        case .spa: return "sparkles"
        case .training: return "brain.head.profile"
        case .vaccination: return "syringe"
        case .checkup: return "heart.text.square"
        case .surgery: return "cross.case"
        case .other: return "calendar"
        }
    }
    
    var color: String {
        switch self {
        case .veterinary: return "red"
        case .grooming: return "blue"
        case .spa: return "purple"
        case .training: return "green"
        case .vaccination: return "orange"
        case .checkup: return "pink"
        case .surgery: return "red"
        case .other: return "gray"
        }
    }
} 