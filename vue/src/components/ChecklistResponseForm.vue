<template>
  <form @submit.prevent="onSubmit">
    <div>
      <label>Checklist ID</label>
      <input v-model="form.checklist_id" required />
    </div>
    <div>
      <label>Cevap</label>
      <input v-model="form.response" required />
    </div>
    <button type="submit">Kaydet</button>
    <button type="button" @click="$emit('cancel')">İptal</button>
  </form>
</template>

<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
  response: Object,
});
const emit = defineEmits(['save', 'cancel']);

const form = ref({ checklist_id: '', response: '' });

watch(() => props.response, (val) => {
  if (val) form.value = { ...val };
});

function onSubmit() {
  emit('save', { ...form.value });
}
</script>
