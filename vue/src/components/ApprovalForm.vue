<template>
  <form @submit.prevent="onSubmit">
    <div>
      <label>Durum</label>
      <input v-model="form.status" required />
    </div>
    <button type="submit">Kaydet</button>
    <button type="button" @click="$emit('cancel')">İptal</button>
  </form>
</template>

<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
  approval: Object,
});
const emit = defineEmits(['save', 'cancel']);

const form = ref({ status: '' });

watch(() => props.approval, (val) => {
  if (val) form.value = { ...val };
});

function onSubmit() {
  emit('save', { ...form.value });
}
</script>
