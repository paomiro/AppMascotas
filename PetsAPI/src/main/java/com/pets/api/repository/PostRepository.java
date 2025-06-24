package com.pets.api.repository;

import com.pets.api.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PostRepository extends JpaRepository<Post, Long> {
    
    List<Post> findByPetIdOrderByCreatedAtDesc(Long petId);
    
    @Query("SELECT p FROM Post p ORDER BY p.createdAt DESC")
    Page<Post> findAllOrderByCreatedAtDesc(Pageable pageable);
    
    @Query("SELECT p FROM Post p WHERE p.pet.ownerEmail = :ownerEmail ORDER BY p.createdAt DESC")
    List<Post> findByOwnerEmailOrderByCreatedAtDesc(@Param("ownerEmail") String ownerEmail);
    
    @Query("SELECT p FROM Post p WHERE p.pet.id IN :petIds ORDER BY p.createdAt DESC")
    List<Post> findByPetIdsOrderByCreatedAtDesc(@Param("petIds") List<Long> petIds);
    
    @Query("SELECT COUNT(p) FROM Post p WHERE p.pet.id = :petId")
    long countByPetId(@Param("petId") Long petId);
} 