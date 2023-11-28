<template>
  <!-- Group as a container for each node -->
  <v-group :id="node.id" :x="node.x" :y="node.y" draggable="true" @click="handleClick" @dragend="onDragEnd"
           @dragstart="onDragStart" @mouseout="handleMouseEvent('mouseout')" @mouseover="handleMouseEvent('mouseover')">

    <!--Composite Nodes-->
    <v-rect v-if="node.type === NodeType.Select"
            :fill="getFillColor(node.type)"
            :height="nodeHeight"
            :stroke="selected ? 'yellow' : 'black'"
            :strokeWidth="2"
            :width="nodeWidth"
            :skewX="skewXValue"/>
    <v-rect v-if="node.type === NodeType.Sequence"
            :fill="getFillColor(node.type)"
            :height="nodeHeight"
            :stroke="selected ? 'yellow' : 'black'"
            :strokeWidth="2"
            :width="nodeWidth"
            :skewX="skewXValue"/>
    <v-rect v-if="node.type === NodeType.Parallel"
            :fill="getFillColor(node.type)"
            :height="nodeHeight"
            :stroke="selected ? 'yellow' : 'black'"
            :strokeWidth="2"
            :width="nodeWidth"/>
    <v-rect v-if="node.type === NodeType.RandomSelector"
            :fill="getFillColor(node.type)"
            :height="nodeHeight"
            :stroke="selected ? 'yellow' : 'black'"
            :strokeWidth="2"
            :width="nodeWidth"
            :cornerRadius="10"
            :skewX="skewXValue"/>

    <!-- Decorator Nodes -->
    <v-line v-if="node.type === NodeType.Invert"
            :points="[0, nodeHeight, nodeWidth/2, 0, nodeWidth, nodeHeight]"
            :fill="getFillColor(node.type)"
            :closed="true"
            :stroke="selected ? 'yellow' : 'black'"
            :strokeWidth="2"/>
    <v-line v-if="node.type === NodeType.Repeat"
            :points="[0,0,nodeWidth,nodeHeight/2,0,nodeHeight]"
            :fill="getFillColor(node.type)"
            :closed="true"
            :stroke="selected ? 'yellow' : 'black'"
            :strokeWidth="2"/>
    <v-line v-if="node.type === NodeType.Retry"
            :points="[0, nodeHeight/2, nodeWidth, 0, nodeWidth, nodeHeight]"
            :fill="getFillColor(node.type)"
            :closed="true"
            :stroke="selected ? 'yellow' : 'black'"
            :strokeWidth="2"/>
    <v-line v-if="node.type === NodeType.Loop"
            :points="[0, nodeHeight, nodeWidth/2, 0, nodeWidth, nodeHeight]"
            :fill="getFillColor(node.type)"
            :closed="true"
            :stroke="selected ? 'yellow' : 'black'"
            :strokeWidth="2"/>

    <!-- Leaf Nodes -->
    <v-ellipse v-if="node.type === NodeType.Action"
               :fill="getFillColor(node.type)"
               :radius="{x: nodeWidth/2, y: nodeHeight/2}"
               :stroke="selected ? 'yellow' : 'black'"
               :strokeWidth="2"
               :x="nodeWidth / 2"
               :y="nodeHeight / 2" />
    <v-ellipse v-if="node.type === NodeType.Wait"
               :fill="getFillColor(node.type)"
               :radius="{x: nodeWidth/2, y: nodeHeight/2}"
               :stroke="selected ? 'yellow' : 'black'"
               :strokeWidth="2"
               :x="nodeWidth / 2"
               :y="nodeHeight / 2" />
    <v-ellipse v-if="node.type === NodeType.Failer"
              :fill="getFillColor(node.type)"
              :radius="{x: nodeWidth/2, y: nodeHeight/2}"
              :stroke="selected ? 'yellow' : 'black'"
              :strokeWidth="2"
              :x="nodeWidth / 2"
              :y="nodeHeight / 2" />
    <v-ellipse v-if="node.type === NodeType.Succeeder || node.type === NodeType.Condition"
              :fill="getFillColor(node.type)"
              :radius="{x: nodeWidth/2, y: nodeHeight/2}"
              :stroke="selected ? 'yellow' : 'black'"
              :strokeWidth="2"
              :x="nodeWidth / 2"
              :y="nodeHeight / 2" />

    <!-- Render the node's name on the shape -->
    <v-text :fill="'#f7f7f7'"
            :fillAfterStrokeEnabled="true"
            :fontSize="10"
            :height="nodeHeight"
            :stroke="'#010101'"
            :strokeWidth="3"
            :text="node.type"
            :width="nodeWidth"
            align="center"
            y=-16
            verticalAlign="middle"/>
    <v-text :fill="'#f7f7f7'"
            :fillAfterStrokeEnabled="true"
            :fontSize="16"
            :height="nodeHeight"
            :stroke="'#010101'"
            :strokeWidth="3"
            :text="node.inputs.name"
            :width="nodeWidth"
            align="center"
            verticalAlign="middle"/>
  </v-group>
</template>

<script lang="ts" setup>
import { computed, PropType } from 'vue';
import { NodeType, TreeNode } from "../types/TreeNode.ts";

const props = defineProps({
  node: {
    type: Object as PropType<TreeNode>,
    required: true
  },
  nodeWidth: Number,
  nodeHeight: Number,
  selected: Boolean
});

const emit = defineEmits(['update:isShapeDragging', 'mouseout', 'mouseover', 'nodeDragEnd','nodeClick']);

const skewXValue = computed(() => {
  if (props.node!.type === NodeType.Select || props.node!.type === NodeType.RandomSelector) return 0.15;
  if (props.node!.type === NodeType.Sequence) return -0.15;
  return 0;
});

const getFillColor = (nodeType) => {
  switch (nodeType) {
    case NodeType.Select:
      return '#6B6BFF';
    case NodeType.Sequence:
      return '#6BC2FF';
    case NodeType.Parallel:
      return '#6BFFD1';
    case NodeType.RandomSelector:
      return '#6BFF6B';
    case NodeType.Invert:
      return '#FF6B6B';
    case NodeType.Repeat:
      return '#FFAA00';
    case NodeType.Retry:
      return '#FFD500';
    case NodeType.Loop:
      return '#C6FF00';
    case NodeType.Action:
      return '#0077B6';
    case NodeType.Wait:
      return '#00B4D8';
    case NodeType.Failer:
      return '#FF0000';
    case NodeType.Succeeder:
      return '#00FF00';
    case NodeType.Condition:
      return '#FFAAFF';
    default:
      return '#FFFFFF';
  }
};

const onDragStart = () => {
  emit('update:isShapeDragging', true);
};

const onDragEnd = (event) => {
  const group = event.currentTarget;
  props.node!.x = group.x();
  props.node!.y = group.y();
  emit('update:isShapeDragging', false);
  emit('nodeDragEnd', group);
};

const handleMouseEvent = (event) => {
  emit(event);
};

const handleClick = () => {
  emit('nodeClick', props.node!.id);
};
</script>