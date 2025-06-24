package com.pets.api.controller;

import com.pets.api.model.Post;
import com.pets.api.repository.PostRepository;
import com.pets.api.repository.PetRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/posts")
@CrossOrigin(origins = "*")
public class PostController {
    
    @Autowired
    private PostRepository postRepository;
    
    @Autowired
    private PetRepository petRepository;
    
    // GET all posts with pagination
    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllPosts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        Pageable pageable = PageRequest.of(page, size);
        Page<Post> postPage = postRepository.findAllOrderByCreatedAtDesc(pageable);
        
        Map<String, Object> response = new HashMap<>();
        response.put("posts", postPage.getContent());
        response.put("currentPage", postPage.getNumber());
        response.put("totalItems", postPage.getTotalElements());
        response.put("totalPages", postPage.getTotalPages());
        
        return ResponseEntity.ok(response);
    }
    
    // GET posts by pet ID
    @GetMapping("/pet/{petId}")
    public ResponseEntity<List<Post>> getPostsByPet(@PathVariable Long petId) {
        List<Post> posts = postRepository.findByPetIdOrderByCreatedAtDesc(petId);
        return ResponseEntity.ok(posts);
    }
    
    // GET posts by owner email
    @GetMapping("/owner/{email}")
    public ResponseEntity<List<Post>> getPostsByOwner(@PathVariable String email) {
        List<Post> posts = postRepository.findByOwnerEmailOrderByCreatedAtDesc(email);
        return ResponseEntity.ok(posts);
    }
    
    // GET post by ID
    @GetMapping("/{id}")
    public ResponseEntity<Post> getPostById(@PathVariable Long id) {
        Optional<Post> post = postRepository.findById(id);
        if (post.isPresent()) {
            return ResponseEntity.ok(post.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    // GET post image
    @GetMapping("/{id}/image")
    public ResponseEntity<byte[]> getPostImage(@PathVariable Long id) {
        Optional<Post> post = postRepository.findById(id);
        if (post.isPresent() && post.get().getImageData() != null) {
            return ResponseEntity.ok()
                    .contentType(MediaType.IMAGE_JPEG)
                    .body(post.get().getImageData());
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    // POST create new post
    @PostMapping
    public ResponseEntity<Post> createPost(@RequestParam("petId") Long petId,
                                          @RequestParam("image") MultipartFile image) {
        Optional<com.pets.api.model.Pet> petOpt = petRepository.findById(petId);
        if (petOpt.isPresent()) {
            try {
                Post post = new Post();
                post.setPet(petOpt.get());
                post.setImageData(image.getBytes());
                
                Post savedPost = postRepository.save(post);
                return ResponseEntity.status(HttpStatus.CREATED).body(savedPost);
            } catch (IOException e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
            }
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    // POST like/unlike post
    @PostMapping("/{id}/like")
    public ResponseEntity<Map<String, Object>> toggleLike(@PathVariable Long id,
                                                         @RequestParam("petId") Long petId) {
        Optional<Post> postOpt = postRepository.findById(id);
        if (postOpt.isPresent()) {
            Post post = postOpt.get();
            post.toggleLike(petId);
            Post savedPost = postRepository.save(post);
            
            Map<String, Object> response = new HashMap<>();
            response.put("liked", savedPost.isLikedBy(petId));
            response.put("likeCount", savedPost.getLikeCount());
            
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    // DELETE post
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePost(@PathVariable Long id) {
        if (postRepository.existsById(id)) {
            postRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    // GET post count by pet
    @GetMapping("/pet/{petId}/count")
    public ResponseEntity<Map<String, Long>> getPostCountByPet(@PathVariable Long petId) {
        long count = postRepository.countByPetId(petId);
        Map<String, Long> response = new HashMap<>();
        response.put("count", count);
        return ResponseEntity.ok(response);
    }
} 