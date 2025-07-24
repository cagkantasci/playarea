<template>
  <form @submit.prevent="onSubmit">
    <div>
      <label>Makine Adı</label>
      <input v-model="form.name" required />
    </div>
    <div>
      <label>Kategori</label>
      <select v-model="form.category_id" required>
        <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
      </select>
    </div>
    <button type="submit">Kaydet</button>
    <button type="button" @click="$emit('cancel')">İptal</button>
  </form>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue';
import axios from 'axios';

const props = defineProps({
  machine: Object,
});
const emit = defineEmits(['save', 'cancel']);

const form = ref({ name: '', category_id: '' });
const categories = ref([]);

watch(() => props.machine, (val) => {
  if (val) form.value = { ...val };
});

async function fetchCategories() {
  const res = await axios.get('http://localhost:8000/api/categories');
  categories.value = res.data;
}
onMounted(fetchCategories);

function onSubmit() {
  emit('save', { ...form.value });
}
</script>
