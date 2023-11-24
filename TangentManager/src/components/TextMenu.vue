<script setup lang="ts">
import { provide, ref } from 'vue';

// This ref will hold the currently active menu item
const openMenuItem = ref(null);

// Provide this ref to child components
provide('openMenuItem', openMenuItem);
</script>

<template>
  <ul class="menu">
    <slot></slot>
  </ul>
</template>

<style scoped>
.menu {
  list-style: none;
  display: flex;
  align-content: flex-end;
  margin: 0;
  padding: 0;
}
</style>