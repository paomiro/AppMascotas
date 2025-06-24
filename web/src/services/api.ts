import axios, { AxiosResponse, AxiosRequestConfig, AxiosError } from 'axios';
import { Pet, Post, PetDTO, PostDTO, PostResponse } from '../types';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 15000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor
api.interceptors.request.use(
  (config: AxiosRequestConfig) => {
    console.log(`Making ${config.method?.toUpperCase()} request to ${config.url}`);
    return config;
  },
  (error: AxiosError) => {
    return Promise.reject(error);
  }
);

// Response interceptor
api.interceptors.response.use(
  (response: AxiosResponse) => {
    return response;
  },
  (error: AxiosError) => {
    console.error('API Error:', error.response?.data || error.message);
    return Promise.reject(error);
  }
);

// Pet API methods
export const petApi = {
  // Get all pets
  getAll: async (): Promise<Pet[]> => {
    const response: AxiosResponse<PetDTO[]> = await api.get('/pets');
    return response.data.map(dtoToPet);
  },

  // Get pets by owner email
  getByOwner: async (email: string): Promise<Pet[]> => {
    const response: AxiosResponse<PetDTO[]> = await api.get(`/pets/owner/${encodeURIComponent(email)}`);
    return response.data.map(dtoToPet);
  },

  // Get pet by ID
  getById: async (id: string): Promise<Pet> => {
    const response: AxiosResponse<PetDTO> = await api.get(`/pets/${id}`);
    return dtoToPet(response.data);
  },

  // Create new pet
  create: async (pet: Omit<Pet, 'id' | 'createdAt' | 'age' | 'ageInMonths'>): Promise<Pet> => {
    const petDTO = petToDTO(pet as Pet);
    const response: AxiosResponse<PetDTO> = await api.post('/pets', petDTO);
    return dtoToPet(response.data);
  },

  // Update pet
  update: async (id: string, pet: Partial<Pet>): Promise<Pet> => {
    const petDTO = petToDTO(pet as Pet);
    const response: AxiosResponse<PetDTO> = await api.put(`/pets/${id}`, petDTO);
    return dtoToPet(response.data);
  },

  // Delete pet
  delete: async (id: string): Promise<void> => {
    await api.delete(`/pets/${id}`);
  },

  // Upload pet image
  uploadImage: async (id: string, imageFile: File): Promise<void> => {
    const formData = new FormData();
    formData.append('image', imageFile);
    
    await api.post(`/pets/${id}/image`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
  },

  // Get pet image
  getImage: async (id: string): Promise<string | null> => {
    try {
      const response = await api.get(`/pets/${id}/image`, {
        responseType: 'blob',
      });
      return URL.createObjectURL(response.data);
    } catch (error) {
      return null;
    }
  },
};

// Post API methods
export const postApi = {
  // Get all posts with pagination
  getAll: async (page: number = 0, size: number = 10): Promise<PostResponse> => {
    const response: AxiosResponse<PostResponse> = await api.get(`/posts?page=${page}&size=${size}`);
    return {
      ...response.data,
      posts: response.data.posts.map(dtoToPost),
    };
  },

  // Get posts by pet ID
  getByPet: async (petId: string): Promise<Post[]> => {
    const response: AxiosResponse<PostDTO[]> = await api.get(`/posts/pet/${petId}`);
    return response.data.map(dtoToPost);
  },

  // Create new post
  create: async (petId: string, imageFile: File): Promise<Post> => {
    const formData = new FormData();
    formData.append('petId', petId);
    formData.append('image', imageFile);
    
    const response: AxiosResponse<PostDTO> = await api.post('/posts', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    return dtoToPost(response.data);
  },

  // Delete post
  delete: async (id: string): Promise<void> => {
    await api.delete(`/posts/${id}`);
  },

  // Toggle like on post
  toggleLike: async (id: string, petId: string): Promise<{ liked: boolean; likeCount: number }> => {
    const response: AxiosResponse<{ liked: boolean; likeCount: number }> = await api.post(`/posts/${id}/like?petId=${petId}`);
    return response.data;
  },
};

// Helper functions
function dtoToPet(dto: PetDTO): Pet {
  return {
    id: dto.id || '',
    name: dto.name,
    species: dto.species as any,
    breed: dto.breed,
    birthDate: dto.birthDate,
    weight: dto.weight,
    color: dto.color,
    microchipNumber: dto.microchipNumber,
    photoUrl: dto.photoUrl,
    imageData: dto.imageData,
    ownerName: dto.ownerName,
    ownerPhone: dto.ownerPhone,
    ownerEmail: dto.ownerEmail,
    createdAt: new Date().toISOString(),
    age: dto.age || 0,
    ageInMonths: dto.ageInMonths || 0,
  };
}

function petToDTO(pet: Pet): PetDTO {
  return {
    id: pet.id,
    name: pet.name,
    species: pet.species,
    breed: pet.breed,
    birthDate: pet.birthDate,
    weight: pet.weight,
    color: pet.color,
    microchipNumber: pet.microchipNumber,
    photoUrl: pet.photoUrl,
    imageData: pet.imageData,
    ownerName: pet.ownerName,
    ownerPhone: pet.ownerPhone,
    ownerEmail: pet.ownerEmail,
    age: pet.age,
    ageInMonths: pet.ageInMonths,
  };
}

function dtoToPost(dto: PostDTO): Post {
  return {
    id: dto.id || '',
    petId: dto.petId || '',
    petName: '',
    petImageData: undefined,
    imageData: dto.imageData,
    createdAt: dto.createdAt || new Date().toISOString(),
    likes: dto.likedBy || [],
  };
}

export default api; 