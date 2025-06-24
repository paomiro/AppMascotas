package com.pets.api.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "pets")
public class Pet {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "El nombre es obligatorio")
    @Size(max = 100, message = "El nombre no puede tener más de 100 caracteres")
    private String name;
    
    @Enumerated(EnumType.STRING)
    @NotNull(message = "La especie es obligatoria")
    private PetSpecies species;
    
    @NotBlank(message = "La raza es obligatoria")
    @Size(max = 100, message = "La raza no puede tener más de 100 caracteres")
    private String breed;
    
    @NotNull(message = "La fecha de nacimiento es obligatoria")
    @Past(message = "La fecha de nacimiento debe ser en el pasado")
    private LocalDate birthDate;
    
    @NotNull(message = "El peso es obligatorio")
    @DecimalMin(value = "0.1", message = "El peso debe ser mayor a 0")
    @DecimalMax(value = "500.0", message = "El peso no puede ser mayor a 500 kg")
    private Double weight;
    
    @NotBlank(message = "El color es obligatorio")
    @Size(max = 50, message = "El color no puede tener más de 50 caracteres")
    private String color;
    
    @Size(max = 50, message = "El número de microchip no puede tener más de 50 caracteres")
    private String microchipNumber;
    
    @Lob
    @Column(columnDefinition = "LONGTEXT")
    private String photoUrl;
    
    @Lob
    @Column(columnDefinition = "LONGBLOB")
    private byte[] imageData;
    
    @NotBlank(message = "El nombre del dueño es obligatorio")
    @Size(max = 100, message = "El nombre del dueño no puede tener más de 100 caracteres")
    private String ownerName;
    
    @NotBlank(message = "El teléfono del dueño es obligatorio")
    @Pattern(regexp = "^\\+?[0-9\\s\\-()]{7,20}$", message = "Formato de teléfono inválido")
    private String ownerPhone;
    
    @NotBlank(message = "El email del dueño es obligatorio")
    @Email(message = "Formato de email inválido")
    @Size(max = 100, message = "El email no puede tener más de 100 caracteres")
    private String ownerEmail;
    
    @NotNull(message = "La fecha de creación es obligatoria")
    private LocalDateTime createdAt;
    
    @OneToMany(mappedBy = "pet", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Event> events;
    
    @OneToMany(mappedBy = "pet", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Vaccination> vaccinations;
    
    @OneToMany(mappedBy = "pet", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Post> posts;
    
    // Constructors
    public Pet() {
        this.createdAt = LocalDateTime.now();
    }
    
    public Pet(String name, PetSpecies species, String breed, LocalDate birthDate, 
               Double weight, String color, String ownerName, String ownerPhone, String ownerEmail) {
        this();
        this.name = name;
        this.species = species;
        this.breed = breed;
        this.birthDate = birthDate;
        this.weight = weight;
        this.color = color;
        this.ownerName = ownerName;
        this.ownerPhone = ownerPhone;
        this.ownerEmail = ownerEmail;
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
    
    public PetSpecies getSpecies() {
        return species;
    }
    
    public void setSpecies(PetSpecies species) {
        this.species = species;
    }
    
    public String getBreed() {
        return breed;
    }
    
    public void setBreed(String breed) {
        this.breed = breed;
    }
    
    public LocalDate getBirthDate() {
        return birthDate;
    }
    
    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
    }
    
    public Double getWeight() {
        return weight;
    }
    
    public void setWeight(Double weight) {
        this.weight = weight;
    }
    
    public String getColor() {
        return color;
    }
    
    public void setColor(String color) {
        this.color = color;
    }
    
    public String getMicrochipNumber() {
        return microchipNumber;
    }
    
    public void setMicrochipNumber(String microchipNumber) {
        this.microchipNumber = microchipNumber;
    }
    
    public String getPhotoUrl() {
        return photoUrl;
    }
    
    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }
    
    public byte[] getImageData() {
        return imageData;
    }
    
    public void setImageData(byte[] imageData) {
        this.imageData = imageData;
    }
    
    public String getOwnerName() {
        return ownerName;
    }
    
    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }
    
    public String getOwnerPhone() {
        return ownerPhone;
    }
    
    public void setOwnerPhone(String ownerPhone) {
        this.ownerPhone = ownerPhone;
    }
    
    public String getOwnerEmail() {
        return ownerEmail;
    }
    
    public void setOwnerEmail(String ownerEmail) {
        this.ownerEmail = ownerEmail;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public List<Event> getEvents() {
        return events;
    }
    
    public void setEvents(List<Event> events) {
        this.events = events;
    }
    
    public List<Vaccination> getVaccinations() {
        return vaccinations;
    }
    
    public void setVaccinations(List<Vaccination> vaccinations) {
        this.vaccinations = vaccinations;
    }
    
    public List<Post> getPosts() {
        return posts;
    }
    
    public void setPosts(List<Post> posts) {
        this.posts = posts;
    }
    
    // Calculated fields
    public int getAge() {
        if (birthDate == null) return 0;
        return LocalDate.now().getYear() - birthDate.getYear();
    }
    
    public int getAgeInMonths() {
        if (birthDate == null) return 0;
        return (int) java.time.temporal.ChronoUnit.MONTHS.between(birthDate, LocalDate.now());
    }
} 