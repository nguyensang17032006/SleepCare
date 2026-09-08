import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import { Button } from '../components/ui/Button';
import { Input } from '../components/ui/Input';
import { Card, CardContent, CardHeader } from '../components/ui/Card';
import './Login.css';

export default function Login() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    // If already logged in, verify admin and redirect
    supabase.auth.getSession().then(async ({ data: { session } }) => {
      if (session) {
        const { data } = await supabase.from('admin_users').select('*').eq('user_id', session.user.id).single();
        if (data) navigate('/');
      }
    });
  }, [navigate]);

  const handleLogin = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setError(null);

    try {
      const { data, error: signInError } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (signInError) throw signInError;

      // Check if user is in admin_users table
      const { data: adminData, error: adminError } = await supabase
        .from('admin_users')
        .select('*')
        .eq('user_id', data.user.id)
        .single();

      if (adminError) {
        console.error("Lỗi khi kiểm tra admin_users (RLS có thể đang bật):", adminError);
      }

      if (adminError || !adminData) {
        await supabase.auth.signOut();
        throw new Error('Tài khoản của bạn chưa được cấp quyền Admin.');
      }

      // Successfully logged in as admin
      navigate('/');
    } catch (err) {
      setError(err.message || 'Có lỗi xảy ra khi đăng nhập.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="login-container">
      <div className="login-glow"></div>
      <Card className="login-card">
        <CardHeader
          title="SleepCare Admin"
          description="Sign in to access the management dashboard"
          className="text-center"
        />
        <CardContent>
          <form onSubmit={handleLogin}>
            {error && <div className="login-error">{error}</div>}

            <Input
              label="Email"
              type="email"
              placeholder="admin@sleepcare.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />

            <Input
              label="Password"
              type="password"
              placeholder="••••••••"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />

            <Button
              type="submit"
              variant="primary"
              size="lg"
              className="w-full mt-4"
              isLoading={isLoading}
            >
              Sign In
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
