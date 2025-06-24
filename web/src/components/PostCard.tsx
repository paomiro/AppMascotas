import React from 'react';
import { Heart, MessageCircle, Share2 } from 'lucide-react';
import { Post } from '../types';
import { formatDistanceToNow } from 'date-fns';
import { es } from 'date-fns/locale';

interface PostCardProps {
  post: Post;
}

const PostCard: React.FC<PostCardProps> = ({ post }) => {
  const formatDate = (dateString: string) => {
    try {
      return formatDistanceToNow(new Date(dateString), { 
        addSuffix: true, 
        locale: es 
      });
    } catch {
      return 'Hace un momento';
    }
  };

  return (
    <div className="card hover:shadow-md transition-shadow">
      {post.imageData && (
        <div className="mb-4">
          <img
            src={`data:image/jpeg;base64,${post.imageData}`}
            alt="Post"
            className="w-full h-48 object-cover rounded-lg"
          />
        </div>
      )}
      
      <div className="flex items-center justify-between mb-3">
        <div className="flex items-center space-x-2">
          {post.petImageData ? (
            <img
              src={`data:image/jpeg;base64,${post.petImageData}`}
              alt={post.petName}
              className="w-8 h-8 rounded-full object-cover"
            />
          ) : (
            <div className="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center">
              <span className="text-sm font-medium text-gray-600">🐾</span>
            </div>
          )}
          <span className="font-medium text-gray-900">{post.petName}</span>
        </div>
        <span className="text-sm text-gray-500">{formatDate(post.createdAt)}</span>
      </div>
      
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-4">
          <button className="flex items-center space-x-1 text-gray-500 hover:text-red-500 transition-colors">
            <Heart className="w-4 h-4" />
            <span className="text-sm">{post.likes.length}</span>
          </button>
          
          <button className="flex items-center space-x-1 text-gray-500 hover:text-blue-500 transition-colors">
            <MessageCircle className="w-4 h-4" />
            <span className="text-sm">0</span>
          </button>
        </div>
        
        <button className="text-gray-500 hover:text-gray-700 transition-colors">
          <Share2 className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
};

export default PostCard; 