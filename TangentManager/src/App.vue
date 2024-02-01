<script lang="ts" setup>
  import NavigationBar from './components/Navigationbar.vue';
</script>

<template>
  <main>
    <navigation-bar img="/Tangent-logo.png"></navigation-bar>
    <div class="container">
      <router-view></router-view>
    </div>
  </main>
</template>

<style scoped>
  main {
    background-color: var(--surface-ground);
    width: 100vw;
    height: 100vh;
    margin: 0;
    padding: 0;
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: 1fr 25fr;
    grid-column-gap: 0px;
    grid-row-gap: 0px;
  }
</style>
