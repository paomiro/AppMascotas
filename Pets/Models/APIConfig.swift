import Foundation

struct APIConfig {
    // MARK: - Environment Configuration
    
    enum Environment {
        case development
        case staging
        case production
        
        var baseURL: String {
            switch self {
            case .development:
                return "http://localhost:8080/api"
            case .staging:
                return "https://staging-pets-api.example.com/api"
            case .production:
                return "https://pets-api.example.com/api"
            }
        }
        
        var timeoutInterval: TimeInterval {
            switch self {
            case .development:
                return 30.0
            case .staging, .production:
                return 15.0
            }
        }
    }
    
    // MARK: - Current Configuration
    
    static let currentEnvironment: Environment = .development
    
    static var baseURL: String {
        return currentEnvironment.baseURL
    }
    
    static var timeoutInterval: TimeInterval {
        return currentEnvironment.timeoutInterval
    }
    
    // MARK: - API Endpoints
    
    struct Endpoints {
        static let pets = "/pets"
        static let posts = "/posts"
        static let events = "/events"
        static let vaccinations = "/vaccinations"
        static let news = "/news"
        
        static func pet(id: String) -> String {
            return "\(pets)/\(id)"
        }
        
        static func petImage(id: String) -> String {
            return "\(pets)/\(id)/image"
        }
        
        static func postsByPet(petId: String) -> String {
            return "\(posts)/pet/\(petId)"
        }
        
        static func post(id: String) -> String {
            return "\(posts)/\(id)"
        }
        
        static func postImage(id: String) -> String {
            return "\(posts)/\(id)/image"
        }
    }
    
    // MARK: - Headers
    
    struct Headers {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
        static let accept = "Accept"
        
        static let applicationJSON = "application/json"
        static let multipartFormData = "multipart/form-data"
    }
    
    // MARK: - Error Messages
    
    struct ErrorMessages {
        static let networkError = "Error de conexión. Verifica tu conexión a internet."
        static let serverError = "Error del servidor. Intenta más tarde."
        static let invalidResponse = "Respuesta inválida del servidor."
        static let decodingError = "Error al procesar los datos."
        static let unauthorized = "No autorizado. Inicia sesión nuevamente."
        static let notFound = "Recurso no encontrado."
        static let timeout = "Tiempo de espera agotado."
    }
} 