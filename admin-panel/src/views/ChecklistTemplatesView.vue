
<template>
  <div>
    <h2>Checklist Şablonları</h2>
    <button @click="fetchTemplates">Yenile</button>
    <button @click="showAdd = true">Yeni Şablon</button>
    <input v-model="search" placeholder="Şablon ara..." style="margin: 1rem 0;" />
    <ul>
      <li v-for="template in paginatedTemplates" :key="template.id">
        {{ template.name }}
        <button @click="editTemplate(template)">Düzenle</button>
        <button @click="deleteTemplate(template)">Sil</button>
      </li>
    </ul>
    <div style="margin: 1rem 0;">
      <button @click="prevPage" :disabled="page === 1">&lt;</button>
      Sayfa {{ page }} / {{ totalPages }}
      <button @click="nextPage" :disabled="page === totalPages">&gt;</button>
    </div>
    <div v-if="showAdd || editing">
      <form @submit.prevent="saveTemplate">
        <input v-model="form.name" placeholder="Şablon adı" required />
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



const templates = ref([]);
const showAdd = ref(false);
const editing = ref(null);
const form = ref({ name: '' });
const error = ref('');
const notify = inject('notify');
const search = ref('');


const page = ref(1);
const pageSize = 10;

const filteredTemplates = computed(() => {
  if (!search.value) return templates.value;
  return templates.value.filter(t => t.name.toLowerCase().includes(search.value.toLowerCase()));
});

const totalPages = computed(() => Math.max(1, Math.ceil(filteredTemplates.value.length / pageSize)));

const paginatedTemplates = computed(() => {
  const start = (page.value - 1) * pageSize;
  return filteredTemplates.value.slice(start, start + pageSize);
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

watch(filteredTemplates, () => { page.value = 1; });


async function fetchTemplates() {
  try {
    const res = await axios.get('/checklist-templates');
    templates.value = res.data;
  } catch (e) {
    notify && notify({ message: 'Şablonlar yüklenemedi', type: 'error' });
  }
}

function editTemplate(template) {
  editing.value = { ...template };
  form.value = { name: template.name };
  showAdd.value = false;
}



function deleteTemplate(template) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`/checklist-templates/${template.id}`)
      .then(() => {
        fetchTemplates();
        notify && notify({ message: 'Şablon silindi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Şablon silinemedi', type: 'error' });
      });
  }
}



function saveTemplate() {
  error.value = '';
  if (!form.value.name || form.value.name.trim().length < 2) {
    error.value = 'Şablon adı en az 2 karakter olmalı.';
    return;
  }
  if (editing.value) {
    axios.put(`/checklist-templates/${editing.value.id}`, form.value)
      .then(() => {
        editing.value = null;
        form.value = { name: '' };
        fetchTemplates();
        notify && notify({ message: 'Şablon güncellendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Şablon güncellenemedi', type: 'error' });
      });
  } else {
    axios.post('/checklist-templates', form.value)
      .then(() => {
        showAdd.value = false;
        form.value = { name: '' };
        fetchTemplates();
        notify && notify({ message: 'Şablon eklendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Şablon eklenemedi', type: 'error' });
      });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
  form.value = { name: '' };
  error.value = '';
}

fetchTemplates();
</script>
