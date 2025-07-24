
<template>
  <div>
    <h2>Checklist Şablonları</h2>
    <button @click="fetchTemplates">Yenile</button>
    <button @click="showAdd = true">Yeni Şablon</button>
    <ul>
      <li v-for="template in templates" :key="template.id">
        {{ template.name }}
        <CrudButtons @edit="editTemplate(template)" @delete="deleteTemplate(template)" />
      </li>
    </ul>
    <ChecklistTemplateForm v-if="showAdd || editing" :template="editing" @save="saveTemplate" @cancel="cancelForm" />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import axios from 'axios';
import CrudButtons from '../components/CrudButtons.vue';
import ChecklistTemplateForm from '../components/ChecklistTemplateForm.vue';

const templates = ref([]);
const showAdd = ref(false);
const editing = ref(null);

async function fetchTemplates() {
  try {
    const res = await axios.get('http://localhost:8000/api/checklist-templates');
    templates.value = res.data;
  } catch (e) {
    alert('Şablonlar alınamadı!');
  }
}

function editTemplate(template) {
  editing.value = { ...template };
  showAdd.value = false;
}

function deleteTemplate(template) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`http://localhost:8000/api/checklist-templates/${template.id}`).then(fetchTemplates);
  }
}

function saveTemplate(template) {
  if (editing.value) {
    axios.put(`http://localhost:8000/api/checklist-templates/${editing.value.id}`, template).then(() => {
      editing.value = null;
      fetchTemplates();
    });
  } else {
    axios.post('http://localhost:8000/api/checklist-templates', template).then(() => {
      showAdd.value = false;
      fetchTemplates();
    });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
}

fetchTemplates();
</script>
