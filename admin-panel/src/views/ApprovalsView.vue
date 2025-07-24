
<template>
  <div>
    <h2>Onay Süreçleri</h2>
    <button @click="fetchApprovals">Yenile</button>
    <button @click="showAdd = true">Yeni Onay</button>
    <input v-model="search" placeholder="Onay ara..." style="margin: 1rem 0;" />
    <ul>
      <li v-for="approval in paginatedApprovals" :key="approval.id">
        {{ approval.title }} (Durum: {{ approval.status }})
        <button @click="editApproval(approval)">Düzenle</button>
        <button @click="deleteApproval(approval)">Sil</button>
      </li>
    </ul>
    <div style="margin: 1rem 0;">
      <button @click="prevPage" :disabled="page === 1">&lt;</button>
      Sayfa {{ page }} / {{ totalPages }}
      <button @click="nextPage" :disabled="page === totalPages">&gt;</button>
    </div>
    <div v-if="showAdd || editing">
      <form @submit.prevent="validateAndSaveApproval">
        <input v-model="form.title" placeholder="Başlık" />
        <div v-if="errors.title" class="error">{{ errors.title }}</div>
        <input v-model="form.status" placeholder="Durum" />
        <div v-if="errors.status" class="error">{{ errors.status }}</div>
        <button type="submit">Kaydet</button>
        <button type="button" @click="cancelForm">İptal</button>
      </form>
    </div>
  </div>
</template>


<script setup>
import { ref, inject, computed, nextTick, watch } from 'vue';
import axios from '../axios';




const approvals = ref([]);
const showAdd = ref(false);
const editing = ref(null);
const form = ref({ title: '', status: '' });
const errors = ref({});
const notify = inject('notify');
const search = ref('');


const page = ref(1);
const pageSize = 10;

const filteredApprovals = computed(() => {
  if (!search.value) return approvals.value;
  return approvals.value.filter(a =>
    a.title.toLowerCase().includes(search.value.toLowerCase()) ||
    (a.status && a.status.toLowerCase().includes(search.value.toLowerCase()))
  );
});

const totalPages = computed(() => Math.max(1, Math.ceil(filteredApprovals.value.length / pageSize)));

const paginatedApprovals = computed(() => {
  const start = (page.value - 1) * pageSize;
  return filteredApprovals.value.slice(start, start + pageSize);
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

watch(filteredApprovals, () => { page.value = 1; });


async function fetchApprovals() {
  try {
    const res = await axios.get('/approvals');
    approvals.value = res.data;
  } catch (e) {
    notify && notify({ message: 'Onaylar yüklenemedi', type: 'error' });
  }
}

function editApproval(approval) {
  editing.value = { ...approval };
  form.value = { title: approval.title, status: approval.status };
  showAdd.value = false;
}



function deleteApproval(approval) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`/approvals/${approval.id}`)
      .then(() => {
        fetchApprovals();
        notify && notify({ message: 'Onay silindi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Onay silinemedi', type: 'error' });
      });
  }
}




function validateAndSaveApproval() {
  errors.value = {};
  if (!form.value.title || form.value.title.trim().length < 3) {
    errors.value.title = 'Başlık en az 3 karakter olmalı';
  }
  if (!form.value.status || form.value.status.trim().length < 2) {
    errors.value.status = 'Durum en az 2 karakter olmalı';
  }
  if (Object.keys(errors.value).length > 0) return;

  if (editing.value) {
    axios.put(`/approvals/${editing.value.id}`, form.value)
      .then(() => {
        editing.value = null;
        form.value = { title: '', status: '' };
        fetchApprovals();
        notify && notify({ message: 'Onay güncellendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Onay güncellenemedi', type: 'error' });
      });
  } else {
    axios.post('/approvals', form.value)
      .then(() => {
        showAdd.value = false;
        form.value = { title: '', status: '' };
        fetchApprovals();
        notify && notify({ message: 'Onay eklendi', type: 'success' });
      })
      .catch(() => {
        notify && notify({ message: 'Onay eklenemedi', type: 'error' });
      });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
  form.value = { title: '', status: '' };
  errors.value = {};
}

fetchApprovals();
</script>
