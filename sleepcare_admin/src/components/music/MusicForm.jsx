import React, { useState, useEffect } from 'react';
import { Card, CardContent } from '../ui/Card';
import { Button } from '../ui/Button';
import { Input } from '../ui/Input';
import { Select } from '../ui/Select';

export function MusicForm({ editingTrack, artists, genres, onSubmit, onCancel, isSaving }) {
  const [sourceType, setSourceType] = useState('upload'); // 'upload' or 'youtube'
  const [youtubeUrl, setYoutubeUrl] = useState('');
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    audio_url: '',
    cover_url: '',
    duration_seconds: 0,
    sleep_stage: '',
    is_published: false,
    artist_ids: [],
    genre_ids: []
  });
  const [audioFile, setAudioFile] = useState(null);
  const [coverFile, setCoverFile] = useState(null);
  const [artistSearch, setArtistSearch] = useState('');
  const [genreSearch, setGenreSearch] = useState('');

  useEffect(() => {
    if (editingTrack) {
      setFormData({
        title: editingTrack.title,
        description: editingTrack.description || '',
        audio_url: editingTrack.audio_url,
        cover_url: editingTrack.cover_url || '',
        duration_seconds: editingTrack.duration_seconds,
        sleep_stage: editingTrack.sleep_stage || '',
        is_published: editingTrack.is_published,
        artist_ids: editingTrack.track_artists?.map(ta => ta.artist_id) || [],
        genre_ids: editingTrack.track_genres?.map(tg => tg.genre_id) || []
      });
      setSourceType('upload');
      setYoutubeUrl('');
    } else {
      handleReset();
    }
  }, [editingTrack]);

  const handleReset = () => {
    setFormData({
      title: '',
      description: '',
      audio_url: '',
      cover_url: '',
      duration_seconds: 0,
      sleep_stage: '',
      is_published: false,
      artist_ids: [],
      genre_ids: []
    });
    setSourceType('upload');
    setYoutubeUrl('');
    setAudioFile(null);
    setCoverFile(null);
    setArtistSearch('');
    setGenreSearch('');
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSubmit(formData, audioFile, coverFile, sourceType, youtubeUrl);
  };

  const toggleArrayItem = (array, item) => {
    return array.includes(item) ? array.filter(i => i !== item) : [...array, item];
  };

  return (
    <div className="w-full">
      <form onSubmit={handleSubmit} className="flex flex-col gap-6">

        {/* --- BASIC INFO --- */}
        <div className="space-y-5">
          <h3 className="text-[11px] font-bold text-gray-500 uppercase tracking-wider mb-2">Basic Information</h3>

          <div className="space-y-2">
            <label className="text-sm font-medium text-gray-300">Track Title</label>
            <input className="w-full bg-[#131720] border border-white/10 rounded-md px-4 py-3 text-sm text-white focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all" value={formData.title} onChange={(e) => setFormData({ ...formData, title: e.target.value })} required placeholder="Enter track title" />
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium text-gray-300">Description</label>
            <textarea className="w-full bg-[#131720] border border-white/10 rounded-md px-4 py-3 text-sm text-white focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all resize-none" rows="3" value={formData.description} onChange={(e) => setFormData({ ...formData, description: e.target.value })} placeholder="Brief description..." />
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium text-gray-300">Sleep Stage</label>
            <Select
              className="w-full bg-[#131720] border border-white/10 rounded-lg px-4 py-3 text-sm text-white focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all"
              value={formData.sleep_stage}
              onChange={(e) => setFormData({ ...formData, sleep_stage: e.target.value })}
              options={[
                { value: 'relax', label: 'Relax' },
                { value: 'fall_asleep', label: 'Fall Asleep' },
                { value: 'deep_sleep', label: 'Deep Sleep' },
                { value: 'wake_up', label: 'Wake Up' }
              ]}
            />
          </div>
        </div>

        <div className="h-px w-full bg-white/5"></div>

        {/* --- MEDIA FILES --- */}
        <div className="space-y-5">
          <h3 className="text-[11px] font-bold text-gray-500 uppercase tracking-wider mb-2">Media Files</h3>

          <div className="space-y-2">
            <label className="text-sm font-medium text-gray-300">Audio Source</label>
            <div className="flex bg-[#131720] p-1 rounded-lg border border-white/10">
              <button
                type="button"
                onClick={() => setSourceType('upload')}
                className={`flex-1 py-1.5 text-sm font-medium rounded-md transition-colors ${sourceType === 'upload' ? 'bg-[#2a3040] text-white shadow-sm' : 'text-gray-500 hover:text-gray-300'}`}
              >
                Upload File
              </button>
              <button
                type="button"
                onClick={() => setSourceType('youtube')}
                className={`flex-1 py-1.5 text-sm font-medium rounded-md transition-colors ${sourceType === 'youtube' ? 'bg-[#2a3040] text-white shadow-sm' : 'text-gray-500 hover:text-gray-300'}`}
              >
                YouTube Link
              </button>
            </div>

            {sourceType === 'upload' ? (
              <div className="relative mt-2">
                <input
                  type="file" accept="audio/*"
                  onChange={(e) => {
                    const file = e.target.files[0];
                    setAudioFile(file);
                    if (file) {
                      const objectUrl = URL.createObjectURL(file);
                      const audio = new Audio(objectUrl);
                      audio.onloadedmetadata = () => {
                        setFormData(prev => ({ ...prev, duration_seconds: Math.round(audio.duration) }));
                        URL.revokeObjectURL(objectUrl);
                      };
                    }
                  }}
                  className="block w-full text-sm text-gray-400 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-xs file:font-semibold file:bg-blue-500/10 file:text-blue-400 hover:file:bg-blue-500/20 file:transition-colors bg-[#131720] border border-white/10 rounded-lg p-2 cursor-pointer"
                />
              </div>
            ) : (
              <div className="mt-2">
                <input className="w-full bg-[#131720] border border-white/10 rounded-lg px-4 py-3 text-sm text-white focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all" placeholder="Paste YouTube link (e.g. https://youtu.be/...)" value={youtubeUrl} onChange={(e) => setYoutubeUrl(e.target.value)} />
              </div>
            )}
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium text-gray-300">Cover Image</label>
            <input
              type="file" accept="image/*"
              onChange={(e) => setCoverFile(e.target.files[0])}
              className="block w-full text-sm text-gray-400 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-xs file:font-semibold file:bg-purple-500/10 file:text-purple-400 hover:file:bg-purple-500/20 file:transition-colors bg-[#131720] border border-white/10 rounded-lg p-2 cursor-pointer"
            />
            {formData.cover_url && !coverFile && (
              <div className="flex items-center gap-2 mt-2 px-3 py-2 bg-emerald-500/10 border border-emerald-500/20 rounded-lg text-xs text-emerald-400">
                <span className="w-2 h-2 rounded-full bg-emerald-500"></span>
                <span className="truncate">Current Image Present</span>
              </div>
            )}
          </div>
        </div>

        <div className="h-px w-full bg-white/5"></div>

        {/* --- TAGS & VISIBILITY --- */}
        <div className="space-y-5">
          <h3 className="text-[11px] font-bold text-gray-500 uppercase tracking-wider mb-2">Tags & Visibility</h3>

          <div className="flex gap-4">
            <div className="flex-1 space-y-2">
              <label className="text-sm font-medium text-gray-300">Artists</label>
              <input type="text" placeholder="Search artists..." className="w-full bg-[#131720] border border-white/10 rounded-lg px-3 py-3 text-xs text-white focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all" value={artistSearch} onChange={(e) => setArtistSearch(e.target.value)} />
              <div className="bg-[#131720] border border-white/10 rounded-lg p-2 h-36 overflow-y-auto mt-2 custom-scrollbar">
                {artists.filter(a => a.name.toLowerCase().includes(artistSearch.toLowerCase())).map(artist => (
                  <label key={artist.id} className="flex items-center gap-2 px-2 py-1.5 rounded hover:bg-white/5 cursor-pointer text-sm text-gray-300 hover:text-white transition-colors group">
                    <input type="checkbox" className="rounded border-gray-600 text-blue-500 focus:ring-blue-500/30 bg-[#1a1f2e] group-hover:border-gray-400 transition-colors" checked={formData.artist_ids.includes(artist.id)} onChange={() => setFormData({ ...formData, artist_ids: toggleArrayItem(formData.artist_ids, artist.id) })} />
                    <span className="truncate">{artist.name}</span>
                  </label>
                ))}
              </div>
            </div>
            <div className="flex-1 space-y-2">
              <label className="text-sm font-medium text-gray-300">Genres</label>
              <input type="text" placeholder="Search genres..." className="w-full bg-[#131720] border border-white/10 rounded-lg px-3 py-3 text-xs text-white focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all" value={genreSearch} onChange={(e) => setGenreSearch(e.target.value)} />
              <div className="bg-[#131720] border border-white/10 rounded-lg p-2 h-36 overflow-y-auto mt-2 custom-scrollbar">
                {genres.filter(g => g.name.toLowerCase().includes(genreSearch.toLowerCase())).map(genre => (
                  <label key={genre.id} className="flex items-center gap-2 px-2 py-1.5 rounded hover:bg-white/5 cursor-pointer text-sm text-gray-300 hover:text-white transition-colors group">
                    <input type="checkbox" className="rounded border-gray-600 text-blue-500 focus:ring-blue-500/30 bg-[#1a1f2e] group-hover:border-gray-400 transition-colors" checked={formData.genre_ids.includes(genre.id)} onChange={() => setFormData({ ...formData, genre_ids: toggleArrayItem(formData.genre_ids, genre.id) })} />
                    <span className="truncate">{genre.name}</span>
                  </label>
                ))}
              </div>
            </div>
          </div>

          <div className="pt-2">
            <label className="flex items-center gap-3 p-4 rounded-xl bg-[#131720] border border-white/10 cursor-pointer hover:bg-[#1a1f2e] transition-all group">
              <input type="checkbox" checked={formData.is_published} onChange={(e) => setFormData({ ...formData, is_published: e.target.checked })} className="w-4 h-4 rounded text-blue-500 bg-[#0B0E14] border-gray-600 focus:ring-blue-500/30 focus:ring-offset-0" />
              <div className="flex flex-col">
                <span className="text-sm font-medium text-gray-200 group-hover:text-white transition-colors">Publish immediately</span>
                <span className="text-xs text-gray-500 mt-0.5">Make this track visible to users in the mobile app</span>
              </div>
            </label>
          </div>
        </div>

        <div className="pt-2 flex justify-end gap-3">
          <Button type="button" variant="ghost" onClick={onCancel}>
            Cancel
          </Button>
          <button type="submit" disabled={isSaving} className="px-6 py-2.5 rounded-lg text-sm font-semibold text-white bg-blue-600 hover:bg-blue-500 transition-all active:scale-[0.98] disabled:opacity-50 disabled:pointer-events-none">
            {isSaving ? 'Processing...' : (editingTrack ? 'Save Changes' : '  Create Track')}
          </button>
        </div>
      </form>
    </div>
  );
}
