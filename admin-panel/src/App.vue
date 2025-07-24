
<template>
  <Notification v-if="notification.message" :message="notification.message" :type="notification.type" :duration="notification.duration" />
  <nav style="margin-bottom: 2rem;">
    <router-link to="/">Dashboard</router-link> |
    <router-link to="/machines">Makineler</router-link> |
    <router-link to="/categories">Kategoriler</router-link> |
    <router-link to="/users">Kullanıcılar</router-link> |
    <router-link to="/roles">Roller</router-link> |
    <router-link to="/checklist-templates">Checklist Şablonları</router-link> |
    <router-link to="/checklist-items">Checklist Maddeleri</router-link> |
    <router-link to="/issues">Arıza Kayıtları</router-link> |
    <router-link to="/approvals">Onay Süreçleri</router-link> |
    <router-link to="/login">Çıkış</router-link>
  </nav>
  <router-view />
</template>

<script setup>
import { reactive, provide } from 'vue';
import Notification from './components/Notification.vue';

const notification = reactive({ message: '', type: 'success', duration: 3000 });

function notify({ message, type = 'success', duration = 3000 }) {
  notification.message = message;
  notification.type = type;
  notification.duration = duration;
}

provide('notify', notify);
</script>


<style scoped>
nav {
  font-size: 1.2rem;
  margin-bottom: 2rem;
}
nav a {
  margin-right: 1rem;
  text-decoration: none;
  color: #42b983;
}
nav a.router-link-exact-active {
  font-weight: bold;
  color: #35495e;
}
</style>
