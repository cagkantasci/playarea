
<template>
  <div>
    <h2>Kategoriler</h2>
    <button @click="fetchCategories">Yenile</button>
    <button @click="showAdd = true">Yeni Kategori</button>
    <ul>
      <li v-for="category in categories" :key="category.id">
        {{ category.name }}
        <CrudButtons @edit="editCategory(category)" @delete="deleteCategory(category)" />
      </li>
    </ul>
    <CategoryForm v-if="showAdd || editing" :category="editing" @save="saveCategory" @cancel="cancelForm" />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import axios from 'axios';
import CrudButtons from '../components/CrudButtons.vue';
import CategoryForm from '../components/CategoryForm.vue';

const categories = ref([]);
const showAdd = ref(false);
const editing = ref(null);

async function fetchCategories() {
  try {
    const res = await axios.get('http://localhost:8000/api/categories');
    categories.value = res.data;
  } catch (e) {
    alert('Kategoriler alınamadı!');
  }
}

function editCategory(category) {
  editing.value = { ...category };
  showAdd.value = false;
}

function deleteCategory(category) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`http://localhost:8000/api/categories/${category.id}`).then(fetchCategories);
  }
}

function saveCategory(category) {
  if (editing.value) {
    axios.put(`http://localhost:8000/api/categories/${editing.value.id}`, category).then(() => {
      editing.value = null;
      fetchCategories();
    });
  } else {
    axios.post('http://localhost:8000/api/categories', category).then(() => {
      showAdd.value = false;
      fetchCategories();
    });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
}

fetchCategories();
</script>
