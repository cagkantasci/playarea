
<template>
  <div class="login-container">
    <h2>Giriş Yap</h2>
    <form @submit.prevent="onLogin">
      <input v-model="email" type="email" placeholder="E-posta" required />
      <input v-model="password" type="password" placeholder="Şifre" required />
      <button type="submit">Giriş</button>
    </form>
    <p v-if="auth.error" style="color:red">{{ auth.error }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '../stores/auth';

const email = ref('');
const password = ref('');
const router = useRouter();
const auth = useAuthStore();

async function onLogin() {
  const success = await auth.login(email.value, password.value);
  if (success) {
    router.push('/');
  }
}
</script>

<style scoped>
.login-container {
  max-width: 400px;
  margin: 40px auto;
  padding: 2rem;
  border: 1px solid #eee;
  border-radius: 8px;
  background: #fff;
}
.login-container input {
  display: block;
  width: 100%;
  margin-bottom: 1rem;
  padding: 0.5rem;
}
.login-container button {
  width: 100%;
  padding: 0.5rem;
  background: #42b983;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 1rem;
}
</style>
