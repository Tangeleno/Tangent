//TreeEditor.vue
<script lang="ts" setup>
  import KonvaTreeStage from '@/components/KonvaTreeStage.vue';
  import { onMounted, onBeforeUnmount, nextTick, ref } from 'vue';
  import { nodeStore } from '@/stores';
  import TreeNodeEditor from '@/components/TreeNodeEditor.vue';
  import { NodeType, NodeCategory, NodeDetails } from '@/types/TreeNode';
  import Menubar from 'primevue/menubar';
  import ConfirmDialog from 'primevue/confirmdialog';
  import { useConfirm } from 'primevue/useconfirm';
  import { useToast } from "primevue/usetoast";
  const containerRef = ref<HTMLDivElement | null>(null);
  const fileInput = ref<HTMLInputElement | null>(null);
  const konvaStageRef = ref<typeof KonvaTreeStage | null>(null);
  const confirm = useConfirm();
  const toast = useToast();
  let intersectingNodeIdCache = null as string | null;
  let draggedNodeIdCache = null as string | null;

  function placeNode(intersectingNodeId: string | null, draggedNodeId: string | null) {
    if (intersectingNodeId == null || draggedNodeId == null) return;
    nodeStore.placeNode(intersectingNodeId, draggedNodeId);
    if (konvaStageRef.value) {
      konvaStageRef.value.redrawStage();
    }
  }

  const handleNodeIntersection = ({ draggedNodeId, intersectingNodeId }: any) => {
    let canPlaceResults = nodeStore.canPlaceNode(intersectingNodeId, draggedNodeId);
    if (!canPlaceResults.canPlace) return;
    if (canPlaceResults.shouldConfirm) {
      confirm.require({
        message: canPlaceResults.message,
        header: 'Confirm Node Move',
        icon: 'pi pi-exclamation-triangle',
        accept: () => {
          placeNode(intersectingNodeIdCache, draggedNodeIdCache);
          intersectingNodeIdCache = null;
          draggedNodeIdCache = null;
        },
      });

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
        if (konvaStageRef.value) {
          konvaStageRef.value.centerAndZoomStage();
        }
      };
      reader.readAsText(file);
    }
    target.value = '';
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

  function copyJsonClicked() {
    const treeJson = nodeStore.generateTreeJson();
    navigator.clipboard
      .writeText(treeJson)
      .then(function () {
        toast.add({severity:'success',summary:'Copied','detail':'Tree json copied to clipboard',life:2000})
      })
      .catch(function (err) {
        toast.add({severity:'warn',summary:'Copy Failed','detail':'An error occured while copying to the clip board. See the console for more info.',life:5000})
        console.error('Could not copy text to clipboard: ', err);
      });
  }

  function loadSubtreeClicked(treeName: string) {
    const emptyNodes = Object.keys(nodeStore.nodes).length === 0;
    nodeStore.loadSubtree(treeName);
    if (emptyNodes) {
      konvaStageRef.value.centerAndZoomStage();
    }
  }

  function handleKeydown(event: any) {
    if (event.key === 'Delete') {
      deleteSelected();
    }
  }
  function createNode(nodeType: NodeType) {
    const emptyNodes = Object.keys(nodeStore.nodes).length === 0;
    nodeStore.addNode(nodeType);
    if (emptyNodes) {
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

  const toobarItems = ref([
    {
      label: 'File',
      icon: 'pi pi-file',
      items: [
        {
          label: 'Save',
          icon: 'pi pi-save',
          command: saveJsonClicked,
        },
        {
          label: 'Copy Json',
          icon: 'pi pi-copy',
          command: copyJsonClicked,
        },
        {
          label: 'Load Json',
          icon: 'pi pi-upload',
          command: loadJsonClicked,
        },
      ],
    },
    {
      label: 'Edit',
      icon: 'pi pi-palette',
      items: [
        {
          label: 'Add',
          icon: 'pi pi-plus',
          items: Object.keys(NodeCategory).map((category) => ({
            label: category,
            items: Object.keys(NodeDetails)
              .filter((key): key is NodeType => NodeDetails[key as NodeType].category === category)
              .map((key) => ({ label: key, command: () => createNode(key) })),
          })),
        },
      ],
    },
    {
      label: 'Subtrees',
      items: nodeStore.subTrees.map((tree) => {
        return { label: tree, command: () => loadSubtreeClicked(tree) };
      }),
    },
  ]);
</script>

<template>
  <input ref="fileInput" accept="application/JSON" style="display: none" type="file" @change="handleFileChange" />
  <div class="tree-view-container">
    <Menubar class="toolbar" :model="toobarItems" />
    <div ref="containerRef" class="canvas">
      <konva-tree-stage v-if="containerRef" :containerRef="containerRef" @nodeIntersection="handleNodeIntersection" ref="konvaStageRef" />
    </div>
    <div v-if="nodeStore.selectedNodeId" class="editor">
      <TreeNodeEditor />
    </div>
  </div>
  <ConfirmDialog></ConfirmDialog>
</template>

<style scoped>

  .canvas {
    background-color: var(--surface-card);
    grid-area: canvas;
    height: 100%;
  }

  .editor {
    grid-area: editor;
    z-index: 100;
    background-color: rgba(0, 0, 0, 0.1); /* Adjust for desired transparency */
    backdrop-filter: blur(0.5em);
    overflow: auto;
  }

  .toolbar {
    grid-area: toolbar;
    /* Add any other styles for the new row here */
  }

  .tree-view-container {
    display: grid;
    grid-template-areas:
      'toolbar toolbar'
      'canvas editor';
    grid-template-columns: minmax(0, 1fr) auto; /* Adjust the width as needed */
    grid-template-rows: auto 1fr;
    height: 100%;
  }
</style>
