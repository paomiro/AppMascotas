import SwiftUI

struct APIStatusView: View {
    @ObservedObject var petStore: PetStore
    @State private var isRefreshing = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Loading indicator
            if petStore.isLoading {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Conectando con el servidor...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
            
            // Error message
            if let errorMessage = petStore.errorMessage {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Error de conexión")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Button("Reintentar") {
                            Task {
                                await refreshData()
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        
                        Button("Ignorar") {
                            petStore.errorMessage = nil
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
            }
            
            // Connection status
            HStack {
                Image(systemName: "wifi")
                    .foregroundColor(petStore.errorMessage == nil ? .green : .gray)
                Text(petStore.errorMessage == nil ? "Conectado" : "Sin conexión")
                    .font(.caption)
                    .foregroundColor(petStore.errorMessage == nil ? .green : .gray)
                Spacer()
                
                if !petStore.isLoading && petStore.errorMessage == nil {
                    Button("Actualizar") {
                        Task {
                            await refreshData()
                        }
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func refreshData() async {
        isRefreshing = true
        await petStore.loadPetsFromAPI()
        await petStore.loadPostsFromAPI()
        isRefreshing = false
    }
}

#Preview {
    APIStatusView(petStore: PetStore())
} 