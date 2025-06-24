package com.pets.api.repository;

import com.pets.api.model.Event;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface EventRepository extends JpaRepository<Event, Long> {
    
    List<Event> findByPetIdOrderByDateAsc(Long petId);
    
    @Query("SELECT e FROM Event e WHERE e.pet.ownerEmail = :ownerEmail ORDER BY e.date ASC")
    List<Event> findByOwnerEmailOrderByDateAsc(@Param("ownerEmail") String ownerEmail);
    
    @Query("SELECT e FROM Event e WHERE e.date >= :today ORDER BY e.date ASC")
    List<Event> findUpcomingEvents(@Param("today") LocalDate today);
    
    @Query("SELECT e FROM Event e WHERE e.pet.ownerEmail = :ownerEmail AND e.date >= :today ORDER BY e.date ASC")
    List<Event> findUpcomingEventsByOwner(@Param("ownerEmail") String ownerEmail, @Param("today") LocalDate today);
    
    @Query("SELECT e FROM Event e WHERE e.pet.id = :petId AND e.date >= :today ORDER BY e.date ASC")
    List<Event> findUpcomingEventsByPetId(@Param("petId") Long petId, @Param("today") LocalDate today);
    
    @Query("SELECT e FROM Event e WHERE e.eventType = :eventType AND e.pet.ownerEmail = :ownerEmail ORDER BY e.date ASC")
    List<Event> findByEventTypeAndOwner(@Param("eventType") String eventType, @Param("ownerEmail") String ownerEmail);
} 