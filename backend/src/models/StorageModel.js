import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
dotenv.config();

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error("Missing SUPABASE_URL or SUPABASE_KEY in .env");
}

export const supabase = createClient(supabaseUrl, supabaseKey);

export class StorageModel {
  static async uploadFile(bucket, path, fileBuffer, contentType) {
    const { data, error } = await supabase.storage
      .from(bucket)
      .upload(path, fileBuffer, {
        contentType: contentType,
        upsert: false
      });

    if (error) throw error;
    return data;
  }

  static getPublicUrl(bucket, path) {
    const { data: { publicUrl } } = supabase.storage
      .from(bucket)
      .getPublicUrl(path);
    return publicUrl;
  }
}
