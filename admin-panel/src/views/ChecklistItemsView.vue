
<template>
  <div>
    <h2>Checklist Maddeleri</h2>
    <button @click="fetchItems">Yenile</button>
    <button @click="showAdd = true">Yeni Madde</button>
    <input v-model="search" placeholder="Madde ara..." style="margin: 1rem 0;" />
    <ul>
      <li v-for="item in paginatedItems" :key="item.id">
        {{ item.name }} (Şablon: {{ item.template_name || item.template_id }})
        <button @click="editItem(item)">Düzenle</button>
        <button @click="deleteItem(item)">Sil</button>
      </li>
    </ul>
    <div style="margin: 1rem 0;">
      <button @click="prevPage" :disabled="page === 1">&lt;</button>
      Sayfa {{ page }} / {{ totalPages }}
      <button @click="nextPage" :disabled="page === totalPages">&gt;</button>
    </div>
    <div v-if="showAdd || editing">
      <form @submit.prevent="saveItem">
        <input v-model="form.name" placeholder="Madde adı" required />
        <input v-model="form.template_id" placeholder="Şablon ID" required />
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



const items = ref([]);
const showAdd = ref(false);
const editing = ref(null);
const form = ref({ name: '', template_id: '' });
const error = ref('');
const notify = inject('notify');
const search = ref('');


const page = ref(1);
const pageSize = 10;

const filteredItems = computed(() => {
  if (!search.value) return items.value;
  return items.value.filter(i => i.name.toLowerCase().includes(search.value.toLowerCase()));
});

const totalPages = computed(() => Math.max(1, Math.ceil(filteredItems.value.length / pageSize)));

const paginatedItems = computed(() => {
  const start = (page.value - 1) * pageSize;
  return filteredItems.value.slice(start, start + pageSize);
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

watch(filteredItems, () => { page.value = 1; });


async function fetchItems() {
  try {
    const res = await axios.get('/checklist-items');
    items.value = res.data;
  } catch (e) {
    notify && notify({ message: 'Maddeler yüklenemedi', type: 'error' });
  }
}

function editItem(item) {
  editing.value = { ...item };
  form.value = { name: item.name, template_id: item.template_id };
  showAdd.value = false;
}



function deleteItem(item) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`/checklist-items/${item.id}`)
      .then(() => {
        fetchItems();
        notify && notify({ message: 'Madde silindi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Madde silinemedi', type: 'error' });
      });
  }
}



function saveItem() {
  error.value = '';
  if (!form.value.name || form.value.name.trim().length < 2) {
    error.value = 'Madde adı en az 2 karakter olmalı.';
    return;
  }
  if (!form.value.template_id || form.value.template_id.toString().trim() === '') {
    error.value = 'Şablon ID zorunludur.';
    return;
  }
  if (editing.value) {
    axios.put(`/checklist-items/${editing.value.id}`, form.value)
      .then(() => {
        editing.value = null;
        form.value = { name: '', template_id: '' };
        fetchItems();
        notify && notify({ message: 'Madde güncellendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Madde güncellenemedi', type: 'error' });
      });
  } else {
    axios.post('/checklist-items', form.value)
      .then(() => {
        showAdd.value = false;
        form.value = { name: '', template_id: '' };
        fetchItems();
        notify && notify({ message: 'Madde eklendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Madde eklenemedi', type: 'error' });
      });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
  form.value = { name: '', template_id: '' };
  error.value = '';
}

fetchItems();
</script>
