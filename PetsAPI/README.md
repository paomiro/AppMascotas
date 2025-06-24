# Pets API - Spring Boot REST API

API REST para gestión de mascotas con funcionalidades de red social, eventos y vacunación.

## 🚀 Características

- **Gestión de Mascotas**: CRUD completo para mascotas con fotos
- **Red Social**: Posts con imágenes y sistema de likes (patitas)
- **Eventos**: Calendario de citas veterinarias, peluquería, etc.
- **Vacunación**: Registro y seguimiento de vacunas
- **Almacenamiento de Imágenes**: Base de datos con soporte para imágenes
- **API REST**: Endpoints completos para todas las funcionalidades

## 🛠️ Tecnologías

- **Spring Boot 3.2.0**
- **Spring Data JPA**
- **H2 Database** (desarrollo)
- **Maven**
- **Java 17**

## 📋 Requisitos

- Java 17 o superior
- Maven 3.6+
- IDE (IntelliJ IDEA, Eclipse, VS Code)

## 🔧 Instalación y Ejecución

### 1. Clonar el proyecto
```bash
git clone <repository-url>
cd PetsAPI
```

### 2. Compilar el proyecto
```bash
mvn clean compile
```

### 3. Ejecutar la aplicación
```bash
mvn spring-boot:run
```

### 4. Acceder a la aplicación
- **API Base URL**: http://localhost:8080/pets-api
- **H2 Console**: http://localhost:8080/pets-api/h2-console
  - JDBC URL: `jdbc:h2:mem:petdb`
  - Username: `sa`
  - Password: `password`

## 📚 Endpoints de la API

### Mascotas (`/api/pets`)

#### GET `/api/pets`
Obtener todas las mascotas

#### GET `/api/pets/{id}`
Obtener mascota por ID

#### GET `/api/pets/owner/{email}`
Obtener mascotas por email del dueño

#### GET `/api/pets/{id}/image`
Obtener imagen de la mascota

#### POST `/api/pets`
Crear nueva mascota
```json
{
  "name": "Dalila",
  "species": "DOG",
  "breed": "Maltés",
  "birthDate": "2022-01-15",
  "weight": 3.5,
  "color": "Blanco",
  "ownerName": "María García",
  "ownerPhone": "+52 55 1234 5678",
  "ownerEmail": "maria@example.com"
}
```

#### POST `/api/pets/{id}/image`
Subir imagen de la mascota (multipart/form-data)

#### PUT `/api/pets/{id}`
Actualizar mascota

#### DELETE `/api/pets/{id}`
Eliminar mascota

#### GET `/api/pets/species/{species}`
Obtener mascotas por especie

#### GET `/api/pets/search/breed?breed={breed}`
Buscar mascotas por raza

#### GET `/api/pets/search/name?name={name}`
Buscar mascotas por nombre

### Posts (`/api/posts`)

#### GET `/api/posts`
Obtener todos los posts con paginación
- Parámetros: `page` (default: 0), `size` (default: 10)

#### GET `/api/posts/{id}`
Obtener post por ID

#### GET `/api/posts/{id}/image`
Obtener imagen del post

#### GET `/api/posts/pet/{petId}`
Obtener posts de una mascota

#### GET `/api/posts/owner/{email}`
Obtener posts por email del dueño

#### POST `/api/posts`
Crear nuevo post
- Parámetros: `petId` (Long), `image` (MultipartFile)

#### POST `/api/posts/{id}/like`
Dar/quitar like a un post
- Parámetros: `petId` (Long)

#### DELETE `/api/posts/{id}`
Eliminar post

#### GET `/api/posts/pet/{petId}/count`
Obtener número de posts de una mascota

## 🗄️ Base de Datos

### Entidades Principales

#### Pet
- Información básica de la mascota
- Datos del dueño
- Imagen almacenada como byte array

#### Post
- Posts de la red social
- Imagen del post
- Sistema de likes con Set<Long>

#### Event
- Eventos del calendario
- Tipos: VETERINARY, GROOMING, TRAINING, WALK, OTHER

#### Vaccination
- Registro de vacunas
- Fechas de aplicación y próxima dosis

## 🔒 Seguridad

- CORS habilitado para desarrollo
- Validación de datos con Bean Validation
- Manejo de errores HTTP apropiado

## 📝 Ejemplos de Uso

### Crear una mascota
```bash
curl -X POST http://localhost:8080/pets-api/api/pets \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Dalila",
    "species": "DOG",
    "breed": "Maltés",
    "birthDate": "2022-01-15",
    "weight": 3.5,
    "color": "Blanco",
    "ownerName": "María García",
    "ownerPhone": "+52 55 1234 5678",
    "ownerEmail": "maria@example.com"
  }'
```

### Subir imagen de mascota
```bash
curl -X POST http://localhost:8080/pets-api/api/pets/1/image \
  -F "image=@/path/to/pet-image.jpg"
```

### Crear un post
```bash
curl -X POST http://localhost:8080/pets-api/api/posts \
  -F "petId=1" \
  -F "image=@/path/to/post-image.jpg"
```

### Dar like a un post
```bash
curl -X POST http://localhost:8080/pets-api/api/posts/1/like \
  -d "petId=1"
```

## 🚀 Despliegue

### Para producción, cambiar la configuración de base de datos:

```properties
# MySQL/PostgreSQL
spring.datasource.url=jdbc:mysql://localhost:3306/petsdb
spring.datasource.username=your_username
spring.datasource.password=your_password
spring.jpa.hibernate.ddl-auto=update
```

## 📞 Soporte

Para preguntas o problemas, contactar al equipo de desarrollo.

## 📄 Licencia

Este proyecto está bajo la licencia MIT. 