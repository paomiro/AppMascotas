package com.pets.api.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "events")
public class Event {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "El título es obligatorio")
    @Size(max = 200, message = "El título no puede tener más de 200 caracteres")
    private String title;
    
    @NotNull(message = "La fecha es obligatoria")
    private LocalDate date;
    
    @Enumerated(EnumType.STRING)
    @NotNull(message = "El tipo de evento es obligatorio")
    private EventType eventType;
    
    @Size(max = 500, message = "La descripción no puede tener más de 500 caracteres")
    private String description;
    
    @Size(max = 200, message = "La ubicación no puede tener más de 200 caracteres")
    private String location;
    
    @Size(max = 100, message = "El contacto no puede tener más de 100 caracteres")
    private String contact;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pet_id", nullable = false)
    @NotNull(message = "La mascota es obligatoria")
    private Pet pet;
    
    @NotNull(message = "La fecha de creación es obligatoria")
    private LocalDateTime createdAt;
    
    // Constructors
    public Event() {
        this.createdAt = LocalDateTime.now();
    }
    
    public Event(String title, LocalDate date, EventType eventType, Pet pet) {
        this();
        this.title = title;
        this.date = date;
        this.eventType = eventType;
        this.pet = pet;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public LocalDate getDate() {
        return date;
    }
    
    public void setDate(LocalDate date) {
        this.date = date;
    }
    
    public EventType getEventType() {
        return eventType;
    }
    
    public void setEventType(EventType eventType) {
        this.eventType = eventType;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public String getContact() {
        return contact;
    }
    
    public void setContact(String contact) {
        this.contact = contact;
    }
    
    public Pet getPet() {
        return pet;
    }
    
    public void setPet(Pet pet) {
        this.pet = pet;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    // Calculated fields
    public boolean isUpcoming() {
        return date.isAfter(LocalDate.now()) || date.isEqual(LocalDate.now());
    }
    
    public long getDaysUntilEvent() {
        return java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), date);
    }
} 