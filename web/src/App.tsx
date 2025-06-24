import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Layout from './components/Layout';
import Dashboard from './pages/Dashboard';
import PetsList from './pages/PetsList';
import AddPet from './pages/AddPet';
import PetDetail from './pages/PetDetail';
import EditPet from './pages/EditPet';
import Posts from './pages/Posts';
import AddPost from './pages/AddPost';
import Calendar from './pages/Calendar';
import Vaccinations from './pages/Vaccinations';
import Settings from './pages/Settings';

function App() {
  return (
    <div className="App">
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<Dashboard />} />
          <Route path="pets" element={<PetsList />} />
          <Route path="pets/add" element={<AddPet />} />
          <Route path="pets/:id" element={<PetDetail />} />
          <Route path="pets/:id/edit" element={<EditPet />} />
          <Route path="posts" element={<Posts />} />
          <Route path="posts/add" element={<AddPost />} />
          <Route path="calendar" element={<Calendar />} />
          <Route path="vaccinations" element={<Vaccinations />} />
          <Route path="settings" element={<Settings />} />
        </Route>
      </Routes>
    </div>
  );
}

export default App; 