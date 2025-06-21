import Foundation
import SwiftUI

struct Pet: Identifiable, Codable {
    let id = UUID()
    var name: String
    var species: PetSpecies
    var breed: String
    var birthDate: Date
    var weight: Double
    var color: String
    var microchipNumber: String?
    var photoURL: String?
    var imageData: Data?
    var ownerName: String
    var ownerPhone: String
    var ownerEmail: String
    var createdAt: Date = Date()
    
    var age: Int {
        Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
    }
    
    var ageInMonths: Int {
        Calendar.current.dateComponents([.month], from: birthDate, to: Date()).month ?? 0
    }
    
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
}

enum PetSpecies: String, CaseIterable, Codable {
    case dog = "Perro"
    case cat = "Gato"
    case bird = "Ave"
    case rabbit = "Conejo"
    case fish = "Pez"
    case other = "Otro"
    
    var icon: String {
        switch self {
        case .dog: return "dog"
        case .cat: return "cat"
        case .bird: return "bird"
        case .rabbit: return "rabbit"
        case .fish: return "fish"
        case .other: return "pawprint"
        }
    }
} 