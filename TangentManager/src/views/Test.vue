<script lang="ts" setup>
import { ref } from "vue";
import Chips from "primevue/chips";
 import MarkdownRenderer from "../components/MarkdownRenderer.vue";
 const value = ref();
</script>

<template>
   <Chips v-model="value" separator=","  />
</template>

<style scoped>
 div.container {
   padding-top: 1rem;
 }

</style>