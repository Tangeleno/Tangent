<script lang="ts" setup>
  import { computed, ref, watch, watchEffect } from 'vue';
  import { nodeStore } from '@/stores';
  import { NodeType, NodeDetails, TreeNode, Conditions } from '@/types/TreeNode.ts';
  import AutoComplete from 'primevue/autocomplete';
  import InputText from 'primevue/inputtext';
  import InputNumber from 'primevue/inputnumber';
  import SelectButton from 'primevue/selectbutton';
  import Button from 'primevue/button';
  const selectedNodeCopy = ref<TreeNode | null>(null);
  const hasChanges = ref(false);
  const conditionList = computed(() => Object.values(Conditions));
  const boolOptions = ['true', 'false'];
  const filteredNodeTypes = ref([]);
  copyNode();
  const selectedNodeType = ref({ display: getKeyByValue(selectedNodeCopy.value?.type), value: selectedNodeCopy.value });
  watch(
    () => nodeStore.selectedNodeId,
    (newNodeId) => {
      if (newNodeId) {
        copyNode();
      } else {
        selectedNodeCopy.value = null;
      }
    }
  );

  function getKeyByValue(value: string): string | undefined {
    const entries = Object.entries(NodeType);
    for (const [key, val] of entries) {
      if (val === value) {
        return key.replace(/([A-Z])/g, ' $1').trim();
      }
    }
    return undefined; // Return undefined if no matching key is found
  }

  watchEffect(() => {
    if (selectedNodeCopy.value) {
      const original = nodeStore.selectedNode;
      hasChanges.value = JSON.stringify(selectedNodeCopy.value) !== JSON.stringify(original);
    }
  });
  watch(selectedNodeType, (newValue) => {
    if (newValue) {
      selectedNodeCopy.value.type = newValue.value;
    }
  });
  const saveChanges = function () {
    nodeStore.selectedNode.type = selectedNodeCopy.value.type;
    for (const input of NodeDetails[selectedNodeCopy.value.type].inputs) {
      console.log(input.name);
      nodeStore.selectedNode.inputs[input.name] = selectedNodeCopy.value.inputs[input.name];
    }
  };

  function searchNodeTypes(event) {
    filteredNodeTypes.value = Object.entries(NodeType)
      .filter(([key, value]) => {
        return key.toLowerCase().startsWith(event.query.toLowerCase());
      })
      .map(([key, value]) => {
        return { display: key.replace(/([A-Z])/g, ' $1').trim(), value: value };
      });
  }
  function copyNode() {
    const node = nodeStore.selectedNode;
    selectedNodeCopy.value = JSON.parse(JSON.stringify(node));
  }
</script>

<template v-if="selectedNodeCopy && NodeDetails[selectedNodeCopy.type]">
  <div class="editor">
    <datalist id="condition-list">
      <option v-for="option in conditionList" :value="option"></option>
    </datalist>
    <span class="p-float-label mt-6 nodeType">
      <AutoComplete inputId="nodeType" v-model="selectedNodeType" @complete="searchNodeTypes" optionLabel="display" dropdown forceSelection :suggestions="filteredNodeTypes" />
      <label for="nodeType">Node Type</label>
    </span>
    <div class="inputs">
      <template v-for="input in NodeDetails[selectedNodeCopy.type].inputs" :key="input.name">
        <template v-if="input.type === 'string'">
          <span class="p-float-label mt-6">
            <InputText :id="`input-${input.name}`" class="ml-1 mr-1" v-model="selectedNodeCopy.inputs[input.name]" />
            <label class="pl-2" :for="`input-${input.name}`">{{ input.display || input.name }}</label>
          </span>
        </template>
        <template v-if="input.type === 'string[]'">
          <span class="p-float-label mt-6">
            <InputText :id="`input-${input.name}`" class="ml-1 mr-1" v-model="selectedNodeCopy.inputs[input.name]" />
            <label class="pl-2" :for="`input-${input.name}`">{{ input.display || input.name }}</label>
          </span>
        </template>
        <template v-if="input.type === 'number'">
          <span class="p-float-label mt-6">
            <InputNumber :id="`input-${input.name}`" :min="input.min" :max="input.max" class="ml-1 mr-1" v-model="selectedNodeCopy.inputs[input.name]" />
            <label class="pl-2" :for="`input-${input.name}`">{{ input.display || input.name }}</label>
          </span>
        </template>
        <template v-if="input.type === 'boolean'">
          <span class="bool" style="display: flex; flex-direction: column">
            <label style="display: " class="pl-2" :for="`input-${input.name}`">{{ input.display || input.name }}</label>
            <SelectButton style="margin: auto" :id="`input-${input.name}`" v-model="selectedNodeCopy.inputs[input.name]" :options="boolOptions" aria-labelledby="basic" />
          </span>
        </template>

        <!--
        <template v-if="input.type === 'condition' || input.type === 'action'">
          <input v-model="selectedNodeCopy.inputs[input.name]" :list="input.type + '-list'" />
        </template> -->
      </template>
    </div>
    <Button label="Apply Changes" class="applyButton" raised :disabled="!hasChanges" @click="saveChanges"></Button>
  </div>
</template>

<style scoped>

  .editor {
    grid-area: editor;
    display: grid;
    grid-template-rows: min-content 1fr min-content; /* Adjusted row definitions */
    height: 100%; /* Full height of the parent container */
  }

  .nodeType {
    /* Styling for the nodeType section */
  }

  .inputs {
    overflow-y: auto; /* Scroll only this section */
    /* No need to set a height here, as it will fill the available space */
  }

  .applyButton {
    /* Styling for the button */
    align-content: center;
  }


</style>
