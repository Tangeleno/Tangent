<script lang="ts" setup>
import {computed, ref, watch, watchEffect} from 'vue';
import {nodeStore} from "@/stores";
import {NodeType,NodeDetails, TreeNode,Actions,Conditions} from "@/types/TreeNode.ts";

const selectedNodeCopy = ref<TreeNode|null>(null);
const hasChanges = ref(false);
const actionList = computed(()=>Object.values(Actions));
const conditionList = computed(()=>Object.values(Conditions));
watch(()=>nodeStore.selectedNodeId,(newNodeId)=>{
  if (newNodeId){
    const node = nodeStore.selectedNode;
    selectedNodeCopy.value = JSON.parse(JSON.stringify(node));
  } else {
    selectedNodeCopy.value = null;
  }
});

watchEffect(() => {
  if (selectedNodeCopy.value) {
    const original = nodeStore.selectedNode;
    hasChanges.value = JSON.stringify(selectedNodeCopy.value) !== JSON.stringify(original);
  }
});
const saveChanges = function(){
  nodeStore.selectedNode.type = selectedNodeCopy.value.type;
  for (const input of NodeDetails[selectedNodeCopy.value.type].inputs) {
    console.log(input.name)
    nodeStore.selectedNode.inputs[input.name] =selectedNodeCopy.value.inputs[input.name] 
  }
}

</script>

<template>
  <datalist id="action-list">
    <option v-for="option in actionList" :value="option"></option>
  </datalist>
  <datalist id="condition-list">
    <option v-for="option in conditionList" :value="option"></option>
  </datalist>
  <template v-if="selectedNodeCopy">
    <label>Node Type
      <select id="typeSelector" v-model="selectedNodeCopy.type" name="type">
        <option v-for="type in NodeType" :value="type">{{ type }}</option>
      </select>
    </label>
    <div v-for="input in NodeDetails[selectedNodeCopy.type].inputs" :key="input.name">
      <span class="label">
        <label>{{ input.display }} </label>
        <fa-icon icon="circle-info" :title="input.description"></fa-icon>
      </span>
      
      <template v-if="input.type === 'string' || input.type === 'string[]'">
        <input v-model="selectedNodeCopy.inputs[input.name]" type="text" :placeholder="input.description">
      </template>

      <template v-if="input.type === 'number'">
        <input v-model="selectedNodeCopy.inputs[input.name]" type="number" :placeholder="input.description">
      </template>
      
      <template v-if="input.type === 'bool'">
        <select v-model="selectedNodeCopy.inputs[input.name]" :placeholder="input.description">
          <option>true</option>
          <option>false</option>
        </select>
      </template>
      <template v-if="input.type === 'condition' || input.type === 'action'">
        <input v-model="selectedNodeCopy.inputs[input.name]" :list="input.type + '-list'"/>
      </template>
    </div>
    <button :disabled="!hasChanges" @click="saveChanges">Apply Changes</button>
  </template>
</template>

<style scoped>
input, select {
  display: flex;
  flex-direction: column;
  font-size: 1.25em;
}
label {
  padding-right: 1em;
  font-size: 1.25em;
}
.editor select {
  
}
.editor button {
    margin-top: auto;
}

</style>