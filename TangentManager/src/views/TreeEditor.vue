//TreeEditor.vue
<script lang="ts" setup>
  import KonvaStage from '@/components/KonvaStage.vue';
  import TextMenu from '@/components/TextMenu.vue';
  import TextMenuItem from '@/components/TextMenuItem.vue';
  import { onMounted, onBeforeUnmount, nextTick, ref, watch } from 'vue';
  import { nodeStore } from '@/stores';
  import TreeNodeEditor from '@/components/TreeNodeEditor.vue';
  import ConfirmationDialog from '@/components/ConfirmationDialog.vue';
  import { NodeType } from '@/types/TreeNode';

  const containerRef = ref<HTMLDivElement | null>(null);
  const fileInput = ref<HTMLInputElement | null>(null);
  const confirmDialogRef = ref<ConfirmationDialog | null>(null);
  const konvaStageRef = ref<KonvaStage | null>(null);
  const message = ref('');

  const currentAction = ref<string | null>(null);

  let intersectingNodeIdCache = null as string | null;
  let draggedNodeIdCache = null as string | null;

  function placeNode(intersectingNodeId: string | null, draggedNodeId: string | null) {
    if (intersectingNodeId == null || draggedNodeId == null) return;
    nodeStore.placeNode(intersectingNodeId, draggedNodeId);
    konvaStageRef.value.redrawStage();
  }

  function handleDialogAction(action: string) {
    currentAction.value = action;
  }

  watch(currentAction, (newValue) => {
    if (newValue && newValue.toLowerCase() === 'confirm') {
      placeNode(intersectingNodeIdCache, draggedNodeIdCache);
      // Reset current action
      currentAction.value = null;
      intersectingNodeIdCache = null;
      draggedNodeIdCache = null;
    }
  });

  const handleNodeIntersection = ({ draggedNodeId, intersectingNodeId }: any) => {
    let canPlaceResults = nodeStore.canPlaceNode(intersectingNodeId, draggedNodeId);
    if (!canPlaceResults.canPlace) return;
    if (canPlaceResults.shouldConfirm) {
      message.value = canPlaceResults.message;
      confirmDialogRef.value.show();

      // Cache the node IDs, don't set currentAction.value here
      intersectingNodeIdCache = intersectingNodeId;
      draggedNodeIdCache = draggedNodeId;
    } else {
      placeNode(intersectingNodeId, draggedNodeId);
    }
  };

  function deleteSelected() {
    nodeStore.deleteSelectedNode();
  }

  function handleFileChange(event: Event) {
    const target = event.target as HTMLInputElement;
    const file = target.files ? target.files[0] : null;
    if (file) {
      const reader = new FileReader();
      reader.onload = function () {
        const content = reader.result as string;
        nodeStore.loadTree(content);
        konvaStageRef.value.centerAndZoomStage();
      };
      reader.readAsText(file);
    }
    target.value='';
  }

  function loadJsonClicked() {
    fileInput.value?.click();
  }
  function saveJsonClicked() {
    const treeJson = nodeStore.generateTreeJson();
    const blob = new Blob([treeJson], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'tree.json';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }

  function handleKeydown(event: any) {
    if (event.key === 'Delete') {
      deleteSelected();
    }
  }

  function createNode(nodeType: NodeType) {
    const emptyNodes = Object.keys(nodeStore.nodes).length === 0;
    nodeStore.addNode(nodeType);
    if(emptyNodes){
      konvaStageRef.value.centerAndZoomStage();
    }
  }

  onBeforeUnmount(() => {
    window.removeEventListener('keydown', handleKeydown);
  });

  onMounted(() => {
    window.addEventListener('keydown', handleKeydown);
    nextTick(() => {
      //nodeStore.loadTree(jsonString);
      nodeStore.setupLayoutWatchers();
    });
  });
</script>

<template>
  <input ref="fileInput" accept="application/JSON" style="display: none" type="file" @change="handleFileChange" />
  <div class="container">
    <div class="toolbar">
      <text-menu>
        <text-menu-item>
          File
          <template #children>
            <text-menu-item action="save" @item-clicked="saveJsonClicked">
              Save
              <fa-icon icon="fa-solid fa-floppy-disk"></fa-icon>
            </text-menu-item>
            <text-menu-item action="Load" @item-clicked="loadJsonClicked"> Load Json </text-menu-item>
          </template>
        </text-menu-item>
        <text-menu-item>
          Edit
          <template #children>
            <text-menu-item>
              Add
              <template #children>
                <text-menu-item v-for="nodeType in NodeType" @item-clicked="createNode" :action="nodeType">
                  {{ nodeType }}
                </text-menu-item>
              </template>
            </text-menu-item>
            <text-menu-item @item-clicked="deleteSelected" action="delete">Delete</text-menu-item>
          </template>
        </text-menu-item>
      </text-menu>
    </div>
    <div ref="containerRef" class="canvas">
      <konva-stage v-if="containerRef" :containerRef="containerRef" @nodeIntersection="handleNodeIntersection" ref="konvaStageRef" />
    </div>
    <div class="editor">
      <tree-node-editor />
    </div>
  </div>
  <confirmation-dialog ref="confirmDialogRef" @action="handleDialogAction">
    <template #heading>Confirm Node Move</template>
    {{ message }}
  </confirmation-dialog>
</template>

<style scoped>
  .canvas {
    background-color: var(--canvas-bg-color);
    grid-area: canvas;
    height: 100%;
  }

  .editor {
    grid-area: editor;
    display: flex;
    flex-direction: column;
  }

  .toolbar {
    grid-area: toolbar;
    background-color: var(--menu-bg-color);
    /* Add any other styles for the new row here */
  }

  .container {
    display: grid;
    grid-template-areas:
      'toolbar toolbar toolbar toolbar editor'
      'canvas canvas canvas canvas editor';
    grid-template-columns: 1fr 1fr 1fr 1fr 1fr; /* 5 columns */
    grid-template-rows: auto 1fr; /* 10% for the new row's height, 90% for the canvas */
    height: 100%;
  }
</style>
