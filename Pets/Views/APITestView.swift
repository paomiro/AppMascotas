import SwiftUI

struct APITestView: View {
    @EnvironmentObject var petStore: PetStore
    @State private var testResults: [String] = []
    @State private var isTesting = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Test Controls
                    VStack(spacing: 12) {
                        Text("Pruebas de API")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 12) {
                            Button("Probar Conexión") {
                                Task {
                                    await testConnection()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            
                            Button("Cargar Mascotas") {
                                Task {
                                    await testLoadPets()
                                }
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Limpiar") {
                                testResults.removeAll()
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Loading indicator
                    if isTesting {
                        HStack {
                            ProgressView()
                            Text("Probando API...")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                    
                    // Test Results
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Resultados")
                            .font(.headline)
                        
                        if testResults.isEmpty {
                            Text("No hay resultados de pruebas")
                                .foregroundColor(.secondary)
                                .italic()
                        } else {
                            ForEach(testResults, id: \.self) { result in
                                Text(result)
                                    .font(.caption)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(Color(.systemGray5))
                                    .cornerRadius(6)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Current Data Status
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Estado Actual")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            StatusRow(label: "Mascotas cargadas", value: "\(petStore.pets.count)")
                            StatusRow(label: "Posts cargados", value: "\(petStore.posts.count)")
                            StatusRow(label: "Estado de conexión", value: petStore.errorMessage == nil ? "Conectado" : "Error")
                            if let error = petStore.errorMessage {
                                StatusRow(label: "Último error", value: error)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Pruebas API")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func testConnection() async {
        isTesting = true
        addResult("🔄 Probando conexión con el servidor...")
        
        do {
            let pets = try await APIService.shared.fetchPets()
            addResult("✅ Conexión exitosa - \(pets.count) mascotas encontradas")
        } catch {
            addResult("❌ Error de conexión: \(error.localizedDescription)")
        }
        
        isTesting = false
    }
    
    private func testLoadPets() async {
        isTesting = true
        addResult("🔄 Cargando mascotas desde el servidor...")
        
        await petStore.loadPetsFromAPI()
        
        if petStore.errorMessage == nil {
            addResult("✅ Mascotas cargadas exitosamente: \(petStore.pets.count)")
        } else {
            addResult("❌ Error cargando mascotas: \(petStore.errorMessage ?? "Error desconocido")")
        }
        
        isTesting = false
    }
    
    private func addResult(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        testResults.append("[\(timestamp)] \(message)")
    }
}

struct StatusRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    APITestView()
        .environmentObject(PetStore())
} 