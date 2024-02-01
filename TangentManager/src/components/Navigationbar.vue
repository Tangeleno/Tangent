<!-- Navigationbar.vue -->
<script lang="ts" setup>
  import { computed } from 'vue';
  import { useRouter} from 'vue-router';
  import Menubar from 'primevue/menubar';
  import { MenuItem } from 'primevue/menuitem';
  import Toast from 'primevue/toast';
  const props = defineProps({
    img: { type: String, required: true },
  });
  const router = useRouter();
  const routes = computed(() =>
    router.getRoutes().map((r) => {
      return { label: r.name, route: r.path, icon:r.meta.icon } as MenuItem;
    })
  );
</script>

<template>
  <Menubar :model="routes">
    <template #start>
      <img alt="logo" v-bind:src="props.img" width="100" class="ml-3 mr-2" />
    </template>
    <template #item="{ item, props, hasSubmenu }">
      <router-link v-if="item.route" v-slot="{ href, navigate }" :to="item.route" custom>
        <a v-ripple :class="{ 'router-link-active': item.route == router.currentRoute.value.path}" :href="href" v-bind="props.action" @click="navigate">
          <span :class="item.icon" />
          <span class="ml-2">{{ item.label }}</span>
        </a>
      </router-link>
      <a v-else v-ripple :href="item.url" :target="item.target" v-bind="props.action">
        <span :class="item.icon" />
        <span class="ml-2">{{ item.label }}</span>
        <span v-if="hasSubmenu" class="pi pi-fw pi-angle-down ml-2" />
      </a>
    </template>
    <template #end>
      <Toast></Toast>
    </template>
  </Menubar>
</template>

<style scoped></style>
