import React from 'react';
import { useQuery } from 'react-query';
import { Link } from 'react-router-dom';
import { Plus } from 'lucide-react';
import { postApi } from '../services/api';
import PostCard from '../components/PostCard';

const Posts: React.FC = () => {
  const { data: postsResponse, isLoading } = useQuery('posts', () => postApi.getAll(0, 20));

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Posts</h1>
          <p className="text-gray-600 mt-2">Comparte fotos de tus mascotas</p>
        </div>
        <Link to="/posts/add" className="btn btn-primary flex items-center space-x-2">
          <Plus className="w-4 h-4" />
          <span>Crear Post</span>
        </Link>
      </div>

      {postsResponse && postsResponse.posts.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {postsResponse.posts.map((post) => (
            <PostCard key={post.id} post={post} />
          ))}
        </div>
      ) : (
        <div className="card text-center py-12">
          <p className="text-gray-600">No hay posts disponibles</p>
        </div>
      )}
    </div>
  );
};

export default Posts; 