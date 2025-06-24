package com.pets.api.model;

public enum EventType {
    VETERINARY("Veterinario"),
    GROOMING("Peluquería"),
    TRAINING("Entrenamiento"),
    WALK("Paseo"),
    OTHER("Otro");
    
    private final String displayName;
    
    EventType(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    public String getIcon() {
        switch (this) {
            case VETERINARY: return "stethoscope";
            case GROOMING: return "scissors";
            case TRAINING: return "graduationcap";
            case WALK: return "figure.walk";
            case OTHER: return "calendar";
            default: return "calendar";
        }
    }
    
    public String getColor() {
        switch (this) {
            case VETERINARY: return "red";
            case GROOMING: return "purple";
            case TRAINING: return "blue";
            case WALK: return "green";
            case OTHER: return "gray";
            default: return "gray";
        }
    }
} 