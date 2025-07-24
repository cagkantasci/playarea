
<template>
  <div>
    <h2>Makineler</h2>
    <button @click="fetchMachines">Yenile</button>
    <button @click="showAdd = true">Yeni Makine</button>
    <ul>
      <li v-for="machine in machines" :key="machine.id">
        {{ machine.name }} ({{ machine.category?.name }})
        <CrudButtons @edit="editMachine(machine)" @delete="deleteMachine(machine)" />
      </li>
    </ul>
    <MachineForm v-if="showAdd || editing" :machine="editing" @save="saveMachine" @cancel="cancelForm" />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import axios from 'axios';
import CrudButtons from '../components/CrudButtons.vue';
import MachineForm from '../components/MachineForm.vue';

const machines = ref([]);
const showAdd = ref(false);
const editing = ref(null);

async function fetchMachines() {
  try {
    const res = await axios.get('http://localhost:8000/api/machines');
    machines.value = res.data;
  } catch (e) {
    alert('Makineler alınamadı!');
  }
}

function editMachine(machine) {
  editing.value = { ...machine };
  showAdd.value = false;
}

function deleteMachine(machine) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`http://localhost:8000/api/machines/${machine.id}`).then(fetchMachines);
  }
}

function saveMachine(machine) {
  if (editing.value) {
    axios.put(`http://localhost:8000/api/machines/${editing.value.id}`, machine).then(() => {
      editing.value = null;
      fetchMachines();
    });
  } else {
    axios.post('http://localhost:8000/api/machines', machine).then(() => {
      showAdd.value = false;
      fetchMachines();
    });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
}

fetchMachines();
</script>
