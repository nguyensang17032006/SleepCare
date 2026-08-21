import React from 'react';
import './Topbar.css';

export function Topbar({ user }) {
  return (
    <header className="topbar">
      <div className="topbar-left">
        {/* Can add breadcrumbs or page title here if needed */}
      </div>
      
      <div className="topbar-right">
        <div className="user-profile">
          <div className="avatar">
            {user?.email?.charAt(0).toUpperCase() || 'A'}
          </div>
          <div className="user-info">
            <span className="user-email">{user?.email || 'admin@sleepcare.com'}</span>
            <span className="user-role">Administrator</span>
          </div>
        </div>
      </div>
    </header>
  );
}
