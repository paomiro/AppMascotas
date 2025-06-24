package com.pets.api.repository;

import com.pets.api.model.Pet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PetRepository extends JpaRepository<Pet, Long> {
    
    List<Pet> findByOwnerEmail(String ownerEmail);
    
    @Query("SELECT p FROM Pet p WHERE p.ownerEmail = :email ORDER BY p.createdAt DESC")
    List<Pet> findPetsByOwnerEmailOrderByCreatedAt(@Param("email") String email);
    
    @Query("SELECT p FROM Pet p WHERE p.species = :species")
    List<Pet> findBySpecies(@Param("species") String species);
    
    @Query("SELECT p FROM Pet p WHERE p.breed LIKE %:breed%")
    List<Pet> findByBreedContaining(@Param("breed") String breed);
    
    @Query("SELECT p FROM Pet p WHERE p.name LIKE %:name%")
    List<Pet> findByNameContaining(@Param("name") String name);
} 