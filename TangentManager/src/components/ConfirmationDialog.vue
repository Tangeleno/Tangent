<!-- ConfirmationDialog.vue -->
<template>
  <div v-if="isVisible" class="confirmation-dialog">
    <div class="confirmation-content">
      <div class="confirmation-heading">
        <slot name="heading">
          Are you sure?
        </slot>
      </div>
      <div class="confirmation-body">
        <slot></slot>
      </div>
      <div class="confirmation-footer">
        <slot name="buttons">
          <button v-if="!$slots.buttons" data-action="Confirm">Confirm</button>
          <button v-if="!$slots.buttons" data-action="Cancel">Cancel</button>
        </slot>
      </div>
    </div>
  </div>
</template>

<script setup>
import {defineEmits, onUpdated, ref} from 'vue';

const isVisible = ref(false);
const emit = defineEmits(['action']);

const attachButtonListeners = () => {
  const buttons = document.querySelectorAll('.confirmation-dialog [data-action]');
  buttons.forEach(button => {
    button.addEventListener('click', (event) => {
      const action = event.target.getAttribute('data-action');
      emitAction(action);
    });
  });
};

onUpdated(attachButtonListeners);
const show = () => {
  isVisible.value = true;
};

const hide = () => {
  isVisible.value = false;
};

const emitAction = (action) => {
  emit('action', action);
  hide();
};
defineExpose({show, hide})
</script>

<style scoped>
.confirmation-dialog {
  z-index: 9999999;
  position: absolute;
  left: 0;
  top: 0;
  background-color: rgb(0, 0, 0, 0.8);
  width: 100vw;
  height: 100vh;
  display: flex;

}

.confirmation-content {
  background-color: var(--nav-menu-bg-color);
  margin: auto;
  border-radius: 8px;
  display: grid;
  grid-template: 
            "confirmation-heading"
            "confirmation-body"
            "confirmation-footer";
}

.confirmation-heading {
  padding: 1rem 2rem;
  border-bottom: 1px solid var(--seperator-border-color);
  align-self: center;
  text-align: center;
  font-size: 3em;
}

.confirmation-body {
  padding: 1rem 2rem;
}
.confirmation-footer {
  display: flex;
  justify-content: space-between;
}
.confirmation-footer :deep(button) {
  display: inline-block;
  padding: 1rem;
  margin: 0.5rem 0.5rem;
  border-radius: 5px;
  cursor: pointer;
}
</style>
