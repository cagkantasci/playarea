
<template>
  <div>
    <h2>İşlemler / Sorunlar</h2>
    <button @click="fetchIssues">Yenile</button>
    <button @click="showAdd = true">Yeni Sorun</button>
    <ul>
      <li v-for="issue in issues" :key="issue.id">
        {{ issue.title }}
        <CrudButtons @edit="editIssue(issue)" @delete="deleteIssue(issue)" />
      </li>
    </ul>
    <IssueForm v-if="showAdd || editing" :issue="editing" @save="saveIssue" @cancel="cancelForm" />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import axios from 'axios';
import CrudButtons from '../components/CrudButtons.vue';
import IssueForm from '../components/IssueForm.vue';

const issues = ref([]);
const showAdd = ref(false);
const editing = ref(null);

async function fetchIssues() {
  try {
    const res = await axios.get('http://localhost:8000/api/issues');
    issues.value = res.data;
  } catch (e) {
    alert('Sorunlar alınamadı!');
  }
}

function editIssue(issue) {
  editing.value = { ...issue };
  showAdd.value = false;
}

function deleteIssue(issue) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`http://localhost:8000/api/issues/${issue.id}`).then(fetchIssues);
  }
}

function saveIssue(issue) {
  if (editing.value) {
    axios.put(`http://localhost:8000/api/issues/${editing.value.id}`, issue).then(() => {
      editing.value = null;
      fetchIssues();
    });
  } else {
    axios.post('http://localhost:8000/api/issues', issue).then(() => {
      showAdd.value = false;
      fetchIssues();
    });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
}

fetchIssues();
</script>
