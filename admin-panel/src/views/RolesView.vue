
<template>
  <div>
    <h2>Roller</h2>
    <button @click="fetchRoles">Yenile</button>
    <button @click="showAdd = true">Yeni Rol</button>
    <input v-model="search" placeholder="Rol ara..." style="margin: 1rem 0;" />
    <ul>
      <li v-for="role in paginatedRoles" :key="role.id">
        {{ role.name }}
        <button @click="editRole(role)">Düzenle</button>
        <button @click="deleteRole(role)">Sil</button>
      </li>
    </ul>
    <div style="margin: 1rem 0;">
      <button @click="prevPage" :disabled="page === 1">&lt;</button>
      Sayfa {{ page }} / {{ totalPages }}
      <button @click="nextPage" :disabled="page === totalPages">&gt;</button>
    </div>
    <div v-if="showAdd || editing">
      <form @submit.prevent="saveRole">
        <input v-model="form.name" placeholder="Rol adı" required />
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



const roles = ref([]);
const showAdd = ref(false);
const editing = ref(null);
const form = ref({ name: '' });
const error = ref('');
const notify = inject('notify');
const search = ref('');


const page = ref(1);
const pageSize = 10;

const filteredRoles = computed(() => {
  if (!search.value) return roles.value;
  return roles.value.filter(r => r.name.toLowerCase().includes(search.value.toLowerCase()));
});

const totalPages = computed(() => Math.max(1, Math.ceil(filteredRoles.value.length / pageSize)));

const paginatedRoles = computed(() => {
  const start = (page.value - 1) * pageSize;
  return filteredRoles.value.slice(start, start + pageSize);
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

watch(filteredRoles, () => { page.value = 1; });


async function fetchRoles() {
  try {
    const res = await axios.get('/roles');
    roles.value = res.data;
  } catch (e) {
    notify && notify({ message: 'Roller yüklenemedi', type: 'error' });
  }
}

function editRole(role) {
  editing.value = { ...role };
  form.value = { name: role.name };
  showAdd.value = false;
}



function deleteRole(role) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`/roles/${role.id}`)
      .then(() => {
        fetchRoles();
        notify && notify({ message: 'Rol silindi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Rol silinemedi', type: 'error' });
      });
  }
}



function saveRole() {
  error.value = '';
  if (!form.value.name || form.value.name.trim().length < 2) {
    error.value = 'Rol adı en az 2 karakter olmalı.';
    return;
  }
  if (editing.value) {
    axios.put(`/roles/${editing.value.id}`, form.value)
      .then(() => {
        editing.value = null;
        form.value = { name: '' };
        fetchRoles();
        notify && notify({ message: 'Rol güncellendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Rol güncellenemedi', type: 'error' });
      });
  } else {
    axios.post('/roles', form.value)
      .then(() => {
        showAdd.value = false;
        form.value = { name: '' };
        fetchRoles();
        notify && notify({ message: 'Rol eklendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Rol eklenemedi', type: 'error' });
      });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
  form.value = { name: '' };
  error.value = '';
}

fetchRoles();
</script>
