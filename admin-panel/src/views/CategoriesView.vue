


<template>
  <div>
    <h2>Kategoriler</h2>
    <button @click="fetchCategories">Yenile</button>
    <button @click="showAdd = true">Yeni Kategori</button>
    <input v-model="search" placeholder="Kategori ara..." style="margin: 1rem 0;" />
    <ul>
      <li v-for="category in paginatedCategories" :key="category.id">
        {{ category.name }}
        <button @click="editCategory(category)">Düzenle</button>
        <button @click="deleteCategory(category)">Sil</button>
      </li>
    </ul>
    <div style="margin: 1rem 0;">
      <button @click="prevPage" :disabled="page === 1">&lt;</button>
      Sayfa {{ page }} / {{ totalPages }}
      <button @click="nextPage" :disabled="page === totalPages">&gt;</button>
    </div>
    <div v-if="showAdd || editing">
      <form @submit.prevent="saveCategory">
        <input v-model="form.name" placeholder="Kategori adı" required />
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



const categories = ref([]);
const showAdd = ref(false);
const editing = ref(null);
const form = ref({ name: '' });
const error = ref('');
const notify = inject('notify');
const search = ref('');


const page = ref(1);
const pageSize = 10;

const filteredCategories = computed(() => {
  if (!search.value) return categories.value;
  return categories.value.filter(c => c.name.toLowerCase().includes(search.value.toLowerCase()));
});

const totalPages = computed(() => Math.max(1, Math.ceil(filteredCategories.value.length / pageSize)));

const paginatedCategories = computed(() => {
  const start = (page.value - 1) * pageSize;
  return filteredCategories.value.slice(start, start + pageSize);
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

watch(filteredCategories, () => { page.value = 1; });


async function fetchCategories() {
  try {
    const res = await axios.get('/categories');
    categories.value = res.data;
  } catch (e) {
    notify && notify({ message: 'Kategoriler yüklenemedi', type: 'error' });
  }
}

function editCategory(category) {
  editing.value = { ...category };
  form.value = { name: category.name };
  showAdd.value = false;
}



function deleteCategory(category) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`/categories/${category.id}`)
      .then(() => {
        fetchCategories();
        notify && notify({ message: 'Kategori silindi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Kategori silinemedi', type: 'error' });
      });
  }
}



function saveCategory() {
  error.value = '';
  if (!form.value.name || form.value.name.trim().length < 2) {
    error.value = 'Kategori adı en az 2 karakter olmalı.';
    return;
  }
  if (editing.value) {
    axios.put(`/categories/${editing.value.id}`, form.value)
      .then(() => {
        editing.value = null;
        form.value = { name: '' };
        fetchCategories();
        notify && notify({ message: 'Kategori güncellendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Kategori güncellenemedi', type: 'error' });
      });
  } else {
    axios.post('/categories', form.value)
      .then(() => {
        showAdd.value = false;
        form.value = { name: '' };
        fetchCategories();
        notify && notify({ message: 'Kategori eklendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Kategori eklenemedi', type: 'error' });
      });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
  form.value = { name: '' };
  error.value = '';
}

fetchCategories();
</script>
