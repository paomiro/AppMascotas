package com.pets.api.controller;

import com.pets.api.dto.PetDTO;
import com.pets.api.model.Pet;
import com.pets.api.model.PetSpecies;
import com.pets.api.repository.PetRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/pets")
@CrossOrigin(origins = "*")
public class PetController {
    
    @Autowired
    private PetRepository petRepository;
    
    // GET all pets
    @GetMapping
    public ResponseEntity<List<PetDTO>> getAllPets() {
        List<Pet> pets = petRepository.findAll();
        List<PetDTO> petDTOs = pets.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(petDTOs);
    }
    
    // GET pets by owner email
    @GetMapping("/owner/{email}")
    public ResponseEntity<List<PetDTO>> getPetsByOwner(@PathVariable String email) {
        List<Pet> pets = petRepository.findByOwnerEmail(email);
        List<PetDTO> petDTOs = pets.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(petDTOs);
    }
    
    // GET pet by ID
    @GetMapping("/{id}")
    public ResponseEntity<PetDTO> getPetById(@PathVariable Long id) {
        Optional<Pet> pet = petRepository.findById(id);
        if (pet.isPresent()) {
            return ResponseEntity.ok(convertToDTO(pet.get()));
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    // GET pet image
    @GetMapping("/{id}/image")
    public ResponseEntity<byte[]> getPetImage(@PathVariable Long id) {
        Optional<Pet> pet = petRepository.findById(id);
        if (pet.isPresent() && pet.get().getImageData() != null) {
            return ResponseEntity.ok()
                    .contentType(MediaType.IMAGE_JPEG)
                    .body(pet.get().getImageData());
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    // POST create new pet
    @PostMapping
    public ResponseEntity<PetDTO> createPet(@Valid @RequestBody PetDTO petDTO) {
        Pet pet = convertToEntity(petDTO);
        Pet savedPet = petRepository.save(pet);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(convertToDTO(savedPet));
    }
    
    // POST upload pet image
    @PostMapping("/{id}/image")
    public ResponseEntity<String> uploadPetImage(@PathVariable Long id, 
                                                @RequestParam("image") MultipartFile image) {
        Optional<Pet> petOpt = petRepository.findById(id);
        if (petOpt.isPresent()) {
            Pet pet = petOpt.get();
            try {
                pet.setImageData(image.getBytes());
                petRepository.save(pet);
                return ResponseEntity.ok("Imagen subida exitosamente");
            } catch (IOException e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body("Error al procesar la imagen");
            }
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    // PUT update pet
    @PutMapping("/{id}")
    public ResponseEntity<PetDTO> updatePet(@PathVariable Long id, 
                                           @Valid @RequestBody PetDTO petDTO) {
        Optional<Pet> petOpt = petRepository.findById(id);
        if (petOpt.isPresent()) {
            Pet pet = petOpt.get();
            updatePetFromDTO(pet, petDTO);
            Pet savedPet = petRepository.save(pet);
            return ResponseEntity.ok(convertToDTO(savedPet));
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    // DELETE pet
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePet(@PathVariable Long id) {
        if (petRepository.existsById(id)) {
            petRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    // GET pets by species
    @GetMapping("/species/{species}")
    public ResponseEntity<List<PetDTO>> getPetsBySpecies(@PathVariable PetSpecies species) {
        List<Pet> pets = petRepository.findBySpecies(species.name());
        List<PetDTO> petDTOs = pets.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(petDTOs);
    }
    
    // GET pets by breed (search)
    @GetMapping("/search/breed")
    public ResponseEntity<List<PetDTO>> searchPetsByBreed(@RequestParam String breed) {
        List<Pet> pets = petRepository.findByBreedContaining(breed);
        List<PetDTO> petDTOs = pets.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(petDTOs);
    }
    
    // GET pets by name (search)
    @GetMapping("/search/name")
    public ResponseEntity<List<PetDTO>> searchPetsByName(@RequestParam String name) {
        List<Pet> pets = petRepository.findByNameContaining(name);
        List<PetDTO> petDTOs = pets.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(petDTOs);
    }
    
    // Helper methods
    private PetDTO convertToDTO(Pet pet) {
        PetDTO dto = new PetDTO();
        dto.setId(pet.getId());
        dto.setName(pet.getName());
        dto.setSpecies(pet.getSpecies());
        dto.setBreed(pet.getBreed());
        dto.setBirthDate(pet.getBirthDate());
        dto.setWeight(pet.getWeight());
        dto.setColor(pet.getColor());
        dto.setMicrochipNumber(pet.getMicrochipNumber());
        dto.setPhotoUrl(pet.getPhotoUrl());
        dto.setOwnerName(pet.getOwnerName());
        dto.setOwnerPhone(pet.getOwnerPhone());
        dto.setOwnerEmail(pet.getOwnerEmail());
        dto.setAge(pet.getAge());
        dto.setAgeInMonths(pet.getAgeInMonths());
        return dto;
    }
    
    private Pet convertToEntity(PetDTO dto) {
        Pet pet = new Pet();
        pet.setName(dto.getName());
        pet.setSpecies(dto.getSpecies());
        pet.setBreed(dto.getBreed());
        pet.setBirthDate(dto.getBirthDate());
        pet.setWeight(dto.getWeight());
        pet.setColor(dto.getColor());
        pet.setMicrochipNumber(dto.getMicrochipNumber());
        pet.setPhotoUrl(dto.getPhotoUrl());
        pet.setImageData(dto.getImageData());
        pet.setOwnerName(dto.getOwnerName());
        pet.setOwnerPhone(dto.getOwnerPhone());
        pet.setOwnerEmail(dto.getOwnerEmail());
        return pet;
    }
    
    private void updatePetFromDTO(Pet pet, PetDTO dto) {
        pet.setName(dto.getName());
        pet.setSpecies(dto.getSpecies());
        pet.setBreed(dto.getBreed());
        pet.setBirthDate(dto.getBirthDate());
        pet.setWeight(dto.getWeight());
        pet.setColor(dto.getColor());
        pet.setMicrochipNumber(dto.getMicrochipNumber());
        pet.setPhotoUrl(dto.getPhotoUrl());
        pet.setOwnerName(dto.getOwnerName());
        pet.setOwnerPhone(dto.getOwnerPhone());
        pet.setOwnerEmail(dto.getOwnerEmail());
    }
} 