


<template>
  <div>
    <h2>Makineler</h2>
    <button @click="fetchMachines">Yenile</button>
    <button @click="showAdd = true">Yeni Makine</button>
    <input v-model="search" placeholder="Makine ara..." style="margin: 1rem 0;" />
    <ul>
      <li v-for="machine in paginatedMachines" :key="machine.id">
        {{ machine.name }}
        <button @click="editMachine(machine)">Düzenle</button>
        <button @click="deleteMachine(machine)">Sil</button>
      </li>
    </ul>
    <div style="margin: 1rem 0;">
      <button @click="prevPage" :disabled="page === 1">&lt;</button>
      Sayfa {{ page }} / {{ totalPages }}
      <button @click="nextPage" :disabled="page === totalPages">&gt;</button>
    </div>
    <div v-if="showAdd || editing">
      <form @submit.prevent="saveMachine">
        <input v-model="form.name" placeholder="Makine adı" required />
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



const machines = ref([]);
const showAdd = ref(false);
const editing = ref(null);
const form = ref({ name: '' });
const error = ref('');
const notify = inject('notify');
const search = ref('');


const page = ref(1);
const pageSize = 10;

const filteredMachines = computed(() => {
  if (!search.value) return machines.value;
  return machines.value.filter(m => m.name.toLowerCase().includes(search.value.toLowerCase()));
});

const totalPages = computed(() => Math.max(1, Math.ceil(filteredMachines.value.length / pageSize)));

const paginatedMachines = computed(() => {
  const start = (page.value - 1) * pageSize;
  return filteredMachines.value.slice(start, start + pageSize);
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

watch(filteredMachines, () => { page.value = 1; });


async function fetchMachines() {
  try {
    const res = await axios.get('/machines');
    machines.value = res.data;
  } catch (e) {
    notify && notify({ message: 'Makineler yüklenemedi', type: 'error' });
  }
}

function editMachine(machine) {
  editing.value = { ...machine };
  form.value = { name: machine.name };
  showAdd.value = false;
}



function deleteMachine(machine) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`/machines/${machine.id}`)
      .then(() => {
        fetchMachines();
        notify && notify({ message: 'Makine silindi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Makine silinemedi', type: 'error' });
      });
  }
}



function saveMachine() {
  error.value = '';
  if (!form.value.name || form.value.name.trim().length < 2) {
    error.value = 'Makine adı en az 2 karakter olmalı.';
    return;
  }
  if (editing.value) {
    axios.put(`/machines/${editing.value.id}`, form.value)
      .then(() => {
        editing.value = null;
        form.value = { name: '' };
        fetchMachines();
        notify && notify({ message: 'Makine güncellendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Makine güncellenemedi', type: 'error' });
      });
  } else {
    axios.post('/machines', form.value)
      .then(() => {
        showAdd.value = false;
        form.value = { name: '' };
        fetchMachines();
        notify && notify({ message: 'Makine eklendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Makine eklenemedi', type: 'error' });
      });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
  form.value = { name: '' };
  error.value = '';
}

fetchMachines();
</script>
