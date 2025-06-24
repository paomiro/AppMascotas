package com.pets.api.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "vaccinations")
public class Vaccination {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "El nombre de la vacuna es obligatorio")
    @Size(max = 100, message = "El nombre no puede tener más de 100 caracteres")
    private String name;
    
    @NotNull(message = "La fecha de vacunación es obligatoria")
    private LocalDate date;
    
    @NotNull(message = "La fecha de próxima dosis es obligatoria")
    private LocalDate nextDueDate;
    
    @Size(max = 100, message = "El veterinario no puede tener más de 100 caracteres")
    private String veterinarian;
    
    @Size(max = 200, message = "La clínica no puede tener más de 200 caracteres")
    private String clinic;
    
    @Size(max = 500, message = "Las notas no pueden tener más de 500 caracteres")
    private String notes;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pet_id", nullable = false)
    @NotNull(message = "La mascota es obligatoria")
    private Pet pet;
    
    @NotNull(message = "La fecha de creación es obligatoria")
    private LocalDateTime createdAt;
    
    // Constructors
    public Vaccination() {
        this.createdAt = LocalDateTime.now();
    }
    
    public Vaccination(String name, LocalDate date, LocalDate nextDueDate, Pet pet) {
        this();
        this.name = name;
        this.date = date;
        this.nextDueDate = nextDueDate;
        this.pet = pet;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public LocalDate getDate() {
        return date;
    }
    
    public void setDate(LocalDate date) {
        this.date = date;
    }
    
    public LocalDate getNextDueDate() {
        return nextDueDate;
    }
    
    public void setNextDueDate(LocalDate nextDueDate) {
        this.nextDueDate = nextDueDate;
    }
    
    public String getVeterinarian() {
        return veterinarian;
    }
    
    public void setVeterinarian(String veterinarian) {
        this.veterinarian = veterinarian;
    }
    
    public String getClinic() {
        return clinic;
    }
    
    public void setClinic(String clinic) {
        this.clinic = clinic;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
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
    public boolean isOverdue() {
        return nextDueDate.isBefore(LocalDate.now());
    }
    
    public long getDaysUntilDue() {
        return java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), nextDueDate);
    }
    
    public boolean isDueSoon() {
        long daysUntilDue = getDaysUntilDue();
        return daysUntilDue >= 0 && daysUntilDue <= 30;
    }
} 