package com.pets.api.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "posts")
public class Post {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pet_id", nullable = false)
    @NotNull(message = "La mascota es obligatoria")
    private Pet pet;
    
    @Lob
    @Column(columnDefinition = "LONGBLOB")
    private byte[] imageData;
    
    @NotNull(message = "La fecha de creación es obligatoria")
    private LocalDateTime createdAt;
    
    @ElementCollection
    @CollectionTable(name = "post_likes", joinColumns = @JoinColumn(name = "post_id"))
    @Column(name = "pet_id")
    private Set<Long> likes = new HashSet<>();
    
    // Constructors
    public Post() {
        this.createdAt = LocalDateTime.now();
    }
    
    public Post(Pet pet, byte[] imageData) {
        this();
        this.pet = pet;
        this.imageData = imageData;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Pet getPet() {
        return pet;
    }
    
    public void setPet(Pet pet) {
        this.pet = pet;
    }
    
    public byte[] getImageData() {
        return imageData;
    }
    
    public void setImageData(byte[] imageData) {
        this.imageData = imageData;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public Set<Long> getLikes() {
        return likes;
    }
    
    public void setLikes(Set<Long> likes) {
        this.likes = likes;
    }
    
    public int getLikeCount() {
        return likes.size();
    }
    
    public boolean isLikedBy(Long petId) {
        return likes.contains(petId);
    }
    
    public void addLike(Long petId) {
        likes.add(petId);
    }
    
    public void removeLike(Long petId) {
        likes.remove(petId);
    }
    
    public void toggleLike(Long petId) {
        if (isLikedBy(petId)) {
            removeLike(petId);
        } else {
            addLike(petId);
        }
    }
} 