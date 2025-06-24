import React from 'react';
import { Link } from 'react-router-dom';
import { Heart, Calendar, MapPin } from 'lucide-react';
import { Pet } from '../types';

interface PetCardProps {
  pet: Pet;
}

const PetCard: React.FC<PetCardProps> = ({ pet }) => {
  const getSpeciesIcon = (species: string) => {
    switch (species) {
      case 'Perro':
        return '🐕';
      case 'Gato':
        return '🐱';
      case 'Ave':
        return '🐦';
      case 'Conejo':
        return '🐰';
      case 'Pez':
        return '🐠';
      default:
        return '🐾';
    }
  };

  return (
    <Link to={`/pets/${pet.id}`} className="card hover:shadow-md transition-shadow">
      <div className="flex items-start space-x-4">
        <div className="flex-shrink-0">
          {pet.imageData ? (
            <img
              src={`data:image/jpeg;base64,${pet.imageData}`}
              alt={pet.name}
              className="w-16 h-16 rounded-lg object-cover"
            />
          ) : (
            <div className="w-16 h-16 bg-gray-200 rounded-lg flex items-center justify-center text-2xl">
              {getSpeciesIcon(pet.species)}
            </div>
          )}
        </div>
        
        <div className="flex-1 min-w-0">
          <h3 className="text-lg font-semibold text-gray-900 truncate">{pet.name}</h3>
          <p className="text-sm text-gray-600">{pet.breed}</p>
          
          <div className="mt-2 space-y-1">
            <div className="flex items-center text-sm text-gray-500">
              <Heart className="w-4 h-4 mr-1" />
              <span>{pet.age} años</span>
            </div>
            
            <div className="flex items-center text-sm text-gray-500">
              <Calendar className="w-4 h-4 mr-1" />
              <span>{pet.weight} kg</span>
            </div>
            
            <div className="flex items-center text-sm text-gray-500">
              <MapPin className="w-4 h-4 mr-1" />
              <span>{pet.color}</span>
            </div>
          </div>
        </div>
      </div>
    </Link>
  );
};

export default PetCard; 