<script lang="ts" setup>
import {computed} from "vue";
import {useRoute, useRouter} from "vue-router";

const props = defineProps({
  img: {type: String, required: true}
})
const route = useRoute();
const router = useRouter();
const activeIndex = computed(() => route.name);
const routes = computed(() => router.getRoutes());
</script>

<template>
  <nav class="menu">
    <div class="items">
      <img alt="logo" v-bind:src="props.img" width="100"/>
      <router-link v-for="r in routes" :class="{active:r.name === activeIndex}" :to="{name:r.name}">{{ r.name }}
      </router-link>
    </div>
  </nav>
</template>

<style scoped>
nav.menu {
  background-color: var(--nav-menu-bg-color);
  border-bottom: 0.125rem solid var(--seperator-border-color);
}

nav.menu .items {
  align-items: stretch;
  display: inline-grid;
  gap: 0.125rem;
  grid-auto-columns: 1fr;
  grid-auto-flow: column;
  grid-column: auto;
  grid-column-gap: 0;
  grid-row-gap: 0;
  height: 100%;
  justify-items: stretch;
}

nav.menu .items > a {
  align-items: end;
  color: var(--nav-menu-font-color);
  display: flex;
  font-size: 1.2rem;
  justify-content: center;
  line-height: 2;
  text-decoration: none;
}

nav.menu .items > .active {
  background-color: var(--nav-menu-hover-color);
  border-radius: 0.5rem 0.5rem 0 0;
  box-shadow: 0 0.25rem 0.125rem -0.125rem var(--nav-menu-active-border-color);
}

nav.menu .items > a:hover {
  background-color: var(--nav-menu-hover-color);
  border-radius: 0.5rem 0.5rem 0 0;
  box-shadow: 0 0.25rem 0.125rem -0.125rem var(--nav-menu-active-border-color);
}
</style>