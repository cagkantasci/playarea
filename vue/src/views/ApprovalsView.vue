
<template>
  <div>
    <h2>Onaylar</h2>
    <button @click="fetchApprovals">Yenile</button>
    <button @click="showAdd = true">Yeni Onay</button>
    <ul>
      <li v-for="approval in approvals" :key="approval.id">
        {{ approval.id }} - {{ approval.status }}
        <CrudButtons @edit="editApproval(approval)" @delete="deleteApproval(approval)" />
      </li>
    </ul>
    <ApprovalForm v-if="showAdd || editing" :approval="editing" @save="saveApproval" @cancel="cancelForm" />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import axios from 'axios';
import CrudButtons from '../components/CrudButtons.vue';
import ApprovalForm from '../components/ApprovalForm.vue';

const approvals = ref([]);
const showAdd = ref(false);
const editing = ref(null);

async function fetchApprovals() {
  try {
    const res = await axios.get('http://localhost:8000/api/approvals');
    approvals.value = res.data;
  } catch (e) {
    alert('Onaylar alınamadı!');
  }
}

function editApproval(approval) {
  editing.value = { ...approval };
  showAdd.value = false;
}

function deleteApproval(approval) {
  if (confirm('Silmek istediğinize emin misiniz?')) {
    axios.delete(`http://localhost:8000/api/approvals/${approval.id}`).then(fetchApprovals);
  }
}

function saveApproval(approval) {
  if (editing.value) {
    axios.put(`http://localhost:8000/api/approvals/${editing.value.id}`, approval).then(() => {
      editing.value = null;
      fetchApprovals();
    });
  } else {
    axios.post('http://localhost:8000/api/approvals', approval).then(() => {
      showAdd.value = false;
      fetchApprovals();
    });
  }
}

function cancelForm() {
  editing.value = null;
  showAdd.value = false;
}

fetchApprovals();
</script>
