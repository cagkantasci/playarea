
<template>
  <div>
    <h2>Checklistler</h2>
    <button @click="fetchChecklists">Yenile</button>
    <button @click="showAdd = true">Yeni Checklist</button>
    <ul>
      <li v-for="checklist in checklists" :key="checklist.id">
        {{ checklist.name }}
        <CrudButtons @edit="editChecklist(checklist)" @delete="deleteChecklist(checklist)" />
      </li>
    </ul>
    <ChecklistForm v-if="showAdd || editing" :checklist="editing" @save="saveChecklist" @cancel="cancelForm" />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import axios from 'axios';
import CrudButtons from '../components/CrudButtons.vue';
import ChecklistForm from '../components/ChecklistForm.vue';

const checklists = ref([]);
const showAdd = ref(false);
const editing = ref(null);

async function fetchChecklists() {
  try {
    const res = await axios.get('http://localhost:8000/api/checklists');
    checklists.value = res.data;
  } catch (e) {
    alert('Checklistler alınamadı!');
  }
}

function editChecklist(checklist) {
  editing.value = { ...checklist };
  showAdd.value = false;
}

function deleteChecklist(checklist) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`http://localhost:8000/api/checklists/${checklist.id}`).then(fetchChecklists);
  }
}

function saveChecklist(checklist) {
  if (editing.value) {
    axios.put(`http://localhost:8000/api/checklists/${editing.value.id}`, checklist).then(() => {
      editing.value = null;
      fetchChecklists();
    });
  } else {
    axios.post('http://localhost:8000/api/checklists', checklist).then(() => {
      showAdd.value = false;
      fetchChecklists();
    });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
}

fetchChecklists();
</script>
