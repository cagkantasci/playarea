
<template>
  <div>
    <h2>Kullanıcılar</h2>
    <button @click="fetchUsers">Yenile</button>
    <button @click="showAdd = true">Yeni Kullanıcı</button>
    <ul>
      <li v-for="user in users" :key="user.id">
        {{ user.name }} ({{ user.email }})
        <CrudButtons @edit="editUser(user)" @delete="deleteUser(user)" />
      </li>
    </ul>
    <UserForm v-if="showAdd || editing" :user="editing" @save="saveUser" @cancel="cancelForm" />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import axios from 'axios';
import CrudButtons from '../components/CrudButtons.vue';
import UserForm from '../components/UserForm.vue';

const users = ref([]);
const showAdd = ref(false);
const editing = ref(null);

async function fetchUsers() {
  try {
    const res = await axios.get('http://localhost:8000/api/users');
    users.value = res.data;
  } catch (e) {
    alert('Kullanıcılar alınamadı!');
  }
}

function editUser(user) {
  editing.value = { ...user };
  showAdd.value = false;
}

function deleteUser(user) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`http://localhost:8000/api/users/${user.id}`).then(fetchUsers);
  }
}

function saveUser(user) {
  if (editing.value) {
    axios.put(`http://localhost:8000/api/users/${editing.value.id}`, user).then(() => {
      editing.value = null;
      fetchUsers();
    });
  } else {
    axios.post('http://localhost:8000/api/users', user).then(() => {
      showAdd.value = false;
      fetchUsers();
    });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
}

fetchUsers();
</script>
