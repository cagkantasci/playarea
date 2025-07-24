<template>
  <form @submit.prevent="onSubmit">
    <div>
      <label>Başlık</label>
      <input v-model="form.title" required />
    </div>
    <div>
      <label>Açıklama</label>
      <input v-model="form.description" required />
    </div>
    <button type="submit">Kaydet</button>
    <button type="button" @click="$emit('cancel')">İptal</button>
  </form>
</template>

<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
  issue: Object,
});
const emit = defineEmits(['save', 'cancel']);

const form = ref({ title: '', description: '' });

watch(() => props.issue, (val) => {
  if (val) form.value = { ...val };
});

function onSubmit() {
  emit('save', { ...form.value });
}
</script>
