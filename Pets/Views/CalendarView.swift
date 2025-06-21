import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var petStore: PetStore
    @State private var selectedDate = Date()
    @State private var showingAddEvent = false
    @State private var selectedPet: Pet?
    @State private var filterEventType: EventType?
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter
    }()
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Calendar Header
                CalendarHeaderView(
                    selectedDate: $selectedDate,
                    monthFormatter: monthFormatter
                )
                
                // Calendar Grid
                CalendarGridView(
                    selectedDate: $selectedDate,
                    events: petStore.events,
                    dateFormatter: dateFormatter
                )
                
                // Events List
                EventsListView(
                    selectedDate: selectedDate,
                    events: filteredEvents,
                    onDelete: deleteEvent
                )
            }
            .navigationTitle("Calendario")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEvent = true }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Todos los eventos") {
                            filterEventType = nil
                        }
                        
                        ForEach(EventType.allCases, id: \.self) { eventType in
                            Button(eventType.rawValue) {
                                filterEventType = eventType
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAddEvent) {
                AddEventView(selectedPet: selectedPet)
                    .environmentObject(petStore)
            }
        }
    }
    
    private var filteredEvents: [Event] {
        let eventsForDate = petStore.events.filter { event in
            calendar.isDate(event.date, inSameDayAs: selectedDate)
        }
        
        if let filterType = filterEventType {
            return eventsForDate.filter { $0.eventType == filterType }
        }
        
        return eventsForDate
    }
    
    private func deleteEvent(_ event: Event) {
        petStore.deleteEvent(event)
    }
}

struct CalendarHeaderView: View {
    @Binding var selectedDate: Date
    let monthFormatter: DateFormatter
    
    var body: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Text(monthFormatter.string(from: selectedDate).capitalized)
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    private func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    let events: [Event]
    let dateFormatter: DateFormatter
    
    private let calendar = Calendar.current
    private let daysInWeek = ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Day headers
            HStack(spacing: 0) {
                ForEach(daysInWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
            }
            .background(Color(.systemGray5))
            
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        CalendarDayView(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            hasEvents: hasEvents(for: date),
                            dateFormatter: dateFormatter
                        )
                        .onTapGesture {
                            selectedDate = date
                        }
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
        }
        .background(Color(.systemGray6))
    }
    
    private var daysInMonth: [Date?] {
        let startOfMonth = calendar.dateInterval(of: .month, for: selectedDate)?.start ?? selectedDate
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let daysInMonth = calendar.range(of: .day, in: .month, for: selectedDate)?.count ?? 0
        
        var days: [Date?] = []
        
        // Add empty cells for days before the first day of the month
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        // Add all days of the month
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func hasEvents(for date: Date) -> Bool {
        return events.contains { event in
            calendar.isDate(event.date, inSameDayAs: date)
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasEvents: Bool
    let dateFormatter: DateFormatter
    
    var body: some View {
        VStack(spacing: 2) {
            Text(dateFormatter.string(from: date))
                .font(.caption)
                .fontWeight(isSelected ? .bold : .medium)
                .foregroundColor(isSelected ? .white : .primary)
            
            if hasEvents {
                Circle()
                    .fill(isSelected ? .white : .blue)
                    .frame(width: 4, height: 4)
            }
        }
        .frame(height: 40)
        .background(isSelected ? Color.blue : Color.clear)
        .cornerRadius(8)
    }
}

struct EventsListView: View {
    let selectedDate: Date
    let events: [Event]
    let onDelete: (Event) -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d 'de' MMMM"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(dateFormatter.string(from: selectedDate).capitalized)
                .font(.headline)
                .padding(.horizontal)
            
            if events.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "calendar")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("No hay eventos para este día")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                List {
                    ForEach(events) { event in
                        EventDetailRowView(event: event)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            onDelete(events[index])
                        }
                    }
                }
            }
        }
    }
}

struct EventDetailRowView: View {
    let event: Event
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: event.eventType.icon)
                .font(.title3)
                .foregroundColor(Color(event.eventType.color))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(event.eventType.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let location = event.location {
                    Text(location)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(timeFormatter.string(from: event.date))
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if let contact = event.contact {
                    Text(contact)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddEventView: View {
    let selectedPet: Pet?
    @EnvironmentObject var petStore: PetStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var eventType = EventType.veterinary
    @State private var date = Date()
    @State private var description = ""
    @State private var location = ""
    @State private var contact = ""
    @State private var selectedPetId: UUID?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Detalles del Evento") {
                    TextField("Título", text: $title)
                    
                    Picker("Tipo de Evento", selection: $eventType) {
                        ForEach(EventType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    DatePicker("Fecha y Hora", selection: $date)
                    
                    TextField("Descripción (opcional)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Ubicación y Contacto") {
                    TextField("Ubicación (opcional)", text: $location)
                    TextField("Contacto (opcional)", text: $contact)
                }
                
                Section("Mascota") {
                    Picker("Mascota", selection: $selectedPetId) {
                        Text("Seleccionar mascota").tag(nil as UUID?)
                        ForEach(petStore.pets) { pet in
                            Text(pet.name).tag(pet.id as UUID?)
                        }
                    }
                }
            }
            .navigationTitle("Agregar Evento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        saveEvent()
                    }
                    .disabled(title.isEmpty || selectedPetId == nil)
                }
            }
            .onAppear {
                if let pet = selectedPet {
                    selectedPetId = pet.id
                }
            }
        }
    }
    
    private func saveEvent() {
        guard let petId = selectedPetId else { return }
        
        let event = Event(
            title: title,
            date: date,
            eventType: eventType,
            description: description.isEmpty ? nil : description,
            location: location.isEmpty ? nil : location,
            contact: contact.isEmpty ? nil : contact,
            petId: petId
        )
        
        petStore.addEvent(event)
        dismiss()
    }
}

#Preview {
    CalendarView()
        .environmentObject(PetStore())
} 
