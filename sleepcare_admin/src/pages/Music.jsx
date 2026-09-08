import React, { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import { MusicForm } from '../components/music/MusicForm';
import { MusicTable } from '../components/music/MusicTable';
import { Modal } from '../components/ui/Modal';
import { Button } from '../components/ui/Button';

export default function Music() {
  const [tracks, setTracks] = useState([]);
  const [artists, setArtists] = useState([]);
  const [genres, setGenres] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [editingTrack, setEditingTrack] = useState(null);

  const [successMsg, setSuccessMsg] = useState('');
  const [errorMsg, setErrorMsg] = useState('');

  const [isModalOpen, setIsModalOpen] = useState(false);

  useEffect(() => {
    fetchData();
  }, []);

  const handleOpenModal = (track = null) => {
    setEditingTrack(track);
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setEditingTrack(null);
    setIsModalOpen(false);
  };

  const showSuccess = (msg) => {
    setSuccessMsg(msg);
    setTimeout(() => setSuccessMsg(''), 3000);
  };

  const showError = (msg) => {
    setErrorMsg(msg);
    setTimeout(() => setErrorMsg(''), 5000);
  };

  async function fetchData() {
    setIsLoading(true);
    try {
      const [tracksRes, artistsRes, genresRes] = await Promise.all([
        supabase.from('tracks').select('*, track_artists(artist_id), track_genres(genre_id)').order('created_at', { ascending: false }),
        supabase.from('artists').select('id, name'),
        supabase.from('genres').select('id, name')
      ]);

      if (tracksRes.error) throw tracksRes.error;
      setTracks(tracksRes.data || []);
      setArtists(artistsRes.data || []);
      setGenres(genresRes.data || []);
    } catch (error) {
      console.error("Error fetching data:", error);
      showError("Failed to fetch data.");
    } finally {
      setIsLoading(false);
    }
  }

  const handleSave = async (formData, audioFile, coverFile, sourceType, youtubeUrl) => {
    setIsSaving(true);
    setErrorMsg('');
    setSuccessMsg('');

    try {
      let finalAudioUrl = formData.audio_url;
      const targetUrl = sourceType === 'youtube' ? youtubeUrl : null;

      const isYouTubeUrl = (url) => url && (url.includes('youtube.com/') || url.includes('youtu.be/'));

      if (sourceType === 'youtube' && isYouTubeUrl(targetUrl)) {
        const response = await fetch('http://localhost:3000/api/convert-youtube', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ url: targetUrl })
        });

        const result = await response.json();
        if (!response.ok || !result.success) {
          throw new Error("Lỗi tải nhạc từ YouTube: " + (result.error || 'Unknown error'));
        }

        finalAudioUrl = result.url;
        if (!formData.title && result.title) formData.title = result.title;
        if (result.duration && (!formData.duration_seconds || formData.duration_seconds === 0)) {
          formData.duration_seconds = result.duration;
        }
      } else if (sourceType === 'upload' && audioFile) {
        const fileExt = audioFile.name.split('.').pop();
        const fileName = `${Date.now()}-${Math.random().toString(36).substring(2)}.${fileExt}`;
        const filePath = `tracks/${fileName}`;

        const { error: uploadError } = await supabase.storage
          .from('music-audio')
          .upload(filePath, audioFile);

        if (uploadError) throw new Error("Lỗi tải file âm thanh lên Storage: " + uploadError.message);

        const { data: { publicUrl } } = supabase.storage
          .from('music-audio')
          .getPublicUrl(filePath);

        finalAudioUrl = publicUrl;
      }

      if (!finalAudioUrl) throw new Error("Vui lòng tải lên file âm thanh hoặc nhập URL.");

      let finalCoverUrl = formData.cover_url;
      if (coverFile) {
        const fileExt = coverFile.name.split('.').pop();
        const fileName = `${Date.now()}-${Math.random().toString(36).substring(2)}.${fileExt}`;
        const filePath = `covers/${fileName}`;

        const { error: uploadError } = await supabase.storage
          .from('music-covers')
          .upload(filePath, coverFile);

        if (uploadError) throw new Error("Lỗi tải ảnh bìa lên Storage: " + uploadError.message);

        const { data: { publicUrl } } = supabase.storage
          .from('music-covers')
          .getPublicUrl(filePath);

        finalCoverUrl = publicUrl;
      }

      const trackData = {
        title: formData.title,
        description: formData.description,
        audio_url: finalAudioUrl,
        cover_url: finalCoverUrl,
        duration_seconds: parseInt(formData.duration_seconds) || 0,
        sleep_stage: formData.sleep_stage || null,
        is_published: formData.is_published
      };

      let currentTrackId = editingTrack?.id;

      if (currentTrackId) {
        const { error } = await supabase.from('tracks').update(trackData).eq('id', currentTrackId);
        if (error) throw error;

        await supabase.from('track_artists').delete().eq('track_id', currentTrackId);
        await supabase.from('track_genres').delete().eq('track_id', currentTrackId);
      } else {
        const { data, error } = await supabase.from('tracks').insert([trackData]).select().single();
        if (error) throw error;
        currentTrackId = data.id;
      }

      if (formData.artist_ids.length > 0) {
        const artistInserts = formData.artist_ids.map((id, index) => ({
          track_id: currentTrackId,
          artist_id: id,
          artist_role: 'primary',
          position: index + 1
        }));
        await supabase.from('track_artists').insert(artistInserts);
      }

      if (formData.genre_ids.length > 0) {
        const genreInserts = formData.genre_ids.map(id => ({
          track_id: currentTrackId,
          genre_id: id
        }));
        await supabase.from('track_genres').insert(genreInserts);
      }

      handleCloseModal();
      fetchData();
      showSuccess(currentTrackId === editingTrack?.id ? 'Track updated successfully!' : 'Track created successfully!');
    } catch (error) {
      console.error("Error saving track:", error);
      showError(error.message || "Failed to save track.");
    } finally {
      setIsSaving(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Are you sure you want to delete this track?")) return;
    try {
      await supabase.from('track_artists').delete().eq('track_id', id);
      await supabase.from('track_genres').delete().eq('track_id', id);
      const { error } = await supabase.from('tracks').delete().eq('id', id);
      if (error) throw error;
      fetchData();
      if (editingTrack?.id === id) setEditingTrack(null);
      showSuccess('Track deleted successfully!');
    } catch (error) {
      console.error("Error deleting track:", error);
      showError("Cannot delete track.");
    }
  };

  return (
    <div className="page-container space-y-6">
      <header className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-6">
        <div>
          <h1 className="text-2xl font-bold tracking-tight text-white sm:text-3xl">Music Directory</h1>
          <p className="text-gray-400 text-sm mt-1">Upload sleep tracks, manage artists, link genres, and examine content.</p>
        </div>
        <div className="flex gap-3">
          <Button onClick={() => handleOpenModal()}>
            + Add New Track
          </Button>
        </div>
      </header>

      {/* Notification messages */}
      {successMsg && (
        <div className="p-4 bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 rounded-xl text-sm font-medium animate-in fade-in slide-in-from-top-2 duration-300 mb-6">
          {successMsg}
        </div>
      )}
      {errorMsg && (
        <div className="p-4 bg-rose-500/10 text-rose-400 border border-rose-500/20 rounded-xl text-sm font-medium animate-in fade-in slide-in-from-top-2 duration-300 mb-6">
          {errorMsg}
        </div>
      )}

      {/* Table Component */}
      <div className="w-full">
        <MusicTable
          tracks={tracks}
          onEdit={handleOpenModal}
          onDelete={handleDelete}
          isLoading={isLoading}
        />
      </div>

      <Modal
        isOpen={isModalOpen}
        onClose={handleCloseModal}
        title={editingTrack ? "Edit Track" : "Add New Track"}
      >
        <MusicForm
          editingTrack={editingTrack}
          artists={artists}
          genres={genres}
          onSubmit={handleSave}
          onCancel={handleCloseModal}
          isSaving={isSaving}
        />
      </Modal>
    </div>
  );
}
