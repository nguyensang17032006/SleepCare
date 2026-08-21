import React, { useEffect, useState } from 'react';
import { Routes, Route, Navigate, useNavigate } from 'react-router-dom';
import { supabase } from './lib/supabase';
import { Sidebar } from './components/layout/Sidebar';
import { Topbar } from './components/layout/Topbar';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Users from './pages/Users';
import Music from './pages/Music';
import Artists from './pages/Artists';
import Genres from './pages/Genres';

function App() {
  const [session, setSession] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    // Check active session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setIsLoading(false);
    });

    // Listen for auth changes
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session);
    });

    return () => subscription.unsubscribe();
  }, [navigate]);

  const handleLogout = async () => {
    await supabase.auth.signOut();
    navigate('/login');
  };

  if (isLoading) {
    return (
      <div className="flex h-screen w-screen items-center justify-center bg-black text-white">
        <div className="spinner"></div>
      </div>
    );
  }

  return (
    <Routes>
      <Route
        path="/login"
        element={<Login />}
      />

      {/* Protected Routes */}
      <Route
        path="/"
        element={
          session ? (
            <div className="flex h-screen w-full bg-[#0B0E14] overflow-hidden">
              <Sidebar onLogout={handleLogout} />
              <div className="flex-1 flex flex-col h-full overflow-y-auto relative">
                <Topbar user={session.user} />
                <Dashboard />
              </div>
            </div>
          ) : (
            <Navigate to="/login" replace />
          )
        }
      />

      <Route
        path="/users"
        element={
          session ? (
            <div className="flex h-screen w-full bg-[#0B0E14] overflow-hidden">
              <Sidebar onLogout={handleLogout} />
              <div className="flex-1 flex flex-col h-full overflow-y-auto relative">
                <Topbar user={session.user} />
                <Users />
              </div>
            </div>
          ) : (
            <Navigate to="/login" replace />
          )
        }
      />

      <Route
        path="/music"
        element={
          session ? (
            <div className="flex h-screen w-full bg-[#0B0E14] overflow-hidden">
              <Sidebar onLogout={handleLogout} />
              <div className="flex-1 flex flex-col h-full overflow-y-auto relative">
                <Topbar user={session.user} />
                <Music />
              </div>
            </div>
          ) : (
            <Navigate to="/login" replace />
          )
        }
      />

      <Route
        path="/artists"
        element={
          session ? (
            <div className="flex h-screen w-full bg-[#0B0E14] overflow-hidden">
              <Sidebar onLogout={handleLogout} />
              <div className="flex-1 flex flex-col h-full overflow-y-auto relative">
                <Topbar user={session.user} />
                <Artists />
              </div>
            </div>
          ) : (
            <Navigate to="/login" replace />
          )
        }
      />

      <Route
        path="/genres"
        element={
          session ? (
            <div className="flex h-screen w-full bg-[#0B0E14] overflow-hidden">
              <Sidebar onLogout={handleLogout} />
              <div className="flex-1 flex flex-col h-full overflow-y-auto relative">
                <Topbar user={session.user} />
                <Genres />
              </div>
            </div>
          ) : (
            <Navigate to="/login" replace />
          )
        }
      />

      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}

export default App;
