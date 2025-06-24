# API Integration Guide

## Overview

La aplicación iOS de Pets ahora está integrada con el backend Spring Boot para sincronización de datos en tiempo real.

## Arquitectura

### Componentes Principales

1. **APIService** (`Models/APIService.swift`)
   - Cliente HTTP para comunicación con el backend
   - Manejo de errores y respuestas
   - Conversión entre DTOs y modelos locales

2. **APIConfig** (`Models/APIConfig.swift`)
   - Configuración de entornos (desarrollo, staging, producción)
   - URLs base y timeouts
   - Endpoints y headers

3. **PetStore** (`ViewModels/PetStore.swift`)
   - Integración con APIService
   - Sincronización automática de datos
   - Manejo de errores de red

4. **APIStatusView** (`Views/Components/APIStatusView.swift`)
   - UI para mostrar estado de conexión
   - Manejo de errores de red
   - Botones de reintento

## Configuración

### Entornos

```swift
// Desarrollo (localhost)
APIConfig.currentEnvironment = .development

// Producción
APIConfig.currentEnvironment = .production
```

### URLs por Defecto

- **Desarrollo**: `http://localhost:8080/api`
- **Staging**: `https://staging-pets-api.example.com/api`
- **Producción**: `https://pets-api.example.com/api`

## Endpoints Soportados

### Mascotas (Pets)

- `GET /api/pets` - Obtener todas las mascotas
- `GET /api/pets/owner/{email}` - Obtener mascotas por dueño
- `GET /api/pets/{id}` - Obtener mascota por ID
- `POST /api/pets` - Crear nueva mascota
- `PUT /api/pets/{id}` - Actualizar mascota
- `DELETE /api/pets/{id}` - Eliminar mascota
- `POST /api/pets/{id}/image` - Subir imagen de mascota
- `GET /api/pets/{id}/image` - Obtener imagen de mascota

### Posts

- `GET /api/posts` - Obtener posts con paginación
- `GET /api/posts/pet/{petId}` - Obtener posts por mascota
- `POST /api/posts` - Crear nuevo post
- `DELETE /api/posts/{id}` - Eliminar post

## Uso

### Carga Automática

Los datos se cargan automáticamente al iniciar la app:

```swift
init() {
    loadData()
    loadSampleData()
    setupIOSIntegration()
    
    // Load data from API
    Task {
        await loadPetsFromAPI()
        await loadPostsFromAPI()
    }
}
```

### Sincronización Manual

```swift
// Recargar mascotas
await petStore.loadPetsFromAPI()

// Recargar posts
await petStore.loadPostsFromAPI()
```

### Manejo de Errores

Los errores se muestran automáticamente en la UI:

```swift
@Published var errorMessage: String?

// Los errores se muestran en APIStatusView
```

## Testing

### Vista de Pruebas

Accede a **Configuración > API y Servidor > Pruebas de API** para:

- Probar conexión con el servidor
- Cargar datos manualmente
- Ver estado actual de la conexión
- Verificar respuestas del servidor

### Configuración de Red

Para desarrollo local, se permite HTTP en `localhost`:

```xml
<key>NSExceptionDomains</key>
<dict>
    <key>localhost</key>
    <dict>
        <key>NSExceptionAllowsInsecureHTTPLoads</key>
        <true/>
    </dict>
</dict>
```

## Troubleshooting

### Errores Comunes

1. **"Error de conexión"**
   - Verificar que el servidor esté ejecutándose
   - Verificar URL en `APIConfig.swift`
   - Verificar configuración de red

2. **"Respuesta inválida del servidor"**
   - Verificar formato de datos enviados
   - Verificar estructura de DTOs
   - Revisar logs del servidor

3. **"Tiempo de espera agotado"**
   - Aumentar timeout en `APIConfig.swift`
   - Verificar conectividad de red

### Debug

1. Usar la vista de pruebas de API
2. Revisar logs de Xcode
3. Verificar respuestas del servidor
4. Comprobar configuración de red

## Próximos Pasos

1. Implementar autenticación
2. Agregar sincronización offline
3. Implementar cache local
4. Agregar más endpoints (eventos, vacunas, noticias)
5. Implementar notificaciones push 