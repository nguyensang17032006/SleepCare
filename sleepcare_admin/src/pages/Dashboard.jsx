import React, { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import { Card, CardContent, CardHeader } from '../components/ui/Card';
import './Dashboard.css';

export default function Dashboard() {
  const [stats, setStats] = useState({
    users: 0,
    tracks: 0,
    assessments: 0,
    playlists: 0
  });
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    async function fetchStats() {
      try {
        // Fetch each stat individually to prevent one RLS error from crashing the whole dashboard
        const fetchCount = async (table) => {
          const res = await supabase.from(table).select('*', { count: 'exact', head: true });
          if (res.error) {
            console.warn(`Could not fetch ${table} (possibly RLS 403):`, res.error.message);
            return 0;
          }
          return res.count || 0;
        };

        const usersCount = await fetchCount('profile_sleep_app');
        const tracksCount = await fetchCount('tracks');
        const assessmentsCount = await fetchCount('sleep_assessments');
        const playlistsCount = await fetchCount('playlists');

        setStats({
          users: usersCount,
          tracks: tracksCount,
          assessments: assessmentsCount,
          playlists: playlistsCount
        });
      } catch (error) {
        console.error("Error in fetchStats process:", error);
      } finally {
        setIsLoading(false);
      }
    }

    fetchStats();
  }, []);

  return (
    <div className="page-container">
      <header className="page-header">
        <div>
          <h1 className="page-title">Dashboard Overview</h1>
          <p className="page-description">Welcome back to the SleepCare admin portal.</p>
        </div>
      </header>

      <div className="stats-grid">
        <StatCard title="Total Users" value={stats.users} icon="👥" isLoading={isLoading} />
        <StatCard title="Sleep Tracks" value={stats.tracks} icon="🎵" isLoading={isLoading} />
        <StatCard title="Assessments" value={stats.assessments} icon="📋" isLoading={isLoading} />
        <StatCard title="Playlists" value={stats.playlists} icon="🎧" isLoading={isLoading} />
      </div>

      <div className="dashboard-content mt-8">
        <Card className="flex-1">
          <CardHeader title="Recent Activity" description="Latest actions in the application" />
          <CardContent>
            <div className="empty-state">
              <span className="empty-icon">📈</span>
              <p>Activity chart will be displayed here</p>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

function StatCard({ title, value, icon, isLoading }) {
  return (
    <Card className="stat-card">
      <CardContent className="stat-content">
        <div className="stat-info">
          <h3 className="stat-title">{title}</h3>
          <div className="stat-value">
            {isLoading ? <div className="skeleton-pulse"></div> : value}
          </div>
        </div>
        <div className="stat-icon-wrapper">
          <span className="stat-icon">{icon}</span>
        </div>
      </CardContent>
    </Card>
  );
}
