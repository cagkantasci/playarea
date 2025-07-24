<template>
  <div v-if="visible" :class="['notification', type]">
    {{ message }}
    <button @click="close">X</button>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
  message: String,
  type: {
    type: String,
    default: 'success',
  },
  duration: {
    type: Number,
    default: 3000,
  },
});

const visible = ref(true);

function close() {
  visible.value = false;
}

watch(
  () => props.message,
  () => {
    visible.value = true;
    if (props.duration > 0) {
      setTimeout(() => (visible.value = false), props.duration);
    }
  },
  { immediate: true }
);
</script>

<style scoped>
.notification {
  position: fixed;
  top: 2rem;
  right: 2rem;
  background: #f0f9eb;
  color: #2e7d32;
  border: 1px solid #b2dfdb;
  padding: 1rem 2rem;
  border-radius: 5px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  z-index: 1000;
  min-width: 200px;
}
.notification.error {
  background: #ffebee;
  color: #c62828;
  border-color: #ef9a9a;
}
.notification button {
  background: none;
  border: none;
  color: inherit;
  font-size: 1.2rem;
  float: right;
  cursor: pointer;
}
</style>
