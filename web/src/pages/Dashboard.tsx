import React from 'react';
import { useQuery } from 'react-query';
import { Link } from 'react-router-dom';
import { 
  Heart, 
  Calendar, 
  Shield, 
  TrendingUp,
  Plus,
  Image as ImageIcon
} from 'lucide-react';
import { petApi, postApi } from '../services/api';
import { Pet, Post } from '../types';
import PetCard from '../components/PetCard';
import PostCard from '../components/PostCard';
import StatCard from '../components/StatCard';

const Dashboard: React.FC = () => {
  const { data: pets = [], isLoading: petsLoading } = useQuery<Pet[]>('pets', petApi.getAll);
  const { data: postsResponse, isLoading: postsLoading } = useQuery('posts', () => postApi.getAll(0, 5));

  const upcomingEvents = 0; // TODO: Implement events
  const overdueVaccinations = 0; // TODO: Implement vaccinations

  const stats = [
    {
      title: 'Mascotas',
      value: pets.length,
      icon: Heart,
      color: 'blue',
      href: '/pets'
    },
    {
      title: 'Próximos Eventos',
      value: upcomingEvents,
      icon: Calendar,
      color: 'green',
      href: '/calendar'
    },
    {
      title: 'Vacunas Vencidas',
      value: overdueVaccinations,
      icon: Shield,
      color: 'red',
      href: '/vaccinations'
    },
    {
      title: 'Posts',
      value: postsResponse?.posts.length || 0,
      icon: ImageIcon,
      color: 'purple',
      href: '/posts'
    }
  ];

  if (petsLoading || postsLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  return (
    <div className="space-y-8">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        <p className="text-gray-600 mt-2">Bienvenido a tu panel de gestión de mascotas</p>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat) => (
          <StatCard key={stat.title} {...stat} />
        ))}
      </div>

      {/* Quick Actions */}
      <div className="card">
        <h2 className="text-xl font-semibold text-gray-900 mb-4">Acciones Rápidas</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <Link
            to="/pets/add"
            className="flex items-center space-x-3 p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
          >
            <Plus className="w-6 h-6 text-primary-600" />
            <div>
              <h3 className="font-medium text-gray-900">Agregar Mascota</h3>
              <p className="text-sm text-gray-600">Registra una nueva mascota</p>
            </div>
          </Link>
          
          <Link
            to="/posts/add"
            className="flex items-center space-x-3 p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
          >
            <ImageIcon className="w-6 h-6 text-primary-600" />
            <div>
              <h3 className="font-medium text-gray-900">Crear Post</h3>
              <p className="text-sm text-gray-600">Comparte una foto de tu mascota</p>
            </div>
          </Link>
          
          <Link
            to="/calendar"
            className="flex items-center space-x-3 p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
          >
            <Calendar className="w-6 h-6 text-primary-600" />
            <div>
              <h3 className="font-medium text-gray-900">Ver Calendario</h3>
              <p className="text-sm text-gray-600">Gestiona eventos y citas</p>
            </div>
          </Link>
        </div>
      </div>

      {/* Recent Pets */}
      <div className="card">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-xl font-semibold text-gray-900">Mis Mascotas</h2>
          <Link to="/pets" className="text-primary-600 hover:text-primary-700 font-medium">
            Ver todas
          </Link>
        </div>
        
        {pets.length === 0 ? (
          <div className="text-center py-12">
            <Heart className="w-12 h-12 text-gray-400 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">No tienes mascotas registradas</h3>
            <p className="text-gray-600 mb-4">Agrega tu primera mascota para comenzar</p>
            <Link to="/pets/add" className="btn btn-primary">
              Agregar Mascota
            </Link>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {pets.slice(0, 3).map((pet) => (
              <PetCard key={pet.id} pet={pet} />
            ))}
          </div>
        )}
      </div>

      {/* Recent Posts */}
      {postsResponse && postsResponse.posts.length > 0 && (
        <div className="card">
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-xl font-semibold text-gray-900">Posts Recientes</h2>
            <Link to="/posts" className="text-primary-600 hover:text-primary-700 font-medium">
              Ver todos
            </Link>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {postsResponse.posts.slice(0, 3).map((post) => (
              <PostCard key={post.id} post={post} />
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default Dashboard; 