import Foundation
import UIKit
import Combine

class APIService: ObservableObject {
    static let shared = APIService()
    
    private let baseURL = APIConfig.baseURL
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = APIConfig.timeoutInterval
        config.timeoutIntervalForResource = APIConfig.timeoutInterval
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Pet API Methods
    
    func fetchPets() async throws -> [Pet] {
        let url = URL(string: "\(baseURL)\(APIConfig.Endpoints.pets)")!
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        switch httpResponse.statusCode {
        case 200:
            let petDTOs = try JSONDecoder().decode([PetDTO].self, from: data)
            return petDTOs.map { $0.toPet() }
        case 404:
            throw APIError.notFound
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.invalidResponse
        }
    }
    
    func fetchPetsByOwner(email: String) async throws -> [Pet] {
        let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email
        let url = URL(string: "\(baseURL)\(APIConfig.Endpoints.pets)/owner/\(encodedEmail)")!
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        switch httpResponse.statusCode {
        case 200:
            let petDTOs = try JSONDecoder().decode([PetDTO].self, from: data)
            return petDTOs.map { $0.toPet() }
        case 404:
            return [] // No pets found for this owner
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.invalidResponse
        }
    }
    
    func createPet(_ pet: Pet) async throws -> Pet {
        let url = URL(string: "\(baseURL)\(APIConfig.Endpoints.pets)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(APIConfig.Headers.applicationJSON, forHTTPHeaderField: APIConfig.Headers.contentType)
        
        let petDTO = PetDTO(from: pet)
        let jsonData = try JSONEncoder().encode(petDTO)
        request.httpBody = jsonData
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        switch httpResponse.statusCode {
        case 201:
            let createdPetDTO = try JSONDecoder().decode(PetDTO.self, from: data)
            return createdPetDTO.toPet()
        case 400:
            throw APIError.invalidRequest
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.invalidResponse
        }
    }
    
    func updatePet(_ pet: Pet) async throws -> Pet {
        let url = URL(string: "\(baseURL)\(APIConfig.Endpoints.pet(id: pet.id.uuidString))")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(APIConfig.Headers.applicationJSON, forHTTPHeaderField: APIConfig.Headers.contentType)
        
        let petDTO = PetDTO(from: pet)
        let jsonData = try JSONEncoder().encode(petDTO)
        request.httpBody = jsonData
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        switch httpResponse.statusCode {
        case 200:
            let updatedPetDTO = try JSONDecoder().decode(PetDTO.self, from: data)
            return updatedPetDTO.toPet()
        case 404:
            throw APIError.notFound
        case 400:
            throw APIError.invalidRequest
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.invalidResponse
        }
    }
    
    func deletePet(id: UUID) async throws {
        let url = URL(string: "\(baseURL)\(APIConfig.Endpoints.pet(id: id.uuidString))")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        switch httpResponse.statusCode {
        case 204:
            return // Success
        case 404:
            throw APIError.notFound
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.invalidResponse
        }
    }
    
    func uploadPetImage(petId: UUID, imageData: Data) async throws {
        let url = URL(string: "\(baseURL)\(APIConfig.Endpoints.petImage(id: petId.uuidString))")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("\(APIConfig.Headers.multipartFormData); boundary=\(boundary)", forHTTPHeaderField: APIConfig.Headers.contentType)
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"pet.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        switch httpResponse.statusCode {
        case 200:
            return // Success
        case 404:
            throw APIError.notFound
        case 400:
            throw APIError.invalidRequest
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.invalidResponse
        }
    }
    
    func fetchPetImage(petId: UUID) async throws -> Data? {
        let url = URL(string: "\(baseURL)\(APIConfig.Endpoints.petImage(id: petId.uuidString))")!
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        switch httpResponse.statusCode {
        case 200:
            return data
        case 404:
            return nil // No image found
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.invalidResponse
        }
    }
    
    // MARK: - Post API Methods
    
    func fetchPosts(page: Int = 0, size: Int = 10) async throws -> [Post] {
        let url = URL(string: "\(baseURL)\(APIConfig.Endpoints.posts)?page=\(page)&size=\(size)")!
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        switch httpResponse.statusCode {
        case 200:
            let responseData = try JSONDecoder().decode(PostResponse.self, from: data)
            return responseData.posts.map { $0.toPost() }
        case 404:
            return [] // No posts found
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.invalidResponse
        }
    }
    
    func fetchPostsByPet(petId: UUID) async throws -> [Post] {
        let url = URL(string: "\(baseURL)\(APIConfig.Endpoints.postsByPet(petId: petId.uuidString))")!
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        switch httpResponse.statusCode {
        case 200:
            let postDTOs = try JSONDecoder().decode([PostDTO].self, from: data)
            return postDTOs.map { $0.toPost() }
        case 404:
            return [] // No posts found for this pet
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.invalidResponse
        }
    }
    
    func createPost(petId: UUID, imageData: Data) async throws -> Post {
        let url = URL(string: "\(baseURL)\(APIConfig.Endpoints.posts)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("\(APIConfig.Headers.multipartFormData); boundary=\(boundary)", forHTTPHeaderField: APIConfig.Headers.contentType)
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"petId\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(petId)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"post.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        switch httpResponse.statusCode {
        case 201:
            let postDTO = try JSONDecoder().decode(PostDTO.self, from: data)
            return postDTO.toPost()
        case 400:
            throw APIError.invalidRequest
        case 404:
            throw APIError.notFound
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.invalidResponse
        }
    }
    
    func deletePost(id: UUID) async throws {
        let url = URL(string: "\(baseURL)\(APIConfig.Endpoints.post(id: id.uuidString))")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        switch httpResponse.statusCode {
        case 204:
            return // Success
        case 404:
            throw APIError.notFound
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.invalidResponse
        }
    }
}

// MARK: - Data Transfer Objects

struct PetDTO: Codable {
    let id: String?
    let name: String
    let species: String
    let breed: String
    let birthDate: String
    let weight: Double
    let color: String
    let microchipNumber: String?
    let photoUrl: String?
    let imageData: Data?
    let ownerName: String
    let ownerPhone: String
    let ownerEmail: String
    let age: Int?
    let ageInMonths: Int?
    
    func toPet() -> Pet {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthDate = dateFormatter.date(from: self.birthDate) ?? Date()
        
        let species = PetSpecies(rawValue: self.species) ?? .other
        
        return Pet(
            name: name,
            species: species,
            breed: breed,
            birthDate: birthDate,
            weight: weight,
            color: color,
            microchipNumber: microchipNumber,
            photoURL: photoUrl,
            imageData: imageData,
            ownerName: ownerName,
            ownerPhone: ownerPhone,
            ownerEmail: ownerEmail
        )
    }
    
    init(from pet: Pet) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.id = pet.id.uuidString
        self.name = pet.name
        self.species = pet.species.rawValue
        self.breed = pet.breed
        self.birthDate = dateFormatter.string(from: pet.birthDate)
        self.weight = pet.weight
        self.color = pet.color
        self.microchipNumber = pet.microchipNumber
        self.photoUrl = pet.photoURL
        self.imageData = pet.imageData
        self.ownerName = pet.ownerName
        self.ownerPhone = pet.ownerPhone
        self.ownerEmail = pet.ownerEmail
        self.age = pet.age
        self.ageInMonths = pet.ageInMonths
    }
}

struct PostDTO: Codable {
    let id: String?
    let petId: String?
    let imageData: Data?
    let createdAt: String?
    let likedBy: [String]?
    
    func toPost() -> Post {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        let createdAt = dateFormatter.date(from: self.createdAt ?? "") ?? Date()
        
        return Post(
            petId: UUID(uuidString: petId ?? "") ?? UUID(),
            imageData: imageData,
            createdAt: createdAt,
            likedBy: likedBy?.compactMap { UUID(uuidString: $0) } ?? []
        )
    }
}

struct PostResponse: Codable {
    let posts: [PostDTO]
    let currentPage: Int
    let totalItems: Int
    let totalPages: Int
}

// MARK: - Error Types

enum APIError: Error, LocalizedError {
    case invalidResponse
    case networkError
    case decodingError
    case notFound
    case serverError
    case invalidRequest
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Respuesta inválida del servidor"
        case .networkError:
            return "Error de conexión"
        case .decodingError:
            return "Error al procesar los datos"
        case .notFound:
            return "Recurso no encontrado"
        case .serverError:
            return "Error del servidor"
        case .invalidRequest:
            return "Solicitud inválida"
        }
    }
} 