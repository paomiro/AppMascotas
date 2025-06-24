import React, { useState } from 'react';
import { useMutation, useQueryClient } from 'react-query';
import { useNavigate } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import { Upload, X } from 'lucide-react';
import { petApi } from '../services/api';
import { Pet, PetSpecies } from '../types';
import toast from 'react-hot-toast';

interface AddPetFormData {
  name: string;
  species: PetSpecies;
  breed: string;
  birthDate: string;
  weight: number;
  color: string;
  microchipNumber?: string;
  ownerName: string;
  ownerPhone: string;
  ownerEmail: string;
}

const AddPet: React.FC = () => {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [selectedImage, setSelectedImage] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    reset,
  } = useForm<AddPetFormData>();

  const createPetMutation = useMutation(
    (data: AddPetFormData) => petApi.create(data),
    {
      onSuccess: async (pet) => {
        // Upload image if selected
        if (selectedImage) {
          try {
            await petApi.uploadImage(pet.id, selectedImage);
          } catch (error) {
            console.error('Error uploading image:', error);
            toast.error('Error al subir la imagen');
          }
        }

        queryClient.invalidateQueries('pets');
        toast.success('Mascota agregada exitosamente');
        navigate(`/pets/${pet.id}`);
      },
      onError: (error) => {
        console.error('Error creating pet:', error);
        toast.error('Error al crear la mascota');
      },
    }
  );

  const handleImageChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file) {
      setSelectedImage(file);
      const reader = new FileReader();
      reader.onload = (e) => {
        setImagePreview(e.target?.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  const removeImage = () => {
    setSelectedImage(null);
    setImagePreview(null);
  };

  const onSubmit = (data: AddPetFormData) => {
    createPetMutation.mutate(data);
  };

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Agregar Mascota</h1>
        <p className="text-gray-600 mt-2">Registra una nueva mascota en tu perfil</p>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Image Upload */}
        <div className="card">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Foto de la Mascota</h2>
          
          {imagePreview ? (
            <div className="relative">
              <img
                src={imagePreview}
                alt="Preview"
                className="w-full h-64 object-cover rounded-lg"
              />
              <button
                type="button"
                onClick={removeImage}
                className="absolute top-2 right-2 p-1 bg-red-500 text-white rounded-full hover:bg-red-600"
              >
                <X className="w-4 h-4" />
              </button>
            </div>
          ) : (
            <div className="border-2 border-dashed border-gray-300 rounded-lg p-8 text-center">
              <Upload className="w-12 h-12 text-gray-400 mx-auto mb-4" />
              <label className="cursor-pointer">
                <input
                  type="file"
                  accept="image/*"
                  onChange={handleImageChange}
                  className="hidden"
                />
                <span className="text-primary-600 hover:text-primary-700 font-medium">
                  Seleccionar imagen
                </span>
                <span className="text-gray-500"> o arrastrar aquí</span>
              </label>
              <p className="text-sm text-gray-500 mt-2">PNG, JPG hasta 5MB</p>
            </div>
          )}
        </div>

        {/* Basic Information */}
        <div className="card">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Información Básica</h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="label">Nombre *</label>
              <input
                type="text"
                {...register('name', { required: 'El nombre es obligatorio' })}
                className="input"
                placeholder="Nombre de la mascota"
              />
              {errors.name && (
                <p className="text-red-500 text-sm mt-1">{errors.name.message}</p>
              )}
            </div>

            <div>
              <label className="label">Especie *</label>
              <select
                {...register('species', { required: 'La especie es obligatoria' })}
                className="input"
              >
                <option value="">Seleccionar especie</option>
                <option value={PetSpecies.DOG}>Perro</option>
                <option value={PetSpecies.CAT}>Gato</option>
                <option value={PetSpecies.BIRD}>Ave</option>
                <option value={PetSpecies.RABBIT}>Conejo</option>
                <option value={PetSpecies.FISH}>Pez</option>
                <option value={PetSpecies.OTHER}>Otro</option>
              </select>
              {errors.species && (
                <p className="text-red-500 text-sm mt-1">{errors.species.message}</p>
              )}
            </div>

            <div>
              <label className="label">Raza *</label>
              <input
                type="text"
                {...register('breed', { required: 'La raza es obligatoria' })}
                className="input"
                placeholder="Raza de la mascota"
              />
              {errors.breed && (
                <p className="text-red-500 text-sm mt-1">{errors.breed.message}</p>
              )}
            </div>

            <div>
              <label className="label">Fecha de Nacimiento *</label>
              <input
                type="date"
                {...register('birthDate', { required: 'La fecha de nacimiento es obligatoria' })}
                className="input"
              />
              {errors.birthDate && (
                <p className="text-red-500 text-sm mt-1">{errors.birthDate.message}</p>
              )}
            </div>

            <div>
              <label className="label">Peso (kg) *</label>
              <input
                type="number"
                step="0.1"
                {...register('weight', { 
                  required: 'El peso es obligatorio',
                  min: { value: 0.1, message: 'El peso debe ser mayor a 0' },
                  max: { value: 500, message: 'El peso no puede ser mayor a 500 kg' }
                })}
                className="input"
                placeholder="0.0"
              />
              {errors.weight && (
                <p className="text-red-500 text-sm mt-1">{errors.weight.message}</p>
              )}
            </div>

            <div>
              <label className="label">Color *</label>
              <input
                type="text"
                {...register('color', { required: 'El color es obligatorio' })}
                className="input"
                placeholder="Color de la mascota"
              />
              {errors.color && (
                <p className="text-red-500 text-sm mt-1">{errors.color.message}</p>
              )}
            </div>

            <div>
              <label className="label">Número de Microchip</label>
              <input
                type="text"
                {...register('microchipNumber')}
                className="input"
                placeholder="Número de microchip (opcional)"
              />
            </div>
          </div>
        </div>

        {/* Owner Information */}
        <div className="card">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Información del Dueño</h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="label">Nombre del Dueño *</label>
              <input
                type="text"
                {...register('ownerName', { required: 'El nombre del dueño es obligatorio' })}
                className="input"
                placeholder="Nombre completo"
              />
              {errors.ownerName && (
                <p className="text-red-500 text-sm mt-1">{errors.ownerName.message}</p>
              )}
            </div>

            <div>
              <label className="label">Teléfono *</label>
              <input
                type="tel"
                {...register('ownerPhone', { required: 'El teléfono es obligatorio' })}
                className="input"
                placeholder="+52 55 1234 5678"
              />
              {errors.ownerPhone && (
                <p className="text-red-500 text-sm mt-1">{errors.ownerPhone.message}</p>
              )}
            </div>

            <div className="md:col-span-2">
              <label className="label">Email *</label>
              <input
                type="email"
                {...register('ownerEmail', { 
                  required: 'El email es obligatorio',
                  pattern: {
                    value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
                    message: 'Email inválido'
                  }
                })}
                className="input"
                placeholder="email@ejemplo.com"
              />
              {errors.ownerEmail && (
                <p className="text-red-500 text-sm mt-1">{errors.ownerEmail.message}</p>
              )}
            </div>
          </div>
        </div>

        {/* Submit */}
        <div className="flex justify-end space-x-4">
          <button
            type="button"
            onClick={() => navigate('/pets')}
            className="btn btn-secondary"
          >
            Cancelar
          </button>
          <button
            type="submit"
            disabled={isSubmitting}
            className="btn btn-primary"
          >
            {isSubmitting ? 'Guardando...' : 'Guardar Mascota'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default AddPet; 