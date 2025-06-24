import React from 'react';
import { useParams } from 'react-router-dom';

const EditPet: React.FC = () => {
  const { id } = useParams<{ id: string }>();

  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-3xl font-bold text-gray-900 mb-6">Editar Mascota</h1>
      <div className="card">
        <p className="text-gray-600">Funcionalidad de edición en desarrollo...</p>
        <p className="text-sm text-gray-500 mt-2">ID de la mascota: {id}</p>
      </div>
    </div>
  );
};

export default EditPet; 