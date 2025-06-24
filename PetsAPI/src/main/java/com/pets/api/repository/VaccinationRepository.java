package com.pets.api.repository;

import com.pets.api.model.Vaccination;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface VaccinationRepository extends JpaRepository<Vaccination, Long> {
    
    List<Vaccination> findByPetIdOrderByNextDueDateAsc(Long petId);
    
    @Query("SELECT v FROM Vaccination v WHERE v.pet.ownerEmail = :ownerEmail ORDER BY v.nextDueDate ASC")
    List<Vaccination> findByOwnerEmailOrderByNextDueDateAsc(@Param("ownerEmail") String ownerEmail);
    
    @Query("SELECT v FROM Vaccination v WHERE v.nextDueDate < :today ORDER BY v.nextDueDate ASC")
    List<Vaccination> findOverdueVaccinations(@Param("today") LocalDate today);
    
    @Query("SELECT v FROM Vaccination v WHERE v.pet.ownerEmail = :ownerEmail AND v.nextDueDate < :today ORDER BY v.nextDueDate ASC")
    List<Vaccination> findOverdueVaccinationsByOwner(@Param("ownerEmail") String ownerEmail, @Param("today") LocalDate today);
    
    @Query("SELECT v FROM Vaccination v WHERE v.pet.id = :petId AND v.nextDueDate < :today ORDER BY v.nextDueDate ASC")
    List<Vaccination> findOverdueVaccinationsByPetId(@Param("petId") Long petId, @Param("today") LocalDate today);
    
    @Query("SELECT v FROM Vaccination v WHERE v.nextDueDate BETWEEN :today AND :thirtyDaysLater ORDER BY v.nextDueDate ASC")
    List<Vaccination> findVaccinationsDueSoon(@Param("today") LocalDate today, @Param("thirtyDaysLater") LocalDate thirtyDaysLater);
    
    @Query("SELECT v FROM Vaccination v WHERE v.pet.ownerEmail = :ownerEmail AND v.nextDueDate BETWEEN :today AND :thirtyDaysLater ORDER BY v.nextDueDate ASC")
    List<Vaccination> findVaccinationsDueSoonByOwner(@Param("ownerEmail") String ownerEmail, @Param("today") LocalDate today, @Param("thirtyDaysLater") LocalDate thirtyDaysLater);
} 