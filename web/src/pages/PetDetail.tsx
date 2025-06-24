import React from 'react';
import { useParams, Link } from 'react-router-dom';
import { useQuery } from 'react-query';
import { Edit, Heart, Calendar, MapPin, Phone, Mail } from 'lucide-react';
import { petApi } from '../services/api';

const PetDetail: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const { data: pet, isLoading, error } = useQuery(['pet', id], () => petApi.getById(id!));

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  if (error || !pet) {
    return (
      <div className="text-center py-12">
        <Heart className="w-12 h-12 text-red-500 mx-auto mb-4" />
        <h3 className="text-lg font-medium text-gray-900 mb-2">Mascota no encontrada</h3>
        <p className="text-gray-600">La mascota que buscas no existe</p>
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <div className="flex justify-between items-start">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">{pet.name}</h1>
          <p className="text-gray-600 mt-2">{pet.breed}</p>
        </div>
        <Link to={`/pets/${pet.id}/edit`} className="btn btn-primary flex items-center space-x-2">
          <Edit className="w-4 h-4" />
          <span>Editar</span>
        </Link>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Pet Image */}
        <div className="card">
          {pet.imageData ? (
            <img
              src={`data:image/jpeg;base64,${pet.imageData}`}
              alt={pet.name}
              className="w-full h-96 object-cover rounded-lg"
            />
          ) : (
            <div className="w-full h-96 bg-gray-200 rounded-lg flex items-center justify-center text-6xl">
              🐾
            </div>
          )}
        </div>

        {/* Pet Information */}
        <div className="space-y-6">
          <div className="card">
            <h2 className="text-xl font-semibold text-gray-900 mb-4">Información Básica</h2>
            <div className="space-y-3">
              <div className="flex items-center space-x-3">
                <Heart className="w-5 h-5 text-gray-400" />
                <span className="text-gray-600">Edad:</span>
                <span className="font-medium">{pet.age} años</span>
              </div>
              <div className="flex items-center space-x-3">
                <Calendar className="w-5 h-5 text-gray-400" />
                <span className="text-gray-600">Peso:</span>
                <span className="font-medium">{pet.weight} kg</span>
              </div>
              <div className="flex items-center space-x-3">
                <MapPin className="w-5 h-5 text-gray-400" />
                <span className="text-gray-600">Color:</span>
                <span className="font-medium">{pet.color}</span>
              </div>
              {pet.microchipNumber && (
                <div className="flex items-center space-x-3">
                  <span className="text-gray-600">Microchip:</span>
                  <span className="font-medium">{pet.microchipNumber}</span>
                </div>
              )}
            </div>
          </div>

          <div className="card">
            <h2 className="text-xl font-semibold text-gray-900 mb-4">Información del Dueño</h2>
            <div className="space-y-3">
              <div className="flex items-center space-x-3">
                <span className="text-gray-600">Nombre:</span>
                <span className="font-medium">{pet.ownerName}</span>
              </div>
              <div className="flex items-center space-x-3">
                <Phone className="w-5 h-5 text-gray-400" />
                <span className="text-gray-600">Teléfono:</span>
                <span className="font-medium">{pet.ownerPhone}</span>
              </div>
              <div className="flex items-center space-x-3">
                <Mail className="w-5 h-5 text-gray-400" />
                <span className="text-gray-600">Email:</span>
                <span className="font-medium">{pet.ownerEmail}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default PetDetail; 