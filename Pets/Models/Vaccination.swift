import Foundation

struct Vaccination: Identifiable, Codable {
    let id = UUID()
    var name: String
    var date: Date
    var nextDueDate: Date?
    var veterinarian: String
    var clinic: String
    var notes: String?
    var isCompleted: Bool = true
    
    var isOverdue: Bool {
        guard let nextDue = nextDueDate else { return false }
        return Date() > nextDue
    }
    
    var daysUntilDue: Int? {
        guard let nextDue = nextDueDate else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: nextDue).day
    }
}

enum VaccinationType: String, CaseIterable {
    case rabies = "Rabia"
    case dhpp = "DHPP (Parvovirus, Moquillo, Hepatitis, Parainfluenza)"
    case bordetella = "Bordetella (Tos de las Perreras)"
    case lyme = "Lyme"
    case leptospirosis = "Leptospirosis"
    case felineLeukemia = "Leucemia Felina"
    case fvrcp = "FVRCP (Rinotraqueitis, Calicivirus, Panleucopenia)"
    case other = "Otra"
    
    var recommendedInterval: Int {
        switch self {
        case .rabies: return 365
        case .dhpp: return 365
        case .bordetella: return 365
        case .lyme: return 365
        case .leptospirosis: return 365
        case .felineLeukemia: return 365
        case .fvrcp: return 365
        case .other: return 365
        }
    }
} 