
<template>
  <div>
    <h2>Checklist Cevapları</h2>
    <button @click="fetchResponses">Yenile</button>
    <button @click="showAdd = true">Yeni Cevap</button>
    <ul>
      <li v-for="response in responses" :key="response.id">
        {{ response.id }} - {{ response.checklist_id }}
        <CrudButtons @edit="editResponse(response)" @delete="deleteResponse(response)" />
      </li>
    </ul>
    <ChecklistResponseForm v-if="showAdd || editing" :response="editing" @save="saveResponse" @cancel="cancelForm" />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import axios from 'axios';
import CrudButtons from '../components/CrudButtons.vue';
import ChecklistResponseForm from '../components/ChecklistResponseForm.vue';

const responses = ref([]);
const showAdd = ref(false);
const editing = ref(null);

async function fetchResponses() {
  try {
    const res = await axios.get('http://localhost:8000/api/checklist-responses');
    responses.value = res.data;
  } catch (e) {
    alert('Cevaplar alınamadı!');
  }
}

function editResponse(response) {
  editing.value = { ...response };
  showAdd.value = false;
}

function deleteResponse(response) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`http://localhost:8000/api/checklist-responses/${response.id}`).then(fetchResponses);
  }
}

function saveResponse(response) {
  if (editing.value) {
    axios.put(`http://localhost:8000/api/checklist-responses/${editing.value.id}`, response).then(() => {
      editing.value = null;
      fetchResponses();
    });
  } else {
    axios.post('http://localhost:8000/api/checklist-responses', response).then(() => {
      showAdd.value = false;
      fetchResponses();
    });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
}

fetchResponses();
</script>
