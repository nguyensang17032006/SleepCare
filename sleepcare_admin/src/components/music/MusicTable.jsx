import React, { useRef, useState } from 'react';
import { Card, CardContent } from '../ui/Card';
import { Table, TableHeader, TableBody, TableRow, TableHead, TableCell } from '../ui/Table';
import { Button } from '../ui/Button';
import { Play, Pause, Music } from 'lucide-react';

export function MusicTable({ tracks, onEdit, onDelete, isLoading }) {
  // Audio preview state local to the table
  const [playingId, setPlayingId] = useState(null);
  const audioRef = useRef(null);

  const togglePlay = (track) => {
    if (!audioRef.current) return;

    if (playingId === track.id) {
      audioRef.current.pause();
      setPlayingId(null);
    } else {
      audioRef.current.src = track.audio_url;
      audioRef.current.play();
      setPlayingId(track.id);
    }
  };

  return (
    <div className="glass-panel overflow-hidden">
      <div className="overflow-x-auto">
        <Table>
          <TableHeader>
            <TableRow className="border-white/10 hover:bg-transparent bg-black/20">
              <TableHead className="text-gray-300 font-semibold h-14 px-6">Track Details</TableHead>
              <TableHead className="text-gray-300 font-semibold h-14">Duration</TableHead>
              <TableHead className="text-gray-300 font-semibold h-14">Status</TableHead>
              <TableHead className="text-right text-gray-300 font-semibold h-14 px-6">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading ? (
              <TableRow className="border-white/5 border-b-0">
                <TableCell colSpan={4} className="text-center py-8 text-gray-500">Loading tracks...</TableCell>
              </TableRow>
            ) : tracks.length === 0 ? (
              <TableRow className="border-white/5 border-b-0">
                <TableCell colSpan={4} className="text-center py-8 text-gray-500">No tracks found.</TableCell>
              </TableRow>
            ) : (
              tracks.map(track => (
                <TableRow key={track.id} className="border-white/5 hover:bg-white/[0.02] transition-colors">
                  <TableCell className="font-medium py-3">
                    <div className="flex items-center gap-3">
                      {track.audio_url ? (
                        <button
                          onClick={() => togglePlay(track)}
                          className="w-9 h-9 rounded-full bg-indigo-500/10 text-indigo-400 flex items-center justify-center shrink-0 hover:bg-indigo-500 hover:text-white transition-all shadow-[0_0_10px_rgba(99,102,241,0)] hover:shadow-[0_0_15px_rgba(99,102,241,0.4)]"
                          title={playingId === track.id ? "Pause" : "Play"}
                        >
                          {playingId === track.id ? <Pause size={18} fill="currentColor" /> : <Play size={18} fill="currentColor" className="ml-0.5" />}
                        </button>
                      ) : (
                        <div className="w-9 h-9" />
                      )}
                      {track.cover_url ? (
                        <img src={track.cover_url} alt="Cover" className="w-11 h-11 rounded-lg object-cover flex-shrink-0 border border-white/5 shadow-sm" />
                      ) : (
                        <div className="w-11 h-11 rounded-lg bg-indigo-500/10 border border-indigo-500/20 flex items-center justify-center text-indigo-400 flex-shrink-0">
                          <Music size={20} />
                        </div>
                      )}
                      <div className="flex flex-col justify-center min-w-0">
                        <div className="font-bold text-gray-100 mb-0.5 truncate text-sm">{track.title}</div>
                        <div className="text-[11px] text-gray-500 uppercase tracking-wider font-semibold">{track.sleep_stage?.replace('_', ' ') || 'No Stage'}</div>
                      </div>
                    </div>
                  </TableCell>
                  <TableCell className="text-gray-400 text-sm py-3">
                    {Math.floor(track.duration_seconds / 60)}:{(track.duration_seconds % 60).toString().padStart(2, '0')}
                  </TableCell>
                  <TableCell className="py-3">
                    <span className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium border ${track.is_published ? 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20' : 'bg-gray-500/10 text-gray-400 border-gray-500/20'}`}>
                      {track.is_published ? 'Published' : 'Draft'}
                    </span>
                  </TableCell>
                  <TableCell className="py-3">
                    <div className="flex gap-2 justify-end whitespace-nowrap">
                      <Button variant="ghost" size="sm" onClick={() => onEdit(track)} className="h-8 px-3 text-xs text-gray-400 hover:text-white hover:bg-white/5 border border-transparent hover:border-white/10">Edit</Button>
                      <Button variant="danger" size="sm" onClick={() => onDelete(track.id)} className="h-8 px-3 text-xs bg-rose-500/10 text-rose-400 hover:bg-rose-500 hover:text-white border border-rose-500/20 hover:border-rose-500">Delete</Button>
                    </div>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>
      <audio
        ref={audioRef}
        onEnded={() => setPlayingId(null)}
        onPause={() => setPlayingId(null)}
      />

    </div>
  )
}
