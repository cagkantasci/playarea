
<template>
  <div>
    <h2>Arıza Kayıtları</h2>
    <button @click="fetchIssues">Yenile</button>
    <button @click="showAdd = true">Yeni Arıza</button>
    <input v-model="search" placeholder="Arıza ara..." style="margin: 1rem 0;" />
    <ul>
      <li v-for="issue in paginatedIssues" :key="issue.id">
        {{ issue.title }} (Makine: {{ issue.machine_name || issue.machine_id }})
        <button @click="editIssue(issue)">Düzenle</button>
        <button @click="deleteIssue(issue)">Sil</button>
      </li>
    </ul>
    <div style="margin: 1rem 0;">
      <button @click="prevPage" :disabled="page === 1">&lt;</button>
      Sayfa {{ page }} / {{ totalPages }}
      <button @click="nextPage" :disabled="page === totalPages">&gt;</button>
    </div>
    <div v-if="showAdd || editing">
      <form @submit.prevent="validateAndSaveIssue">
        <input v-model="form.title" placeholder="Başlık" />
        <div v-if="errors.title" class="error">{{ errors.title }}</div>
        <input v-model="form.machine_id" placeholder="Makine ID" />
        <div v-if="errors.machine_id" class="error">{{ errors.machine_id }}</div>
        <textarea v-model="form.description" placeholder="Açıklama"></textarea>
        <div v-if="errors.description" class="error">{{ errors.description }}</div>
        <button type="submit">Kaydet</button>
        <button type="button" @click="cancelForm">İptal</button>
      </form>
    </div>
  </div>
</template>


<script setup>
import { ref, inject, computed, nextTick, watch } from 'vue';
import axios from '../axios';




const issues = ref([]);
const showAdd = ref(false);
const editing = ref(null);
const form = ref({ title: '', machine_id: '', description: '' });
const errors = ref({});
const notify = inject('notify');
const search = ref('');


const page = ref(1);
const pageSize = 10;

const filteredIssues = computed(() => {
  if (!search.value) return issues.value;
  return issues.value.filter(i =>
    i.title.toLowerCase().includes(search.value.toLowerCase()) ||
    (i.machine_name && i.machine_name.toLowerCase().includes(search.value.toLowerCase()))
  );
});

const totalPages = computed(() => Math.max(1, Math.ceil(filteredIssues.value.length / pageSize)));

const paginatedIssues = computed(() => {
  const start = (page.value - 1) * pageSize;
  return filteredIssues.value.slice(start, start + pageSize);
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

watch(filteredIssues, () => { page.value = 1; });


async function fetchIssues() {
  try {
    const res = await axios.get('/issues');
    issues.value = res.data;
  } catch (e) {
    notify && notify({ message: 'Arıza kayıtları yüklenemedi', type: 'error' });
  }
}

function editIssue(issue) {
  editing.value = { ...issue };
  form.value = { title: issue.title, machine_id: issue.machine_id, description: issue.description };
  showAdd.value = false;
}



function deleteIssue(issue) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`/issues/${issue.id}`)
      .then(() => {
        fetchIssues();
        notify && notify({ message: 'Arıza kaydı silindi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Arıza kaydı silinemedi', type: 'error' });
      });
  }
}




function validateAndSaveIssue() {
  errors.value = {};
  if (!form.value.title || form.value.title.trim().length < 3) {
    errors.value.title = 'Başlık en az 3 karakter olmalı';
  }
  if (!form.value.machine_id || form.value.machine_id.toString().trim() === '') {
    errors.value.machine_id = 'Makine ID zorunludur';
  }
  if (form.value.description && form.value.description.length > 0 && form.value.description.length < 5) {
    errors.value.description = 'Açıklama en az 5 karakter olmalı veya boş bırakılmalı';
  }
  if (Object.keys(errors.value).length > 0) return;

  if (editing.value) {
    axios.put(`/issues/${editing.value.id}`, form.value)
      .then(() => {
        editing.value = null;
        form.value = { title: '', machine_id: '', description: '' };
        fetchIssues();
        notify && notify({ message: 'Arıza kaydı güncellendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Arıza kaydı güncellenemedi', type: 'error' });
      });
  } else {
    axios.post('/issues', form.value)
      .then(() => {
        showAdd.value = false;
        form.value = { title: '', machine_id: '', description: '' };
        fetchIssues();
        notify && notify({ message: 'Arıza kaydı eklendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Arıza kaydı eklenemedi', type: 'error' });
      });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
  form.value = { title: '', machine_id: '', description: '' };
  errors.value = {};
}

fetchIssues();
</script>
