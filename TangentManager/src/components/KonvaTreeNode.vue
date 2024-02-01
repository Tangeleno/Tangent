<template>
  <!-- Group as a container for each node -->
  <v-group
    :id="node.id"
    :x="node.x"
    :y="node.y"
    draggable="true"
    @click="handleClick"
    @dragend="onDragEnd"
    @dragstart="onDragStart"
    @mouseout="handleMouseEvent('mouseout')"
    @mouseover="handleMouseEvent('mouseover')">
    <!--Composite Nodes-->
    <v-rect
      v-if="node.type === NodeType.Select"
      :fill="getFillColor(node.type)"
      :height="nodeHeight"
      :stroke="selected ? 'yellow' : 'black'"
      :strokeWidth="2"
      :width="nodeWidth"
      :skewX="skewXValue" />
    <v-rect
      v-if="node.type === NodeType.Sequence"
      :fill="getFillColor(node.type)"
      :height="nodeHeight"
      :stroke="selected ? 'yellow' : 'black'"
      :strokeWidth="2"
      :width="nodeWidth"
      :skewX="skewXValue" />
    <v-rect
      v-if="node.type === NodeType.Parallel"
      :fill="getFillColor(node.type)"
      :height="nodeHeight"
      :stroke="selected ? 'yellow' : 'black'"
      :strokeWidth="2"
      :width="nodeWidth" />
    <v-rect
      v-if="node.type === NodeType.RandomSelector"
      :fill="getFillColor(node.type)"
      :height="nodeHeight"
      :stroke="selected ? 'yellow' : 'black'"
      :strokeWidth="2"
      :width="nodeWidth"
      :cornerRadius="10"
      :skewX="skewXValue" />

    <!-- Decorator Nodes -->
    <v-line
      v-if="node.type === NodeType.Invert"
      :points="[0, nodeHeight, nodeWidth / 2, 0, nodeWidth, nodeHeight]"
      :fill="getFillColor(node.type)"
      :closed="true"
      :stroke="selected ? 'yellow' : 'black'"
      :strokeWidth="2" />
    <v-line
      v-if="node.type === NodeType.Repeat"
      :points="[0, 0, nodeWidth, nodeHeight / 2, 0, nodeHeight]"
      :fill="getFillColor(node.type)"
      :closed="true"
      :stroke="selected ? 'yellow' : 'black'"
      :strokeWidth="2" />
    <v-line
      v-if="node.type === NodeType.Retry"
      :points="[0, nodeHeight / 2, nodeWidth, 0, nodeWidth, nodeHeight]"
      :fill="getFillColor(node.type)"
      :closed="true"
      :stroke="selected ? 'yellow' : 'black'"
      :strokeWidth="2" />
    <v-line
      v-if="node.type === NodeType.Loop"
      :points="[0, nodeHeight, nodeWidth / 2, 0, nodeWidth, nodeHeight]"
      :fill="getFillColor(node.type)"
      :closed="true"
      :stroke="selected ? 'yellow' : 'black'"
      :strokeWidth="2" />

    <!-- Leaf Nodes -->
    <v-ellipse
      v-if="NodeDetails[node.type].category === NodeCategory.Action"
      :fill="getFillColor(node.type)"
      :radius="{ x: nodeWidth / 2, y: nodeHeight / 2 }"
      :stroke="selected ? 'yellow' : 'black'"
      :strokeWidth="2"
      :x="nodeWidth / 2"
      :y="nodeHeight / 2" />
    <v-ellipse
      v-if="node.type === NodeType.Wait"
      :fill="getFillColor(node.type)"
      :radius="{ x: nodeWidth / 2, y: nodeHeight / 2 }"
      :stroke="selected ? 'yellow' : 'black'"
      :strokeWidth="2"
      :x="nodeWidth / 2"
      :y="nodeHeight / 2" />
    <v-ellipse
      v-if="node.type === NodeType.Failer"
      :fill="getFillColor(node.type)"
      :radius="{ x: nodeWidth / 2, y: nodeHeight / 2 }"
      :stroke="selected ? 'yellow' : 'black'"
      :strokeWidth="2"
      :x="nodeWidth / 2"
      :y="nodeHeight / 2" />
    <v-ellipse
      v-if="node.type === NodeType.Succeeder || node.type === NodeType.Condition"
      :fill="getFillColor(node.type)"
      :radius="{ x: nodeWidth / 2, y: nodeHeight / 2 }"
      :stroke="selected ? 'yellow' : 'black'"
      :strokeWidth="2"
      :x="nodeWidth / 2"
      :y="nodeHeight / 2" />

    <!-- Render the node's name on the shape -->
    <v-text
      :fill="'#f7f7f7'"
      :fillAfterStrokeEnabled="true"
      :fontSize="10"
      :height="nodeHeight"
      :stroke="'#010101'"
      :strokeWidth="3"
      :text="node.type"
      :width="nodeWidth"
      align="center"
      :y="-16"
      verticalAlign="middle" />
    <v-text
      :fill="'#f7f7f7'"
      :fillAfterStrokeEnabled="true"
      :fontSize="16"
      :height="nodeHeight"
      :stroke="'#010101'"
      :strokeWidth="3"
      :text="node.inputs.name"
      :width="nodeWidth"
      align="center"
      verticalAlign="middle" />
  </v-group>
</template>

<script lang="ts" setup>
  import { computed, PropType } from 'vue';
  import { NodeType, NodeDetails, TreeNode, NodeCategory } from '../types/TreeNode.ts';

  const props = defineProps({
    node: {
      type: Object as PropType<TreeNode>,
      required: true,
    },
    nodeWidth: Number,
    nodeHeight: Number,
    selected: Boolean,
  });

  const emit = defineEmits(['update:isShapeDragging', 'mouseout', 'mouseover', 'nodeDragEnd', 'nodeClick']);

  const skewXValue = computed(() => {
    if (props.node!.type === NodeType.Select || props.node!.type === NodeType.RandomSelector) return 0.15;
    if (props.node!.type === NodeType.Sequence) return -0.15;
    return 0;
  });

  const getCategoryColor = (nodeCategory:NodeCategory) => {
  // Hash the category name to get the base hue
  let baseHue = 0;
  switch (nodeCategory) {
    case NodeCategory.Composite:
      baseHue = 60; 
      break;
    case NodeCategory.Decorator:
      baseHue = 330;
      break;
    case NodeCategory.Action:
      baseHue = 240;
      break;
    case NodeCategory.Leaf:
      baseHue = 150;
      break;
    default:
      baseHue = 0; // Default to Red
  }
  return baseHue;

  return baseHue;
};

const hslToHex = (h:number, s:number, l:number) => {
  h /= 360;
  s /= 100;
  l /= 100;

  let r, g, b;
  if (s === 0) {
    r = g = b = l; // achromatic
  } else {
    const hue2rgb = (p:number, q:number, t:number) => {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (t < 1 / 6) return p + (q - p) * 6 * t;
      if (t < 1 / 2) return q;
      if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
      return p;
    };
    const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    const p = 2 * l - q;
    r = hue2rgb(p, q, h + 1 / 3);
    g = hue2rgb(p, q, h);
    b = hue2rgb(p, q, h - 1 / 3);
  }

  const toHex = (x:number) => {
    const hex = Math.round(x * 255).toString(16);
    return hex.length === 1 ? "0" + hex : hex;
  };

  return `#${toHex(r)}${toHex(g)}${toHex(b)}`;
};

const getFillColor = (nodeType:NodeType) => {
  const nodeCategory = NodeDetails[nodeType].category
  // Get the base hue for the category
  const baseHue = getCategoryColor(nodeCategory);

  // Hash function for the node type
  let hash = 0;
  for (let i = 0; i < nodeType.length; i++) {
    hash = nodeType.charCodeAt(i) + ((hash << 5) - hash);
  }

  // Calculate the hue offset based on the node type
  const hueOffset = ((hash % 60) + 60) % 45; // Adjust the range as needed

  // Calculate the final hue
  const finalHue = (baseHue + hueOffset) % 360;

  // Convert hue to HSL color and then to hex
  const color = hslToHex(finalHue, 70, 60); // Adjust saturation and lightness as needed

  return color;
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
