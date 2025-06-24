export interface Pet {
  id: string;
  name: string;
  species: PetSpecies;
  breed: string;
  birthDate: string;
  weight: number;
  color: string;
  microchipNumber?: string;
  photoUrl?: string;
  imageData?: string;
  ownerName: string;
  ownerPhone: string;
  ownerEmail: string;
  createdAt: string;
  age: number;
  ageInMonths: number;
}

export enum PetSpecies {
  DOG = 'Perro',
  CAT = 'Gato',
  BIRD = 'Ave',
  RABBIT = 'Conejo',
  FISH = 'Pez',
  OTHER = 'Otro'
}

export interface Post {
  id: string;
  petId: string;
  petName: string;
  petImageData?: string;
  imageData?: string;
  createdAt: string;
  likes: string[];
}

export interface Event {
  id: string;
  title: string;
  date: string;
  eventType: EventType;
  description: string;
  location: string;
  contact: string;
  petId: string;
}

export enum EventType {
  VETERINARY = 'Veterinario',
  GROOMING = 'Peluquería',
  TRAINING = 'Entrenamiento',
  WALK = 'Paseo',
  OTHER = 'Otro'
}

export interface Vaccination {
  id: string;
  name: string;
  date: string;
  nextDueDate: string;
  veterinarian: string;
  clinic: string;
}

export interface News {
  id: string;
  title: string;
  content: string;
  newsType: NewsType;
  startDate: string;
  endDate: string;
  priority: number;
  imageData?: string;
}

export enum NewsType {
  PROMOTION = 'Promoción',
  NEWS = 'Noticia',
  ALERT = 'Alerta',
  TIP = 'Consejo'
}

export interface ApiResponse<T> {
  data: T;
  message?: string;
  error?: string;
}

export interface PostResponse {
  posts: Post[];
  currentPage: number;
  totalItems: number;
  totalPages: number;
}

export interface PetDTO {
  id?: string;
  name: string;
  species: string;
  breed: string;
  birthDate: string;
  weight: number;
  color: string;
  microchipNumber?: string;
  photoUrl?: string;
  imageData?: string;
  ownerName: string;
  ownerPhone: string;
  ownerEmail: string;
  age?: number;
  ageInMonths?: number;
}

export interface PostDTO {
  id?: string;
  petId?: string;
  imageData?: string;
  createdAt?: string;
  likedBy?: string[];
} 