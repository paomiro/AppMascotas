import Foundation
import SwiftUI

struct Post: Identifiable, Codable {
    var id = UUID()
    var petId: UUID
    var petName: String
    var petImageData: Data?
    var imageData: Data?
    var createdAt: Date = Date()
    var likes: [UUID] = [] // Array of user IDs who liked the post
    
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    var petImage: UIImage? {
        if let petImageData = petImageData {
            return UIImage(data: petImageData)
        }
        return nil
    }
    
    var likeCount: Int {
        return likes.count
    }
    
    // Custom initializer for API integration
    init(petId: UUID, imageData: Data? = nil, createdAt: Date = Date(), likedBy: [UUID] = []) {
        self.petId = petId
        self.imageData = imageData
        self.createdAt = createdAt
        self.likes = likedBy
        self.petName = "" // Will be set when needed
        self.petImageData = nil // Will be set when needed
    }
}

struct Comment: Identifiable, Codable {
    let id = UUID()
    var petId: UUID
    var petName: String
    var petImageData: Data?
    var content: String
    var createdAt: Date = Date()
    
    var petImage: UIImage? {
        if let petImageData = petImageData {
            return UIImage(data: petImageData)
        }
        return nil
    }
} 