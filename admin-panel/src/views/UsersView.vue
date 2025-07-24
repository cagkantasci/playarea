

<template>
  <div>
    <h2>Kullanıcılar</h2>
    <button @click="fetchUsers">Yenile</button>
    <button @click="showAdd = true">Yeni Kullanıcı</button>
    <input v-model="search" placeholder="Kullanıcı ara..." style="margin: 1rem 0;" />
    <ul>
      <li v-for="user in paginatedUsers" :key="user.id">
        {{ user.name }} ({{ user.email }})
        <button @click="editUser(user)">Düzenle</button>
        <button @click="deleteUser(user)">Sil</button>
      </li>
    </ul>
    <div style="margin: 1rem 0;">
      <button @click="prevPage" :disabled="page === 1">&lt;</button>
      Sayfa {{ page }} / {{ totalPages }}
      <button @click="nextPage" :disabled="page === totalPages">&gt;</button>
    </div>
    <div v-if="showAdd || editing">
      <form @submit.prevent="saveUser">
        <input v-model="form.name" placeholder="Ad Soyad" required />
        <input v-model="form.email" placeholder="E-posta" required />
        <input v-model="form.password" placeholder="Şifre" :required="!editing" type="password" />
        <div v-if="error" style="color: red; font-size: 0.9rem; margin-bottom: 0.5rem;">{{ error }}</div>
        <button type="submit">Kaydet</button>
        <button type="button" @click="cancelForm">İptal</button>
      </form>
    </div>
  </div>
</template>


<script setup>
import { ref, inject, computed, nextTick, watch } from 'vue';
import axios from '../axios';



const users = ref([]);
const showAdd = ref(false);
const editing = ref(null);
const form = ref({ name: '', email: '', password: '' });
const error = ref('');
const notify = inject('notify');
const search = ref('');


const page = ref(1);
const pageSize = 10;

const filteredUsers = computed(() => {
  if (!search.value) return users.value;
  return users.value.filter(u =>
    u.name.toLowerCase().includes(search.value.toLowerCase()) ||
    u.email.toLowerCase().includes(search.value.toLowerCase())
  );
});

const totalPages = computed(() => Math.max(1, Math.ceil(filteredUsers.value.length / pageSize)));

const paginatedUsers = computed(() => {
  const start = (page.value - 1) * pageSize;
  return filteredUsers.value.slice(start, start + pageSize);
});

function nextPage() {
  if (page.value < totalPages.value) {
    page.value++;
    nextTick(() => window.scrollTo({ top: 0, behavior: 'smooth' }));
  }
}

function prevPage() {
  if (page.value > 1) {
    page.value--;
    nextTick(() => window.scrollTo({ top: 0, behavior: 'smooth' }));
  }
}

watch(filteredUsers, () => { page.value = 1; });


async function fetchUsers() {
  try {
    const res = await axios.get('/users');
    users.value = res.data;
  } catch (e) {
    notify && notify({ message: 'Kullanıcılar yüklenemedi', type: 'error' });
  }
}

function editUser(user) {
  editing.value = { ...user };
  form.value = { name: user.name, email: user.email, password: '' };
  showAdd.value = false;
}



function deleteUser(user) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`/users/${user.id}`)
      .then(() => {
        fetchUsers();
        notify && notify({ message: 'Kullanıcı silindi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Kullanıcı silinemedi', type: 'error' });
      });
  }
}



function saveUser() {
  error.value = '';
  if (!form.value.name || form.value.name.trim().length < 2) {
    error.value = 'Ad en az 2 karakter olmalı.';
    return;
  }
  if (!form.value.email || !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(form.value.email)) {
    error.value = 'Geçerli bir e-posta girin.';
    return;
  }
  if (!editing.value && (!form.value.password || form.value.password.length < 4)) {
    error.value = 'Şifre en az 4 karakter olmalı.';
    return;
  }
  if (editing.value) {
    const data = { name: form.value.name, email: form.value.email };
    if (form.value.password) data.password = form.value.password;
    axios.put(`/users/${editing.value.id}`, data)
      .then(() => {
        editing.value = null;
        form.value = { name: '', email: '', password: '' };
        fetchUsers();
        notify && notify({ message: 'Kullanıcı güncellendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Kullanıcı güncellenemedi', type: 'error' });
      });
  } else {
    axios.post('/users', form.value)
      .then(() => {
        showAdd.value = false;
        form.value = { name: '', email: '', password: '' };
        fetchUsers();
        notify && notify({ message: 'Kullanıcı eklendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Kullanıcı eklenemedi', type: 'error' });
      });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
  form.value = { name: '', email: '', password: '' };
  error.value = '';
}

fetchUsers();
</script>
