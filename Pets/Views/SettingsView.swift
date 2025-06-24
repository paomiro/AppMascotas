import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var petStore: PetStore
    @State private var notificationsEnabled = false
    @State private var healthKitEnabled = false
    @State private var showingNotificationSettings = false
    @State private var showingHealthKitSettings = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Notificaciones")) {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text("Notificaciones Push")
                            Text("Recordatorios de vacunas y eventos")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $notificationsEnabled)
                            .onChange(of: notificationsEnabled) { newValue in
                                if newValue {
                                    NotificationManager.shared.requestPermission()
                                }
                            }
                    }
                    
                    Button("Configurar Notificaciones") {
                        showingNotificationSettings = true
                    }
                    .foregroundColor(.blue)
                }
                
                Section(header: Text("Salud")) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        
                        VStack(alignment: .leading) {
                            Text("HealthKit")
                            Text("Sincronizar datos de actividad")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $healthKitEnabled)
                            .onChange(of: healthKitEnabled) { newValue in
                                if newValue {
                                    HealthKitManager.shared.requestAuthorization()
                                }
                            }
                    }
                    
                    Button("Configurar HealthKit") {
                        showingHealthKitSettings = true
                    }
                    .foregroundColor(.blue)
                }
                
                Section(header: Text("Datos")) {
                    Button("Exportar Datos") {
                        exportData()
                    }
                    .foregroundColor(.blue)
                    
                    Button("Importar Datos") {
                        importData()
                    }
                    .foregroundColor(.blue)
                    
                    Button("Limpiar Todos los Datos") {
                        clearAllData()
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("API y Servidor")) {
                    NavigationLink(destination: APITestView()) {
                        HStack {
                            Image(systemName: "network")
                                .foregroundColor(.blue)
                            Text("Pruebas de API")
                        }
                    }
                    
                    HStack {
                        Image(systemName: "server.rack")
                            .foregroundColor(.blue)
                        Text("Servidor")
                        Spacer()
                        Text(APIConfig.currentEnvironment == .development ? "Desarrollo" : "Producción")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "wifi")
                            .foregroundColor(.blue)
                        Text("URL del Servidor")
                        Spacer()
                        Text(APIConfig.baseURL)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Acerca de")) {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                        Text("Versión")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.blue)
                        Text("Contacto")
                        Spacer()
                        Text("soporte@petsapp.com")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Configuración")
        }
        .sheet(isPresented: $showingNotificationSettings) {
            NotificationSettingsView()
        }
        .sheet(isPresented: $showingHealthKitSettings) {
            HealthKitSettingsView()
        }
    }
    
    private func exportData() {
        // Implementation for data export
        print("Exporting data...")
    }
    
    private func importData() {
        // Implementation for data import
        print("Importing data...")
    }
    
    private func clearAllData() {
        let alert = UIAlertController(
            title: "Limpiar Datos",
            message: "¿Estás seguro de que quieres eliminar todos los datos? Esta acción no se puede deshacer.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { _ in
            petStore.clearAllData()
        })
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(alert, animated: true)
        }
    }
}

struct NotificationSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Tipos de Notificaciones")) {
                    Toggle("Recordatorios de Vacunas", isOn: .constant(true))
                    Toggle("Recordatorios de Eventos", isOn: .constant(true))
                    Toggle("Noticias y Promociones", isOn: .constant(false))
                }
                
                Section(header: Text("Horarios")) {
                    Toggle("Notificaciones Silenciosas", isOn: .constant(false))
                    Toggle("Sonidos", isOn: .constant(true))
                    Toggle("Vibración", isOn: .constant(true))
                }
            }
            .navigationTitle("Notificaciones")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Listo") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct HealthKitSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Tipos de Datos")) {
                    Toggle("Actividad Física", isOn: .constant(true))
                    Toggle("Peso", isOn: .constant(true))
                    Toggle("Visitas al Veterinario", isOn: .constant(true))
                }
                
                Section(header: Text("Sincronización")) {
                    Toggle("Sincronización Automática", isOn: .constant(true))
                    Toggle("Solo con WiFi", isOn: .constant(false))
                }
            }
            .navigationTitle("HealthKit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Listo") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(PetStore())
} 