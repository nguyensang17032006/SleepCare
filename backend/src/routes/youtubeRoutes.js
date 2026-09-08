import express from 'express';
import { YoutubeViewModel } from '../viewModels/YoutubeViewModel.js';

const router = express.Router();

router.post('/convert-youtube', async (req, res) => {
  try {
    const { url } = req.body;
    const result = await YoutubeViewModel.processYoutubeUrl(url);
    
    res.json({ 
      success: true, 
      url: result.publicUrl, 
      title: result.title,
      duration: result.durationSeconds
    });
  } catch (error) {
    console.error("Conversion error details:");
    console.error(error);
    res.status(500).json({ 
      success: false, 
      error: error.message || 'Failed to process YouTube link',
      stack: error.stack
    });
  }
});

export default router;
