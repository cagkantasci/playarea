<template>
  <form @submit.prevent="onSubmit">
    <div>
      <label>Rol Adı</label>
      <input v-model="form.name" required />
    </div>
    <button type="submit">Kaydet</button>
    <button type="button" @click="$emit('cancel')">İptal</button>
  </form>
</template>

<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
  role: Object,
});
const emit = defineEmits(['save', 'cancel']);

const form = ref({ name: '' });

watch(() => props.role, (val) => {
  if (val) form.value = { ...val };
});

function onSubmit() {
  emit('save', { ...form.value });
}
</script>
