import React, { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import * as XLSX from 'xlsx';
import { Card, CardContent } from '../components/ui/Card';
import { Table, TableHeader, TableBody, TableRow, TableHead, TableCell } from '../components/ui/Table';
import { Button } from '../components/ui/Button';
import { Input } from '../components/ui/Input';
import { Modal } from '../components/ui/Modal';

export default function Artists() {
  const [artists, setArtists] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  // Modal state
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [formData, setFormData] = useState({ name: '', biography: '', avatar_url: '' });
  const [avatarFile, setAvatarFile] = useState(null);
  const [isSaving, setIsSaving] = useState(false);
  const [isUploading, setIsUploading] = useState(false);

  useEffect(() => {
    fetchArtists();
  }, []);

  async function fetchArtists() {
    setIsLoading(true);
    try {
      const { data, error } = await supabase
        .from('artists')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) throw error;
      setArtists(data || []);
    } catch (error) {
      console.error("Error fetching artists:", error);
    } finally {
      setIsLoading(false);
    }
  }

  const handleOpenModal = (artist = null) => {
    if (artist) {
      setEditingId(artist.id);
      setFormData({
        name: artist.name,
        biography: artist.biography || '',
        avatar_url: artist.avatar_url || ''
      });
    } else {
      setEditingId(null);
      setFormData({ name: '', biography: '', avatar_url: '' });
    }
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
    setEditingId(null);
    setAvatarFile(null);
  };

  const handleSave = async (e) => {
    e.preventDefault();
    setIsSaving(true);
    setIsUploading(true);
    try {
      let finalAvatarUrl = formData.avatar_url;

      if (avatarFile) {
        const fileExt = avatarFile.name.split('.').pop();
        const fileName = `${Date.now()}-${Math.random().toString(36).substring(2)}.${fileExt}`;
        const filePath = `avatars/${fileName}`;

        const { data: uploadData, error: uploadError } = await supabase.storage
          .from('music-covers')
          .upload(filePath, avatarFile);

        if (uploadError) {
          throw new Error("Lỗi tải ảnh (chắc chắn bạn đã tạo bucket 'music-covers' ở chế độ Public): " + uploadError.message);
        }

        const { data: { publicUrl } } = supabase.storage
          .from('music-covers')
          .getPublicUrl(filePath);

        finalAvatarUrl = publicUrl;
      }

      const artistData = {
        name: formData.name,
        biography: formData.biography,
        avatar_url: finalAvatarUrl
      };

      if (editingId) {
        const { error } = await supabase
          .from('artists')
          .update(artistData)
          .eq('id', editingId);
        if (error) throw error;
      } else {
        const { error } = await supabase
          .from('artists')
          .insert([artistData]);
        if (error) throw error;
      }
      handleCloseModal();
      fetchArtists(); // Refresh list
    } catch (error) {
      console.error("Error saving artist:", error);
      alert(error.message || "Failed to save artist.");
    } finally {
      setIsSaving(false);
      setIsUploading(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Are you sure you want to delete this artist?")) return;
    try {
      const { error } = await supabase.from('artists').delete().eq('id', id);
      if (error) throw error;
      fetchArtists();
    } catch (error) {
      console.error("Error deleting artist:", error);
      alert("Cannot delete artist. They might be linked to tracks.");
    }
  };

  const handleImportExcel = async (e) => {
    const file = e.target.files[0];
    if (!file) return;

    setIsLoading(true);
    try {
      const data = await file.arrayBuffer();
      const workbook = XLSX.read(data);
      const sheetName = workbook.SheetNames[0];
      const worksheet = workbook.Sheets[sheetName];
      const rows = XLSX.utils.sheet_to_json(worksheet, { header: 1 });

      if (!rows || rows.length < 2) {
        throw new Error("File không có dữ liệu (cần ít nhất 1 dòng tiêu đề và 1 dòng dữ liệu).");
      }

      const headers = rows[0].map(h => h?.toString().toLowerCase().trim());
      const nameIndex = headers.indexOf('name');
      const bioIndex = headers.indexOf('biography');
      const avatarIndex = headers.indexOf('avatar_url');

      if (nameIndex === -1) {
        throw new Error("File Excel bắt buộc phải có cột 'name'.");
      }

      const artistsToInsert = [];
      for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        if (!row[nameIndex]) continue;

        artistsToInsert.push({
          name: row[nameIndex].toString().trim(),
          biography: bioIndex !== -1 && row[bioIndex] ? row[bioIndex].toString().trim() : null,
          avatar_url: avatarIndex !== -1 && row[avatarIndex] ? row[avatarIndex].toString().trim() : null
        });
      }

      if (artistsToInsert.length === 0) throw new Error("Không tìm thấy dữ liệu hợp lệ.");

      const { error } = await supabase.from('artists').insert(artistsToInsert);
      if (error) throw error;

      alert(`Đã nhập thành công ${artistsToInsert.length} nghệ sĩ/tác giả!`);
      fetchArtists();
    } catch (error) {
      console.error("Import error:", error);
      alert("Lỗi nhập file: " + error.message);
    } finally {
      setIsLoading(false);
      e.target.value = '';
    }
  };

  return (
    <div className="page-container">
      <header className="page-header">
        <div>
          <h1 className="page-title">Artists</h1>
          <p className="page-description">Manage music authors and narrators.</p>
        </div>
        <div className="flex gap-3">
          <input
            type="file"
            accept=".xlsx, .xls"
            style={{ display: 'none' }}
            id="import-artists-file"
            onChange={handleImportExcel}
          />
          <Button variant="ghost" onClick={() => document.getElementById('import-artists-file').click()}>
            Import Excel
          </Button>
          <Button variant="primary" onClick={() => handleOpenModal()}>Add New Artist</Button>
        </div>
      </header>


      <div className="glass-panel overflow-hidden">
        <div className="overflow-x-auto">
          <Table>
            <TableHeader>
              <TableRow className="border-white/10 hover:bg-transparent bg-black/20">
                <TableHead className="text-gray-300 font-semibold h-14 px-6">Artist</TableHead>
                <TableHead className="text-gray-300 font-semibold h-14">Biography</TableHead>
                <TableHead className="text-gray-300 font-semibold h-14">Created At</TableHead>
                <TableHead className="text-right text-gray-300 font-semibold h-14 px-6">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {isLoading ? (
                <TableRow>
                  <TableCell colSpan={4} className="text-center py-8 text-muted">Loading artists...</TableCell>
                </TableRow>
              ) : artists.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={4} className="text-center py-8 text-muted">No artists found.</TableCell>
                </TableRow>
              ) : (
                artists.map(artist => (
                  <TableRow key={artist.id}>
                    <TableCell className="font-medium">
                      <div className="flex items-center gap-3">
                        {artist.avatar_url ? (
                          <img src={artist.avatar_url} alt="Avatar" className="w-10 h-10 rounded-full object-cover border border-white/10" />
                        ) : (
                          <div className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center">
                            🧑‍🎤
                          </div>
                        )}
                        <span>{artist.name}</span>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="truncate" style={{ maxWidth: '300px' }}>
                        {artist.biography || '-'}
                      </div>
                    </TableCell>
                    <TableCell>{new Date(artist.created_at).toLocaleDateString()}</TableCell>
                    <TableCell>
                      <div className="flex gap-2">
                        <Button variant="ghost" size="sm" onClick={() => handleOpenModal(artist)}>Edit</Button>
                        <Button variant="danger" size="sm" onClick={() => handleDelete(artist.id)}>Delete</Button>
                      </div>
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
            onClose={handleCloseModal}
            title={editingId ? "Edit Artist" : "Add New Artist"}
          >
            <form onSubmit={handleSave} className="flex flex-col">
              <Input
                label="Artist Name"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                required
                placeholder="e.g. John Doe, Sleep Sounds Inc."
              />
              <div className="input-group">
                <label className="input-label block mb-1">Avatar Image</label>
                <input
                  type="file"
                  accept="image/*"
                  onChange={(e) => setAvatarFile(e.target.files[0])}
                  className="input-field mb-2 text-sm"
                  style={{ padding: '8px' }}
                />
                {formData.avatar_url && !avatarFile && (
                  <div className="text-xs text-green-400 mt-1 truncate p-2 bg-green-500/10 rounded border border-green-500/20">
                    Current Image: {formData.avatar_url.split('/').pop()}
                  </div>
                )}
              </div>
              <div className="input-group">
                <label className="input-label">Biography</label>
                <textarea
                  className="input-field"
                  rows="4"
                  value={formData.biography}
                  onChange={(e) => setFormData({ ...formData, biography: e.target.value })}
                  placeholder="Artist background..."
                />
              </div>
              <div className="flex justify-end gap-3 mt-4">
                <Button type="button" variant="ghost" onClick={handleCloseModal}>Cancel</Button>
                <Button type="submit" variant="primary" isLoading={isSaving || isUploading}>
                  {isUploading && avatarFile ? 'Uploading...' : 'Save'}
                </Button>
              </div>
            </form>
          </Modal>
        </div>
        );
}
