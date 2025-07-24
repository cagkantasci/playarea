import { defineStore } from 'pinia';
import axios from 'axios';

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
    token: localStorage.getItem('token') || '',
    error: ''
  }),
  actions: {
    async login(email, password) {
      this.error = '';
      try {
        const res = await axios.post('http://localhost:8000/api/login', { email, password });
        this.token = res.data.token;
        localStorage.setItem('token', this.token);
        this.user = res.data.user;
        return true;
      } catch (e) {
        this.error = 'Giriş başarısız!';
        return false;
      }
    },
    logout() {
      this.user = null;
      this.token = '';
      localStorage.removeItem('token');
    }
  }
});
