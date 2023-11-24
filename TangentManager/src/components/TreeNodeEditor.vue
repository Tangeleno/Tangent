<script lang="ts" setup>
import { ref, watch,watchEffect  } from 'vue';
import {nodeStore} from "@/stores";
import {NodeType,NodeDetails, TreeNode} from "@/types/TreeNode.ts";

const selectedNodeCopy = ref<TreeNode|null>(null);
const hasChanges = ref(false);

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
const getNodeInputs = function(){
  console.log(NodeType[selectedNodeCopy.value.type].inputs)
  return NodeType[selectedNodeCopy.value.type].inputs;
}
const saveChanges = function(){
  nodeStore.selectedNode.name = selectedNodeCopy.value.name;
  nodeStore.selectedNode.type = selectedNodeCopy.value.type;
}

</script>

<template>
  <template v-if="selectedNodeCopy">
    <label>Node Type
      <select id="typeSelector" v-model="selectedNodeCopy.type" name="type">
        <option v-for="type in NodeType" :value="type">{{ type }}</option>
      </select>
    </label>
    <div v-for="input in NodeDetails[selectedNodeCopy.type].inputs" :key="input.name">
      <label>{{ input.name }}</label>
      <template v-if="input.type === 'string' || input.type === 'number'">
        <input v-model="selectedNodeCopy[input.name]" type="text" :placeholder="input.description">
      </template>

      <template v-if="input.type === 'string[]'">
        <textarea v-model="selectedNodeCopy[input.name]" :placeholder="input.description"></textarea>
      </template>

      <template v-if="input.type === 'condition'">
        <select v-model="selectedNodeCopy[input.name]">
          <option v-for="condition in conditionOptions" :value="condition">{{ condition }}</option>
        </select>
      </template>
    </div>
    <button :disabled="!hasChanges" @click="saveChanges">Apply Changes</button>
  </template>
</template>

<style scoped>
input, select {
}
label{
  display: flex;
  flex-direction: column;
  font-size: 1.25em;
}
.editor select {
  
}
.editor button {
    margin-top: auto;
}

</style>