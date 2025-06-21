import Foundation
import SwiftUI

struct News: Identifiable, Codable {
    let id = UUID()
    var title: String
    var content: String
    var imageURL: String?
    var imageData: Data?
    var newsType: NewsType
    var startDate: Date
    var endDate: Date?
    var isActive: Bool = true
    var priority: Int = 0
    var externalLink: String?
    var createdAt: Date = Date()
    
    var isCurrentlyActive: Bool {
        let now = Date()
        return isActive && now >= startDate && (endDate == nil || now <= endDate!)
    }
    
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
}

enum NewsType: String, CaseIterable, Codable {
    case promotion = "Promoción"
    case tip = "Consejo"
    case event = "Evento"
    case emergency = "Emergencia"
    case announcement = "Anuncio"
    
    var icon: String {
        switch self {
        case .promotion: return "tag"
        case .tip: return "lightbulb"
        case .event: return "calendar"
        case .emergency: return "exclamationmark.triangle"
        case .announcement: return "megaphone"
        }
    }
    
    var color: String {
        switch self {
        case .promotion: return "green"
        case .tip: return "blue"
        case .event: return "purple"
        case .emergency: return "red"
        case .announcement: return "orange"
        }
    }
} 