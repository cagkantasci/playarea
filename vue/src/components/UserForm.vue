<template>
  <form @submit.prevent="onSubmit">
    <div>
      <label>Ad Soyad</label>
      <input v-model="form.name" required />
    </div>
    <div>
      <label>Email</label>
      <input v-model="form.email" required type="email" />
    </div>
    <div>
      <label>Rol</label>
      <select v-model="form.role_id" required>
        <option v-for="role in roles" :key="role.id" :value="role.id">{{ role.name }}</option>
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
  user: Object,
});
const emit = defineEmits(['save', 'cancel']);

const form = ref({ name: '', email: '', role_id: '' });
const roles = ref([]);

watch(() => props.user, (val) => {
  if (val) form.value = { ...val };
});

async function fetchRoles() {
  const res = await axios.get('http://localhost:8000/api/roles');
  roles.value = res.data;
}
onMounted(fetchRoles);

function onSubmit() {
  emit('save', { ...form.value });
}
</script>
