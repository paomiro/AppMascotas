package com.pets.api.model;

public enum PetSpecies {
    DOG("Perro"),
    CAT("Gato"),
    BIRD("Ave"),
    RABBIT("Conejo"),
    FISH("Pez"),
    OTHER("Otro");
    
    private final String displayName;
    
    PetSpecies(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    public String getIcon() {
        switch (this) {
            case DOG: return "dog";
            case CAT: return "cat";
            case BIRD: return "bird";
            case RABBIT: return "rabbit";
            case FISH: return "fish";
            case OTHER: return "pawprint";
            default: return "pawprint";
        }
    }
} 