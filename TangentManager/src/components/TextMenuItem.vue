<template>
  <li class="text-menu-item" @click="handleClick">
    <span class="text"> <slot></slot></span>
    <text-menu v-if="hasChildren" :class="{active:active}">
      <slot name="children"></slot>
    </text-menu>
  </li>
</template>

<script setup>
import {inject, onBeforeMount, onBeforeUnmount, onMounted, ref, useSlots} from 'vue';
import TextMenu from "./TextMenu.vue";

const emit = defineEmits(['item-clicked']);
const props = defineProps(['action']);
const slots = useSlots();
const hasChildren = ref(false);
let active = ref(false);

// Get the openMenuItem ref from the parent
const openMenuItem = inject('openMenuItem');

onMounted(() => {
  hasChildren.value = !!slots.children;
});

onBeforeMount(() => {
  window.addEventListener('click', closeMenu);
});

onBeforeUnmount(() => {
  window.removeEventListener('click', closeMenu);
});

const handleClick = (event) => {
  event.stopPropagation();
  if (props.action) {
    emit('item-clicked', props.action);
  } else if (hasChildren.value) {
    if (active.value) {
      active.value = false;
    } else {
      if (openMenuItem.value) {
        openMenuItem.value.value = false; // close the currently open menu
      }
      active.value = true;
      openMenuItem.value = active; // register this menu as the open one
    }
  }
};

const closeMenu = () => {
  active.value = false;
};

</script>

<style scoped>

/* Base styles for menu items */
.text-menu-item {
  position: relative; /* This allows nested menus to be positioned relative to this item */
  background-color: var(--menu-bg-color);
  display: flex; /* Set to flex */
  align-items: center; /* Center content vertically */
}

/* Styles for the first level nested menu */
.menu > .text-menu-item > .menu {
  display: none;
  position: absolute;
  top: 100%; /* Positions underneath the parent menu item */
  left: 0; /* Aligns with the left edge of the parent menu item */
  z-index: 1; /* Ensures it appears above other content */
}


.menu > .text-menu-item > .menu.active {
  display: flex;
  flex-direction: column;
  min-width: max-content;
}

/* Styles for all subsequent nested menus */
.text-menu-item .menu .menu {
  display: none;
  position: absolute;
  top: 0; /* Aligns with the top of the parent menu item */
  left: 100%; /* Positions to the right side of the parent menu item */
  z-index: 1; /* Ensures it appears above other content */
}

.text-menu-item > .text {
  flex-grow: 1; /* Make the span grow to take up all available space */
  padding: 1em; /* Move padding to span */
  margin: 0;
  display: block; /* Make it block-level */;
  text-align: center;
}

.text-menu-item .text-menu-item {
}

.text-menu-item:hover > .text {
  background-color: var(--menu-item-hover-color);
}
</style>
