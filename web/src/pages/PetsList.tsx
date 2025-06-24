import React, { useState } from 'react';
import { useQuery } from 'react-query';
import { Link } from 'react-router-dom';
import { Search, Plus, Filter, Heart } from 'lucide-react';
import { petApi } from '../services/api';
import { Pet, PetSpecies } from '../types';
import PetCard from '../components/PetCard';

const PetsList: React.FC = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedSpecies, setSelectedSpecies] = useState<string>('all');
  
  const { data: pets = [], isLoading, error } = useQuery<Pet[]>('pets', petApi.getAll);

  const filteredPets = pets.filter(pet => {
    const matchesSearch = pet.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         pet.breed.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesSpecies = selectedSpecies === 'all' || pet.species === selectedSpecies;
    return matchesSearch && matchesSpecies;
  });

  const speciesOptions = [
    { value: 'all', label: 'Todas las especies' },
    { value: PetSpecies.DOG, label: 'Perros' },
    { value: PetSpecies.CAT, label: 'Gatos' },
    { value: PetSpecies.BIRD, label: 'Aves' },
    { value: PetSpecies.RABBIT, label: 'Conejos' },
    { value: PetSpecies.FISH, label: 'Peces' },
    { value: PetSpecies.OTHER, label: 'Otros' },
  ];

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="text-center py-12">
        <Heart className="w-12 h-12 text-red-500 mx-auto mb-4" />
        <h3 className="text-lg font-medium text-gray-900 mb-2">Error al cargar mascotas</h3>
        <p className="text-gray-600">Intenta recargar la página</p>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Mis Mascotas</h1>
          <p className="text-gray-600 mt-2">Gestiona todas tus mascotas en un solo lugar</p>
        </div>
        <Link to="/pets/add" className="btn btn-primary flex items-center space-x-2">
          <Plus className="w-4 h-4" />
          <span>Agregar Mascota</span>
        </Link>
      </div>

      {/* Filters */}
      <div className="card">
        <div className="flex flex-col md:flex-row gap-4">
          {/* Search */}
          <div className="flex-1">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
              <input
                type="text"
                placeholder="Buscar por nombre o raza..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="input pl-10"
              />
            </div>
          </div>

          {/* Species Filter */}
          <div className="md:w-64">
            <select
              value={selectedSpecies}
              onChange={(e) => setSelectedSpecies(e.target.value)}
              className="input"
            >
              {speciesOptions.map(option => (
                <option key={option.value} value={option.value}>
                  {option.label}
                </option>
              ))}
            </select>
          </div>
        </div>
      </div>

      {/* Results */}
      <div>
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-xl font-semibold text-gray-900">
            {filteredPets.length} mascota{filteredPets.length !== 1 ? 's' : ''} encontrada{filteredPets.length !== 1 ? 's' : ''}
          </h2>
        </div>

        {filteredPets.length === 0 ? (
          <div className="card text-center py-12">
            <Heart className="w-12 h-12 text-gray-400 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">
              {pets.length === 0 ? 'No tienes mascotas registradas' : 'No se encontraron mascotas'}
            </h3>
            <p className="text-gray-600 mb-4">
              {pets.length === 0 
                ? 'Agrega tu primera mascota para comenzar' 
                : 'Intenta ajustar los filtros de búsqueda'
              }
            </p>
            {pets.length === 0 && (
              <Link to="/pets/add" className="btn btn-primary">
                Agregar Mascota
              </Link>
            )}
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredPets.map((pet) => (
              <PetCard key={pet.id} pet={pet} />
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default PetsList; 