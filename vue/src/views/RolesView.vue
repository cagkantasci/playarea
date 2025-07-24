
<template>
  <div>
    <h2>Roller</h2>
    <button @click="fetchRoles">Yenile</button>
    <button @click="showAdd = true">Yeni Rol</button>
    <ul>
      <li v-for="role in roles" :key="role.id">
        {{ role.name }}
        <CrudButtons @edit="editRole(role)" @delete="deleteRole(role)" />
      </li>
    </ul>
    <RoleForm v-if="showAdd || editing" :role="editing" @save="saveRole" @cancel="cancelForm" />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import axios from 'axios';
import CrudButtons from '../components/CrudButtons.vue';
import RoleForm from '../components/RoleForm.vue';

const roles = ref([]);
const showAdd = ref(false);
const editing = ref(null);

async function fetchRoles() {
  try {
    const res = await axios.get('http://localhost:8000/api/roles');
    roles.value = res.data;
  } catch (e) {
    alert('Roller alınamadı!');
  }
}

function editRole(role) {
  editing.value = { ...role };
  showAdd.value = false;
}

function deleteRole(role) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`http://localhost:8000/api/roles/${role.id}`).then(fetchRoles);
  }
}

function saveRole(role) {
  if (editing.value) {
    axios.put(`http://localhost:8000/api/roles/${editing.value.id}`, role).then(() => {
      editing.value = null;
      fetchRoles();
    });
  } else {
    axios.post('http://localhost:8000/api/roles', role).then(() => {
      showAdd.value = false;
      fetchRoles();
    });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
}

fetchRoles();
</script>
