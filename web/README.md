# Pets Web Application

Una aplicación web moderna para la gestión de mascotas, construida con React, TypeScript y Tailwind CSS.

## 🚀 Características

- **Gestión de Mascotas**: Agregar, editar y ver información detallada de mascotas
- **Posts Sociales**: Compartir fotos de mascotas con la comunidad
- **Dashboard Interactivo**: Vista general con estadísticas y acciones rápidas
- **API Integration**: Conectado al backend Spring Boot
- **Diseño Responsivo**: Optimizado para móviles y escritorio
- **TypeScript**: Tipado estático para mejor desarrollo

## 🛠️ Tecnologías

- **React 18** - Biblioteca de UI
- **TypeScript** - Tipado estático
- **Tailwind CSS** - Framework de estilos
- **React Query** - Gestión de estado del servidor
- **React Router** - Navegación
- **React Hook Form** - Formularios
- **Axios** - Cliente HTTP
- **Lucide React** - Iconos
- **React Hot Toast** - Notificaciones

## 📦 Instalación

1. **Instalar dependencias**:
   ```bash
   npm install
   ```

2. **Configurar variables de entorno**:
   Crear un archivo `.env` en la raíz del proyecto:
   ```env
   REACT_APP_API_URL=http://localhost:8080/api
   ```

3. **Iniciar el servidor de desarrollo**:
   ```bash
   npm start
   ```

4. **Abrir en el navegador**:
   ```
   http://localhost:3000
   ```

## 🏗️ Estructura del Proyecto

```
src/
├── components/          # Componentes reutilizables
│   ├── Layout.tsx      # Layout principal con navegación
│   ├── PetCard.tsx     # Tarjeta de mascota
│   ├── PostCard.tsx    # Tarjeta de post
│   └── StatCard.tsx    # Tarjeta de estadística
├── pages/              # Páginas de la aplicación
│   ├── Dashboard.tsx   # Página principal
│   ├── PetsList.tsx    # Lista de mascotas
│   ├── AddPet.tsx      # Agregar mascota
│   ├── PetDetail.tsx   # Detalle de mascota
│   ├── Posts.tsx       # Lista de posts
│   └── ...            # Otras páginas
├── services/           # Servicios de API
│   └── api.ts         # Cliente de API
├── types/              # Definiciones de TypeScript
│   └── index.ts       # Interfaces y tipos
├── App.tsx            # Componente principal
└── index.tsx          # Punto de entrada
```

## 🔧 Configuración

### API Backend

La aplicación se conecta al backend Spring Boot en `http://localhost:8080/api`. Asegúrate de que el servidor esté ejecutándose.

### Proxy de Desarrollo

El proyecto incluye un proxy configurado en `package.json` para evitar problemas de CORS durante el desarrollo:

```json
{
  "proxy": "http://localhost:8080"
}
```

## 📱 Páginas Principales

### Dashboard
- Vista general con estadísticas
- Acciones rápidas
- Mascotas recientes
- Posts recientes

### Mascotas
- Lista de todas las mascotas
- Búsqueda y filtros
- Agregar nueva mascota
- Ver detalles de mascota

### Posts
- Galería de fotos de mascotas
- Crear nuevos posts
- Interacción social (likes, comentarios)

## 🎨 Diseño

### Colores
- **Primary**: Azul (#3B82F6)
- **Secondary**: Gris (#64748B)
- **Success**: Verde (#10B981)
- **Warning**: Amarillo (#F59E0B)
- **Error**: Rojo (#EF4444)

### Componentes
- **Cards**: Contenedores con sombras suaves
- **Buttons**: Botones con estados hover y focus
- **Forms**: Formularios con validación
- **Navigation**: Barra lateral con navegación

## 🔌 API Endpoints

La aplicación utiliza los siguientes endpoints:

### Mascotas
- `GET /api/pets` - Obtener todas las mascotas
- `POST /api/pets` - Crear nueva mascota
- `GET /api/pets/{id}` - Obtener mascota por ID
- `PUT /api/pets/{id}` - Actualizar mascota
- `DELETE /api/pets/{id}` - Eliminar mascota
- `POST /api/pets/{id}/image` - Subir imagen de mascota

### Posts
- `GET /api/posts` - Obtener posts con paginación
- `POST /api/posts` - Crear nuevo post
- `DELETE /api/posts/{id}` - Eliminar post

## 🚀 Scripts Disponibles

```bash
# Desarrollo
npm start

# Construcción para producción
npm run build

# Ejecutar tests
npm test

# Eyectar configuración (irreversible)
npm run eject
```

## 📦 Construcción para Producción

```bash
npm run build
```

Esto creará una carpeta `build` con la aplicación optimizada para producción.

## 🔍 Desarrollo

### Estructura de Componentes

Los componentes siguen un patrón consistente:

```typescript
interface ComponentProps {
  // Props del componente
}

const Component: React.FC<ComponentProps> = ({ prop1, prop2 }) => {
  // Lógica del componente
  return (
    // JSX
  );
};

export default Component;
```

### Gestión de Estado

- **React Query**: Para datos del servidor
- **React Hook Form**: Para formularios
- **useState**: Para estado local simple

### Estilos

- **Tailwind CSS**: Clases utilitarias
- **Componentes personalizados**: En `index.css`
- **Responsive Design**: Mobile-first approach

## 🐛 Troubleshooting

### Problemas Comunes

1. **Error de CORS**:
   - Verificar que el backend esté ejecutándose
   - Revisar configuración de proxy

2. **Error de API**:
   - Verificar URL en `.env`
   - Revisar logs del servidor

3. **Error de TypeScript**:
   - Ejecutar `npm install` para instalar tipos
   - Verificar versiones de dependencias

## 📄 Licencia

Este proyecto es parte de la aplicación Pets y está bajo la misma licencia.

## 🤝 Contribución

1. Fork el proyecto
2. Crear una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abrir un Pull Request

## 📞 Soporte

Para soporte técnico, contacta al equipo de desarrollo. 