import SwiftUI
import WidgetKit

struct PetWidgetView: View {
    let pet: Pet
    let upcomingEvents: [Event]
    let overdueVaccinations: [Vaccination]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                PetImageView(pet: pet, size: 40)
                
                VStack(alignment: .leading) {
                    Text(pet.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(pet.species.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            if !upcomingEvents.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Próximos eventos")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ForEach(upcomingEvents.prefix(2)) { event in
                        HStack {
                            Image(systemName: "calendar")
                                .font(.caption2)
                                .foregroundColor(.blue)
                            
                            Text(event.title)
                                .font(.caption)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text(event.date, style: .date)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            if !overdueVaccinations.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Vacunas pendientes")
                        .font(.caption)
                        .foregroundColor(.red)
                    
                    ForEach(overdueVaccinations.prefix(2)) { vaccination in
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.caption2)
                                .foregroundColor(.red)
                            
                            Text(vaccination.name)
                                .font(.caption)
                                .lineLimit(1)
                            
                            Spacer()
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

struct PetWidgetEntryView: View {
    let entry: PetWidgetEntry
    
    var body: some View {
        PetWidgetView(
            pet: entry.pet,
            upcomingEvents: entry.upcomingEvents,
            overdueVaccinations: entry.overdueVaccinations
        )
    }
}

struct PetWidgetEntry: TimelineEntry {
    let date: Date
    let pet: Pet
    let upcomingEvents: [Event]
    let overdueVaccinations: [Vaccination]
}

struct PetWidgetTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> PetWidgetEntry {
        PetWidgetEntry(
            date: Date(),
            pet: Pet(
                name: "Mascota",
                species: .dog,
                breed: "Raza",
                birthDate: Date(),
                weight: 0,
                color: "Color",
                ownerName: "Dueño",
                ownerPhone: "",
                ownerEmail: ""
            ),
            upcomingEvents: [],
            overdueVaccinations: []
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PetWidgetEntry) -> Void) {
        // Implementation for widget snapshot
        completion(placeholder(in: context))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<PetWidgetEntry>) -> Void) {
        // Implementation for widget timeline
        let entry = placeholder(in: context)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct PetWidget: Widget {
    let kind: String = "PetWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PetWidgetTimelineProvider()) { entry in
            PetWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Mascota")
        .description("Información de tu mascota y eventos próximos")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
} 