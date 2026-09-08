import React, { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import * as XLSX from 'xlsx';
import { Card, CardContent } from '../components/ui/Card';
import { Table, TableHeader, TableBody, TableRow, TableHead, TableCell } from '../components/ui/Table';
import { Button } from '../components/ui/Button';
import { Input } from '../components/ui/Input';
import { Modal } from '../components/ui/Modal';

export default function Genres() {
  const [genres, setGenres] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  // Modal state
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [formData, setFormData] = useState({ name: '', description: '' });
  const [isSaving, setIsSaving] = useState(false);

  useEffect(() => {
    fetchGenres();
  }, []);

  async function fetchGenres() {
    setIsLoading(true);
    try {
      const { data, error } = await supabase
        .from('genres')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) throw error;
      setGenres(data || []);
    } catch (error) {
      console.error("Error fetching genres:", error);
    } finally {
      setIsLoading(false);
    }
  }

  const handleOpenModal = (genre = null) => {
    if (genre) {
      setEditingId(genre.id);
      setFormData({ name: genre.name, description: genre.description || '' });
    } else {
      setEditingId(null);
      setFormData({ name: '', description: '' });
    }
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
    setEditingId(null);
  };

  const handleSave = async (e) => {
    e.preventDefault();
    setIsSaving(true);
    try {
      if (editingId) {
        const { error } = await supabase
          .from('genres')
          .update(formData)
          .eq('id', editingId);
        if (error) throw error;
      } else {
        const { error } = await supabase
          .from('genres')
          .insert([formData]);
        if (error) throw error;
      }
      handleCloseModal();
      fetchGenres(); // Refresh list
    } catch (error) {
      console.error("Error saving genre:", error);
      alert("Failed to save genre.");
    } finally {
      setIsSaving(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Are you sure you want to delete this genre?")) return;
    try {
      const { error } = await supabase.from('genres').delete().eq('id', id);
      if (error) throw error;
      fetchGenres();
    } catch (error) {
      console.error("Error deleting genre:", error);
      alert("Cannot delete genre. It might be linked to tracks.");
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

      console.log("Parsed Excel Rows:", rows);

      if (!rows || rows.length < 2) {
        throw new Error(`File không có dữ liệu hoặc định dạng không đúng.`);
      }

      const headers = rows[0].map(h => h?.toString().toLowerCase().trim());
      const nameIndex = headers.indexOf('name');
      const descIndex = headers.indexOf('description');

      if (nameIndex === -1) {
        throw new Error("File Excel bắt buộc phải có cột 'name'.");
      }

      const genresToInsert = [];
      for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        if (!row[nameIndex]) continue;

        genresToInsert.push({
          name: row[nameIndex].toString().trim(),
          description: descIndex !== -1 && row[descIndex] ? row[descIndex].toString().trim() : null
        });
      }

      if (genresToInsert.length === 0) throw new Error("Không tìm thấy dữ liệu hợp lệ.");

      const { error } = await supabase.from('genres').insert(genresToInsert);
      if (error) throw error;

      alert(`Đã nhập thành công ${genresToInsert.length} thể loại!`);
      fetchGenres();
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
          <h1 className="page-title">Genres</h1>
          <p className="page-description">Manage music and sound genres.</p>
        </div>
        <div className="flex gap-3">
          <input
            type="file"
            accept=".xlsx, .xls"
            style={{ display: 'none' }}
            id="import-genres-file"
            onChange={handleImportExcel}
          />
          <Button variant="ghost" onClick={() => document.getElementById('import-genres-file').click()}>
            Import Excel
          </Button>
          <Button variant="primary" onClick={() => handleOpenModal()}>Add New Genre</Button>
        </div>
      </header>


      <div className="glass-panel overflow-hidden">
        <div className="overflow-x-auto">
          <Table>
            <TableHeader>
              <TableRow className="border-white/10 hover:bg-transparent bg-black/20">
                <TableHead className="text-gray-300 font-semibold h-14 px-6">Name</TableHead>
                <TableHead className="text-gray-300 font-semibold h-14">Description</TableHead>
                <TableHead className="text-gray-300 font-semibold h-14">Created At</TableHead>
                <TableHead className="text-right text-gray-300 font-semibold h-14 px-6">Actions</TableHead>
              </TableRow>
            </TableHeader>
          <TableBody>
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={4} className="text-center py-8 text-muted">Loading genres...</TableCell>
              </TableRow>
            ) : genres.length === 0 ? (
              <TableRow>
                <TableCell colSpan={4} className="text-center py-8 text-muted">No genres found.</TableCell>
              </TableRow>
            ) : (
              genres.map(genre => (
                <TableRow key={genre.id}>
                  <TableCell className="font-medium">{genre.name}</TableCell>
                  <TableCell>{genre.description || '-'}</TableCell>
                  <TableCell>{new Date(genre.created_at).toLocaleDateString()}</TableCell>
                  <TableCell>
                    <div className="flex gap-2">
                      <Button variant="ghost" size="sm" onClick={() => handleOpenModal(genre)}>Edit</Button>
                      <Button variant="danger" size="sm" onClick={() => handleDelete(genre.id)}>Delete</Button>
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
        title={editingId ? "Edit Genre" : "Add New Genre"}
      >
        <form onSubmit={handleSave} className="flex flex-col">
          <Input
            label="Genre Name"
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            required
            placeholder="e.g. Ambient, Nature"
          />
          <Input
            label="Description"
            value={formData.description}
            onChange={(e) => setFormData({ ...formData, description: e.target.value })}
            placeholder="A brief description"
          />
          <div className="flex justify-end gap-3 mt-4">
            <Button type="button" variant="ghost" onClick={handleCloseModal}>Cancel</Button>
            <Button type="submit" variant="primary" isLoading={isSaving}>Save</Button>
          </div>
        </form>
      </Modal>
    </div>
  );
}
