import React from 'react';
import { NavLink } from 'react-router-dom';
import './Sidebar.css';

export function Sidebar({ onLogout }) {
  const navItems = [
    { name: 'Dashboard', path: '/', icon: '📊' },
    { name: 'Users', path: '/users', icon: '👥' },
    { name: 'Music Tracks', path: '/music', icon: '🎵' },
    { name: 'Artists', path: '/artists', icon: '🧑‍🎤' },
    { name: 'Genres', path: '/genres', icon: '🎧' },
  ];

  return (
    <aside className="sidebar">
      <div className="sidebar-header">
        <div className="logo-icon">🌙</div>
        <h2 className="logo-text">SleepCare</h2>
      </div>
      
      <nav className="sidebar-nav">
        {navItems.map((item) => (
          <NavLink
            key={item.path}
            to={item.path}
            className={({ isActive }) => `nav-item ${isActive ? 'active' : ''}`}
          >
            <span className="nav-icon">{item.icon}</span>
            <span className="nav-label">{item.name}</span>
          </NavLink>
        ))}
      </nav>
      
      <div className="sidebar-footer">
        <button className="logout-btn" onClick={onLogout}>
          <span className="nav-icon">🚪</span>
          <span className="nav-label">Logout</span>
        </button>
      </div>
    </aside>
  );
}
