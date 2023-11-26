//TreeEditor.vue
<script lang="ts" setup>
import KonvaStage from "@/components/KonvaStage.vue";
import TextMenu from "@/components/TextMenu.vue";
import TextMenuItem from "@/components/TextMenuItem.vue";
import {onMounted, nextTick, ref, watch} from 'vue';
import {nodeStore} from '@/stores';
import TreeNodeEditor from "@/components/TreeNodeEditor.vue";
import ConfirmationDialog from "@/components/ConfirmationDialog.vue";

const containerRef = ref<HTMLDivElement | null>(null);
const fileInput = ref<HTMLInputElement | null>(null);
const confirmDialogRef = ref<ConfirmationDialog | null>(null);
const konvaStageRef = ref<KonvaStage | null>(null)
const message = ref("");

const currentAction = ref<string | null>(null);

let intersectingNodeIdCache = null;
let draggedNodeIdCache = null;

function placeNode(intersectingNodeId, draggedNodeId) {
  nodeStore.placeNode(intersectingNodeId, draggedNodeId)
  konvaStageRef.value.redrawStage()
}

function handleDialogAction(action) {
  currentAction.value = action
}

watch(currentAction, (newValue) => {
  if (newValue && newValue.toLowerCase() === 'confirm') {
    placeNode(intersectingNodeIdCache, draggedNodeIdCache);
    // Reset current action
    currentAction.value = null;
    intersectingNodeIdCache = null;
    draggedNodeIdCache = null
  }
});

const handleNodeIntersection = ({draggedNodeId, intersectingNodeId}) => {
  let canPlaceResults = nodeStore.canPlaceNode(intersectingNodeId, draggedNodeId);
  if (!canPlaceResults.canPlace)
    return;
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

function handleFileChange(event) {
  const file = event.target.files[0];
  if (file) {
    const reader = new FileReader();
    reader.onload = function () {
      const content = reader.result;
      nodeStore.loadTree(content);
    }
    reader.readAsText(file);
  }
}

function loadJsonClicked() {
  fileInput.value?.click();
}

onMounted(() => {
  // const nodeData = {
  //   node1: {
  //     type: "SequenceNode",
  //     id: "node1",
  //     name: "Node A",
  //     parentId: null,
  //     childrenIds: ["node2", "node6", "node7"]
  //   },
  //   node2: {
  //     type: "SelectNode",
  //     id: "node2",
  //     name: "attack",
  //     parentId: "node1",
  //     childrenIds: ["node14", "node4", "node5"]
  //   },
  //   node14: {
  //     type: "InvertNode",
  //     id: "node14",
  //     name: "SpitInverter",
  //     parentId: "node2",
  //     childrenIds: ["node3"]
  //   },
  //   node3: {
  //     type: "ActionNode",
  //     id: "node3",
  //     name: "Spit",
  //     parentId: "node14",
  //     childrenIds: []
  //   },
  //   node4: {
  //     type: "ActionNode",
  //     id: "node4",
  //     name: "Kick",
  //     parentId: "node2",
  //     childrenIds: []
  //   },
  //   node5: {
  //     type: "ActionNode",
  //     id: "node5",
  //     name: "Punch",
  //     parentId: "node2",
  //     childrenIds: []
  //   },
  //   node6: {
  //     type: "ActionNode",
  //     id: "node6",
  //     name: "bite",
  //     parentId: "node1",
  //     childrenIds: []
  //   },
  //   node7: {
  //     type: "SequenceNode",
  //     id: "node7",
  //     name: "defend",
  //     parentId: "node1",
  //     childrenIds: ["node8", "node9", "node10"]
  //   },
  //   node8: {
  //     type: "ActionNode",
  //     id: "node8",
  //     name: "Parry",
  //     parentId: "node7",
  //     childrenIds: []
  //   },
  //   node9: {
  //     type: "ActionNode",
  //     id: "node9",
  //     name: "Riposte",
  //     parentId: "node7",
  //     childrenIds: []
  //   },
  //   node10: {
  //     type: "SequenceNode",
  //     id: "node10",
  //     name: "Shield",
  //     parentId: "node7",
  //     childrenIds: ["node12", "node13", "node11"]
  //   }, node12: {
  //     type: "ActionNode",
  //     id: "node12",
  //     name: "Hold Up Shield",
  //     parentId: "node10",
  //     childrenIds: []
  //   },
  //   node11: {
  //     type: "ActionNode",
  //     id: "node11",
  //     name: "Grab Shield",
  //     parentId: "node10",
  //     childrenIds: []
  //   },
  //
  //   node13: {
  //     type: "ActionNode",
  //     id: "node13",
  //     name: "Deflect Attack",
  //     parentId: "node10",
  //     childrenIds: []
  //   }
  // }
  // const simpleNode = {
  //   "n0": {
  //     "name": "Root Node",
  //     "type": "SequenceNode",
  //     "id": "n0",
  //     "parentId": null,
  //     "childrenIds": ["n1", "n3", "n4"]
  //   },
  //   "n1": {
  //     "name": "TargetInverter",
  //     "id": "n1",
  //     "type": "InvertNode",
  //     "parentId": "n0",
  //     "childrenIds": ["n2"]
  //   },
  //   "n2": {
  //     "name": "Have Target",
  //     "id": "n2",
  //     "type": "ConditionNode",
  //     "conditionName": "haveCorrectTarget",
  //     "parentId": "n1",
  //     "paramKeys": ["targetId"]
  //   },
  //   "n3": {
  //     "name": "Target Is Valid",
  //     "id": "n3",
  //     "type": "ConditionNode",
  //     "conditionName": "isValidTarget",
  //     "parentId": "n0",
  //     "paramKeys": ["targetId", "spawnType"]
  //   },
  //   "n4": {
  //     "name": "Target",
  //     "id": "n4",
  //     "type": "ActionNode",
  //     "actionName": "target",
  //     "parentId": "n0",
  //     "paramKeys": ["targetId", "spawnType"]
  //   }
  // }
  const jsonString = '{  "name": "Root Node",  "type": "SequenceNode",  "children": [    {      "name": "TargetInverter",      "type": "InvertNode",      "children": [        {          "name": "Have Target",          "type": "ConditionNode",          "conditionName": "haveCorrectTarget",          "paramKeys": [            "targetId"          ]        }      ]    },    {      "name": "Target Is Valid",      "type": "ConditionNode",      "conditionName": "isValidTarget",      "paramKeys": [        "targetId",        "spawnType"      ]    },    {      "name": "Target",      "type": "ActionNode",      "actionName": "target",      "paramKeys": [        "targetId",        "spawnType"      ]    }  ]} ';
  
  nextTick(() => {
    // const jsonString = JSON.stringify(simpleNode);
    nodeStore.loadTree(jsonString);
    nodeStore.setupLayoutWatchers();
    konvaStageRef.value.centerAndZoomStage();
  });
})

</script>

<template>
  <input ref="fileInput" accept="application/JSON" style="display: none" type="file" @change="handleFileChange"/>
  <div class="container">
    <div class="toolbar">
      <text-menu>
        <text-menu-item>
          File
          <template #children>
            <text-menu-item action="save">Save
              <fa-icon icon="fa-solid fa-floppy-disk"></fa-icon>
            </text-menu-item>
            <text-menu-item action="Load" @item-clicked="loadJsonClicked">
              Load Json
            </text-menu-item>
          </template>
        </text-menu-item>
        <text-menu-item>
          Edit
          <template #children>
            <text-menu-item>Name
              <template #children>
                <text-menu-item>Case
                  <template #children>
                    <text-menu-item action="changeToUpper">Upper</text-menu-item>
                    <text-menu-item action="changeToLower">Lower</text-menu-item>
                  </template>
                </text-menu-item>

              </template>
            </text-menu-item>
            <text-menu-item>
              Change Shape
              <template #children>
                <text-menu-item action="changeToCircle">Circle</text-menu-item>
                <text-menu-item action="changeToSquare">Square</text-menu-item>
              </template>
            </text-menu-item>
          </template>
        </text-menu-item>
        <text-menu-item action="displayHelp">Help Is really really long text</text-menu-item>
      </text-menu>
    </div>
    <div ref="containerRef" class="canvas">
      <konva-stage
          :containerRef="containerRef!"
          @nodeIntersection="handleNodeIntersection"
          ref="konvaStageRef"/>
    </div>
    <div class="editor">
      <tree-node-editor/>
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
        "toolbar toolbar toolbar toolbar editor"
        "canvas canvas canvas canvas editor";
  grid-template-columns: 1fr 1fr 1fr 1fr 1fr; /* 5 columns */
  grid-template-rows: auto 1fr; /* 10% for the new row's height, 90% for the canvas */
  height: 100%
}
</style>