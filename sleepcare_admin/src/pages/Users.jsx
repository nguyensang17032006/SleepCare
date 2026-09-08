import React, { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import { Card, CardContent } from '../components/ui/Card';
import { Table, TableHeader, TableBody, TableRow, TableHead, TableCell } from '../components/ui/Table';
import { Button } from '../components/ui/Button';
import { Input } from '../components/ui/Input';
import { Modal } from '../components/ui/Modal';

export default function Users() {
  const [users, setUsers] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');

  // Modal State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);
  const [sessions, setSessions] = useState([]);
  const [isLoadingSessions, setIsLoadingSessions] = useState(false);

  useEffect(() => {
    async function fetchUsers() {
      try {
        const { data, error } = await supabase
          .from('profile_sleep_app')
          .select('*')
          .order('created_at', { ascending: false })
          .limit(50);

        if (error) throw error;
        setUsers(data || []);
      } catch (error) {
        console.error("Error fetching users:", error);
      } finally {
        setIsLoading(false);
      }
    }

    fetchUsers();
  }, []);

  const handleViewUser = async (user) => {
    setSelectedUser(user);
    setIsModalOpen(true);
    setIsLoadingSessions(true);

    try {
      const { data, error } = await supabase
        .from('listening_sessions')
        .select('*, tracks(title)')
        .eq('user_id', user.id)
        .order('start_time', { ascending: false })
        .limit(10);

      if (error) throw error;
      setSessions(data || []);
    } catch (error) {
      console.error("Error fetching sessions:", error);
    } finally {
      setIsLoadingSessions(false);
    }
  };

  const filteredUsers = users.filter(user =>
    (user.full_name?.toLowerCase() || '').includes(searchTerm.toLowerCase()) ||
    (user.email?.toLowerCase() || '').includes(searchTerm.toLowerCase())
  );

  return (
    <div className="page-container">
      <header className="page-header">
        <div>
          <h1 className="page-title">Users</h1>
          <p className="page-description">Manage SleepCare app users and track status.</p>
        </div>
        <div className="flex gap-4">
          <Input
            placeholder="Search users..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            style={{ marginBottom: 0 }}
          />
          <Button variant="primary">Export CSV</Button>
        </div>
      </header>


      <div className="glass-panel overflow-hidden">
        <div className="overflow-x-auto">
          <Table>
            <TableHeader>
              <TableRow className="border-white/10 hover:bg-transparent bg-black/20">
                <TableHead className="text-gray-300 font-semibold h-14 px-6">User ID</TableHead>
                <TableHead className="text-gray-300 font-semibold h-14">Name</TableHead>
                <TableHead className="text-gray-300 font-semibold h-14">Email</TableHead>
                <TableHead className="text-gray-300 font-semibold h-14">Onboarding</TableHead>
                <TableHead className="text-gray-300 font-semibold h-14">Created At</TableHead>
                <TableHead className="text-right text-gray-300 font-semibold h-14 px-6">Actions</TableHead>
              </TableRow>
            </TableHeader>
          <TableBody>
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-8 text-muted">
                  Loading users...
                </TableCell>
              </TableRow>
            ) : filteredUsers.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-8 text-muted">
                  No users found.
                </TableCell>
              </TableRow>
            ) : (
              filteredUsers.map(user => (
                <TableRow key={user.id}>
                  <TableCell><code className="text-xs">{user.id.substring(0, 8)}...</code></TableCell>
                  <TableCell className="font-medium">{user.full_name || 'N/A'}</TableCell>
                  <TableCell>{user.email}</TableCell>
                  <TableCell>
                    <span className={`px-2 py-1 rounded-full text-xs ${user.onboarding_completed ? 'bg-green-500/20 text-green-400' : 'bg-yellow-500/20 text-yellow-400'}`}>
                      {user.onboarding_completed ? 'Completed' : 'Pending'}
                    </span>
                  </TableCell>
                  <TableCell>{new Date(user.created_at).toLocaleDateString()}</TableCell>
                  <TableCell>
                    <Button variant="ghost" size="sm" onClick={() => handleViewUser(user)}>View Stats</Button>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
        </div>
      </div>

      <Modal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="User Details & Status"
      >
        {selectedUser && (
          <div className="flex flex-col gap-4">
            <div className="grid grid-cols-2 gap-4 border-b border-white/10 pb-4">
              <div>
                <span className="text-muted text-xs block">Full Name</span>
                <span className="font-medium">{selectedUser.full_name || 'N/A'}</span>
              </div>
              <div>
                <span className="text-muted text-xs block">Email</span>
                <span className="font-medium">{selectedUser.email}</span>
              </div>
              <div>
                <span className="text-muted text-xs block">Birth Date</span>
                <span className="font-medium">{selectedUser.birth_day ? new Date(selectedUser.birth_day).toLocaleDateString() : 'N/A'}</span>
              </div>
              <div>
                <span className="text-muted text-xs block">Timezone</span>
                <span className="font-medium">{selectedUser.timezone}</span>
              </div>
            </div>

            <div>
              <h3 className="font-medium mb-3">Recent Listening Sessions</h3>
              {isLoadingSessions ? (
                <div className="text-center py-4 text-muted">Loading sessions...</div>
              ) : sessions.length === 0 ? (
                <div className="text-center py-4 text-muted">No recent sessions found.</div>
              ) : (
                <div className="border border-white/10 rounded-md overflow-hidden">
                  <table className="w-full text-sm text-left">
                    <thead className="bg-white/5 border-b border-white/10">
                      <tr>
                        <th className="p-2 font-medium">Track</th>
                        <th className="p-2 font-medium">Duration</th>
                        <th className="p-2 font-medium">Time</th>
                      </tr>
                    </thead>
                    <tbody>
                      {sessions.map(session => (
                        <tr key={session.id} className="border-b border-white/5 last:border-0">
                          <td className="p-2">{session.tracks?.title || 'Unknown Track'}</td>
                          <td className="p-2">{Math.floor(session.duration_played / 60)}m {session.duration_played % 60}s</td>
                          <td className="p-2 text-muted">{new Date(session.start_time).toLocaleString()}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </div>

            <div className="flex justify-end mt-2">
              <Button variant="ghost" onClick={() => setIsModalOpen(false)}>Close</Button>
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
}
