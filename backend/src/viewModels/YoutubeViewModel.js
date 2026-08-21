import youtubedl from 'youtube-dl-exec';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { StorageModel } from '../models/StorageModel.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const tmpDir = path.join(__dirname, '..', '..', 'tmp');

// Ensure tmp directory exists
if (!fs.existsSync(tmpDir)) {
  fs.mkdirSync(tmpDir, { recursive: true });
}

export class YoutubeViewModel {
  static async processYoutubeUrl(url) {
    if (!url) {
      throw new Error('Đường dẫn bị trống.');
    }

    let cleanUrl = url.trim();
    if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
      cleanUrl = 'https://' + cleanUrl;
    }

    console.log(`Starting conversion for: ${cleanUrl}`);
    
    // Fetch info using yt-dlp
    let info;
    try {
      info = await youtubedl(cleanUrl, { dumpSingleJson: true, noWarnings: true });
    } catch (err) {
      console.error(err);
      throw new Error('Đường dẫn không hợp lệ hoặc video bị giới hạn độ tuổi / bản quyền.');
    }

    const title = info.title.replace(/[^\w\s-]/g, '').trim();
    const fileName = `${Date.now()}-${title}.webm`;
    const tempFilePath = path.join(tmpDir, fileName);

    console.log(`Downloading audio for: ${info.title}`);

    // Download audio using yt-dlp
    await youtubedl(cleanUrl, {
      format: 'bestaudio/best',
      output: tempFilePath,
      noWarnings: true
    });

    console.log(`Downloaded to temp file: ${tempFilePath}`);

    // Read the file and upload to Model
    const fileBuffer = fs.readFileSync(tempFilePath);
    
    await StorageModel.uploadFile('music-audio', `tracks/${fileName}`, fileBuffer, 'audio/webm');
    const publicUrl = StorageModel.getPublicUrl('music-audio', `tracks/${fileName}`);

    // Clean up temp file
    fs.unlinkSync(tempFilePath);

    return {
      publicUrl,
      title: info.title,
      durationSeconds: info.duration
    };
  }
}
