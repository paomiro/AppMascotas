import Foundation
import SwiftUI
import Combine

class PetStore: ObservableObject {
    @Published var pets: [Pet] = []
    @Published var events: [Event] = []
    @Published var vaccinations: [UUID: [Vaccination]] = [:]
    @Published var news: [News] = []
    @Published var posts: [Post] = []
    @Published var selectedPet: Pet?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let petsKey = "SavedPets"
    private let eventsKey = "SavedEvents"
    private let vaccinationsKey = "SavedVaccinations"
    private let newsKey = "SavedNews"
    private let postsKey = "SavedPosts"
    
    // API Service
    let apiService = APIService.shared
    
    // iOS Integration Managers
    private let notificationManager = NotificationManager.shared
    private let healthKitManager = HealthKitManager.shared
    
    init() {
        loadData()
        loadSampleData()
        setupIOSIntegration()
        
        // Load data from API
        Task {
            await loadPetsFromAPI()
            await loadPostsFromAPI()
        }
    }
    
    private func setupIOSIntegration() {
        // Request notification permissions
        notificationManager.requestPermission()
        
        // Request HealthKit permissions
        healthKitManager.requestAuthorization()
    }
    
    // MARK: - API Integration
    
    @MainActor
    func loadPetsFromAPI() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let apiPets = try await apiService.fetchPets()
            self.pets = apiPets
            saveData() // Save to local storage as backup
        } catch {
            errorMessage = error.localizedDescription
            print("Error loading pets from API: \(error)")
        }
        
        isLoading = false
    }
    
    @MainActor
    func loadPostsFromAPI() async {
        do {
            let apiPosts = try await apiService.fetchPosts()
            self.posts = apiPosts
            saveData() // Save to local storage as backup
        } catch {
            print("Error loading posts from API: \(error)")
        }
    }
    
    // MARK: - Pet Management
    func addPet(_ pet: Pet) {
        pets.append(pet)
        vaccinations[pet.id] = []
        saveData()
        
        // Sync with API
        Task {
            await syncPetToAPI(pet)
        }
    }
    
    func updatePet(_ pet: Pet) {
        if let index = pets.firstIndex(where: { $0.id == pet.id }) {
            pets[index] = pet
            saveData()
            
            // Sync with API
            Task {
                await updatePetInAPI(pet)
            }
        }
    }
    
    func deletePet(_ pet: Pet) {
        pets.removeAll { $0.id == pet.id }
        events.removeAll { $0.petId == pet.id }
        vaccinations.removeValue(forKey: pet.id)
        saveData()
        
        // Sync with API
        Task {
            await deletePetFromAPI(pet.id)
        }
    }
    
    func updatePetImage(_ pet: Pet, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        var updatedPet = pet
        updatedPet.imageData = imageData
        updatePet(updatedPet)
        
        // Upload image to API
        Task {
            await uploadPetImageToAPI(petId: pet.id, imageData: imageData)
        }
    }
    
    // MARK: - API Sync Methods
    
    private func syncPetToAPI(_ pet: Pet) async {
        do {
            let createdPet = try await apiService.createPet(pet)
            // Update local pet with server ID if needed
            if let index = pets.firstIndex(where: { $0.id == pet.id }) {
                await MainActor.run {
                    pets[index].id = createdPet.id
                    saveData()
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "Error syncing pet to server: \(error.localizedDescription)"
            }
        }
    }
    
    private func updatePetInAPI(_ pet: Pet) async {
        do {
            _ = try await apiService.updatePet(pet)
        } catch {
            await MainActor.run {
                errorMessage = "Error updating pet on server: \(error.localizedDescription)"
            }
        }
    }
    
    private func deletePetFromAPI(_ petId: UUID) async {
        do {
            try await apiService.deletePet(id: petId)
        } catch {
            await MainActor.run {
                errorMessage = "Error deleting pet from server: \(error.localizedDescription)"
            }
        }
    }
    
    private func uploadPetImageToAPI(petId: UUID, imageData: Data) async {
        do {
            try await apiService.uploadPetImage(petId: petId, imageData: imageData)
        } catch {
            await MainActor.run {
                errorMessage = "Error uploading pet image: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Event Management
    func addEvent(_ event: Event) {
        events.append(event)
        saveData()
        
        // Schedule iOS notification for the event
        if let pet = pets.first(where: { $0.id == event.petId }) {
            notificationManager.scheduleEventReminder(for: event, pet: pet)
        }
    }
    
    func updateEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
            saveData()
            
            // Update iOS notification
            notificationManager.cancelNotification(with: "event-\(event.id)")
            if let pet = pets.first(where: { $0.id == event.petId }) {
                notificationManager.scheduleEventReminder(for: event, pet: pet)
            }
        }
    }
    
    func deleteEvent(_ event: Event) {
        events.removeAll { $0.id == event.id }
        saveData()
        
        // Cancel iOS notification
        notificationManager.cancelNotification(with: "event-\(event.id)")
    }
    
    func getEventsForPet(_ petId: UUID) -> [Event] {
        return events.filter { $0.petId == petId }
    }
    
    func getUpcomingEvents() -> [Event] {
        return events.filter { $0.isUpcoming }.sorted { $0.date < $1.date }
    }
    
    // MARK: - Vaccination Management
    func addVaccination(_ vaccination: Vaccination, for petId: UUID) {
        if vaccinations[petId] == nil {
            vaccinations[petId] = []
        }
        vaccinations[petId]?.append(vaccination)
        saveData()
        
        // Schedule iOS notification for vaccination reminder
        if let pet = pets.first(where: { $0.id == petId }) {
            notificationManager.scheduleVaccinationReminder(for: vaccination, pet: pet)
        }
    }
    
    func updateVaccination(_ vaccination: Vaccination, for petId: UUID) {
        if let index = vaccinations[petId]?.firstIndex(where: { $0.id == vaccination.id }) {
            vaccinations[petId]?[index] = vaccination
            saveData()
            
            // Update iOS notification
            notificationManager.cancelNotification(with: "vaccination-\(vaccination.id)")
            if let pet = pets.first(where: { $0.id == petId }) {
                notificationManager.scheduleVaccinationReminder(for: vaccination, pet: pet)
            }
        }
    }
    
    func deleteVaccination(_ vaccination: Vaccination, for petId: UUID) {
        vaccinations[petId]?.removeAll { $0.id == vaccination.id }
        saveData()
        
        // Cancel iOS notification
        notificationManager.cancelNotification(with: "vaccination-\(vaccination.id)")
    }
    
    func getVaccinationsForPet(_ petId: UUID) -> [Vaccination] {
        return vaccinations[petId] ?? []
    }
    
    func getOverdueVaccinations() -> [(Pet, Vaccination)] {
        var overdue: [(Pet, Vaccination)] = []
        for pet in pets {
            let petVaccinations = getVaccinationsForPet(pet.id)
            for vaccination in petVaccinations where vaccination.isOverdue {
                overdue.append((pet, vaccination))
            }
        }
        return overdue
    }
    
    // MARK: - iOS HealthKit Integration
    func savePetActivity(petId: UUID, steps: Int, date: Date = Date()) {
        healthKitManager.savePetActivity(petId: petId, steps: steps, date: date)
    }
    
    func getPetActivity(for date: Date = Date()) -> Int {
        return healthKitManager.getPetActivity(for: date)
    }
    
    // MARK: - iOS Widget Support
    func getWidgetData(for petId: UUID) -> (Pet, [Event], [Vaccination])? {
        guard let pet = pets.first(where: { $0.id == petId }) else { return nil }
        let petEvents = getEventsForPet(petId).filter { $0.isUpcoming }.prefix(3).map { $0 }
        let petVaccinations = getVaccinationsForPet(petId).filter { $0.isOverdue }
        return (pet, Array(petEvents), petVaccinations)
    }
    
    // MARK: - News Management
    func addNews(_ newsItem: News) {
        news.append(newsItem)
        saveData()
    }
    
    func updateNews(_ newsItem: News) {
        if let index = news.firstIndex(where: { $0.id == newsItem.id }) {
            news[index] = newsItem
            saveData()
        }
    }
    
    func updateNewsImage(_ newsItem: News, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        var updatedNews = newsItem
        updatedNews.imageData = imageData
        updateNews(updatedNews)
    }
    
    func deleteNews(_ newsItem: News) {
        news.removeAll { $0.id == newsItem.id }
        saveData()
    }
    
    func getActiveNews() -> [News] {
        return news.filter { $0.isCurrentlyActive }.sorted { $0.priority > $1.priority }
    }
    
    // MARK: - Posts Management
    func addPost(_ post: Post) {
        posts.append(post)
        saveData()
        
        // Sync with API
        Task {
            await syncPostToAPI(post)
        }
    }
    
    func updatePost(_ post: Post) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index] = post
            saveData()
        }
    }
    
    func deletePost(_ post: Post) {
        posts.removeAll { $0.id == post.id }
        saveData()
        
        // Sync with API
        Task {
            await deletePostFromAPI(post.id)
        }
    }
    
    func likePost(_ post: Post, by petId: UUID) {
        var updatedPost = post
        if updatedPost.likes.contains(petId) {
            updatedPost.likes.removeAll { $0 == petId }
        } else {
            updatedPost.likes.append(petId)
        }
        updatePost(updatedPost)
    }
    
    func getPostsForPet(_ petId: UUID) -> [Post] {
        return posts.filter { $0.petId == petId }.sorted { $0.createdAt > $1.createdAt }
    }
    
    func getAllPosts() -> [Post] {
        return posts.sorted { $0.createdAt > $1.createdAt }
    }
    
    // MARK: - Posts API Integration
    
    private func syncPostToAPI(_ post: Post) async {
        guard let imageData = post.imageData else { return }
        
        do {
            let createdPost = try await apiService.createPost(petId: post.petId, imageData: imageData)
            // Update local post with server ID if needed
            if let index = posts.firstIndex(where: { $0.id == post.id }) {
                await MainActor.run {
                    posts[index].id = createdPost.id
                    saveData()
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "Error syncing post to server: \(error.localizedDescription)"
            }
        }
    }
    
    private func deletePostFromAPI(_ postId: UUID) async {
        do {
            try await apiService.deletePost(id: postId)
        } catch {
            await MainActor.run {
                errorMessage = "Error deleting post from server: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Data Management
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: petsKey)
        UserDefaults.standard.removeObject(forKey: eventsKey)
        UserDefaults.standard.removeObject(forKey: vaccinationsKey)
        UserDefaults.standard.removeObject(forKey: newsKey)
        UserDefaults.standard.removeObject(forKey: postsKey)
        
        pets = []
        events = []
        vaccinations = [:]
        news = []
        posts = []
        
        loadSampleData()
    }
    
    // MARK: - Data Persistence
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(pets) {
            UserDefaults.standard.set(encoded, forKey: petsKey)
        }
        
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: eventsKey)
        }
        
        if let encoded = try? JSONEncoder().encode(vaccinations) {
            UserDefaults.standard.set(encoded, forKey: vaccinationsKey)
        }
        
        if let encoded = try? JSONEncoder().encode(news) {
            UserDefaults.standard.set(encoded, forKey: newsKey)
        }
        
        if let encoded = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(encoded, forKey: postsKey)
        }
    }
    
    private func loadData() {
        if let petsData = UserDefaults.standard.data(forKey: petsKey),
           let decodedPets = try? JSONDecoder().decode([Pet].self, from: petsData) {
            pets = decodedPets
        }
        
        if let eventsData = UserDefaults.standard.data(forKey: eventsKey),
           let decodedEvents = try? JSONDecoder().decode([Event].self, from: eventsData) {
            events = decodedEvents
        }
        
        if let vaccinationsData = UserDefaults.standard.data(forKey: vaccinationsKey),
           let decodedVaccinations = try? JSONDecoder().decode([UUID: [Vaccination]].self, from: vaccinationsData) {
            vaccinations = decodedVaccinations
        }
        
        if let newsData = UserDefaults.standard.data(forKey: newsKey),
           let decodedNews = try? JSONDecoder().decode([News].self, from: newsData) {
            news = decodedNews
        }
        
        if let postsData = UserDefaults.standard.data(forKey: postsKey),
           let decodedPosts = try? JSONDecoder().decode([Post].self, from: postsData) {
            posts = decodedPosts
        }
    }
    
    private func loadSampleData() {
        // Only load sample data if no pets exist
        guard pets.isEmpty else { return }
        
        // Sample pet
        let samplePet = Pet(
            name: "Dalila",
            species: .dog,
            breed: "Maltés",
            birthDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date(),
            weight: 3.5,
            color: "Blanco",
            ownerName: "María García",
            ownerPhone: "+52 55 1234 5678",
            ownerEmail: "maria@example.com"
        )
        
        addPet(samplePet)
        
        // Sample vaccinations
        let rabiesVaccination = Vaccination(
            name: "Rabia",
            date: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(),
            nextDueDate: Calendar.current.date(byAdding: .month, value: 6, to: Date()),
            veterinarian: "Dr. Carlos López",
            clinic: "Clínica Veterinaria Central"
        )
        
        addVaccination(rabiesVaccination, for: samplePet.id)
        
        // Sample events
        let vetAppointment = Event(
            title: "Revisión anual",
            date: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
            eventType: .veterinary,
            description: "Revisión general y vacunas",
            location: "Clínica Veterinaria Central",
            contact: "Dr. Carlos López",
            petId: samplePet.id
        )
        
        addEvent(vetAppointment)
        
        // Sample news
        let sampleNews = News(
            title: "¡Promoción especial!",
            content: "20% de descuento en baños y cortes de pelo para perros grandes",
            newsType: .promotion,
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .weekOfYear, value: 2, to: Date()),
            priority: 1
        )
        
        addNews(sampleNews)
        
        // Sample posts
        let samplePost1 = Post(
            petId: samplePet.id,
            petName: samplePet.name,
            petImageData: samplePet.imageData
        )
        
        let samplePost2 = Post(
            petId: samplePet.id,
            petName: samplePet.name,
            petImageData: samplePet.imageData
        )
        
        addPost(samplePost1)
        addPost(samplePost2)
    }
} 