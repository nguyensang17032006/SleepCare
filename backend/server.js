import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import youtubeRoutes from './src/routes/youtubeRoutes.js';

dotenv.config();

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

// MVVM Routes
app.use('/api', youtubeRoutes);

app.get('/', (req, res) => res.send('SleepCare Backend API is running!'));

app.listen(port, () => console.log(`Backend server listening on port ${port}!`));