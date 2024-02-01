//KonvaStage.vue
<script lang="ts" setup>
  import { nextTick, onBeforeUnmount, onMounted, PropType, reactive, ref } from 'vue';
  import Konva from 'konva';
  import KonvaTreeNode from '@/components/KonvaTreeNode.vue'; // Import the KonvaNode component
  import { nodeStore } from '@/stores';
  import { NodeType, TreeNode } from '@/types/TreeNode.ts';
  import Shape = Konva.Shape;
  import Group = Konva.Group;
  import { Ellipse } from 'konva/lib/shapes/Ellipse';

  const props = defineProps({
    containerRef: {
      type: Object as PropType<HTMLDivElement>,
      required: true,
    },
  });

  const emit = defineEmits(['nodeIntersection']);

  const configKonva = reactive({
    width: 200, // default values, will be updated
    height: 200, // default values, will be updated
  });

  const stageRef = ref<Konva.Stage | null>(null);
  const isShapeDragging = ref(false);
  const currentScale = ref(1);
  let isDragging = false;
  let lastPos = { x: 0, y: 0 };

  const handleWheel = (event: WheelEvent) => {
    event.preventDefault();

    if (!stageRef.value) return;
    const stage = (stageRef.value as any).getStage() as Konva.Stage;
    // Zoom in or out based on the deltaY value of the wheel event
    // Smaller deltaY values indicate zooming in and vice versa
    const scaleBy = 1.05;
    const newScale = event.deltaY > 0 ? currentScale.value / scaleBy : currentScale.value * scaleBy;

    // Apply the new scale factor to the stage
    stage.scale({ x: newScale, y: newScale });
    stage.draw();

    // Update the current scale
    currentScale.value = newScale;
  };
  const doDrag = (event: Konva.KonvaEventObject<MouseEvent>) => {
    if (!isDragging || !stageRef.value) return;

    const deltaX = event.evt.clientX - lastPos.x;
    const deltaY = event.evt.clientY - lastPos.y;

    const stage = (stageRef.value as any).getStage() as Konva.Stage;

    stage.x(stage.x() + deltaX);
    stage.y(stage.y() + deltaY);
    stage.batchDraw();

    lastPos = {
      x: event.evt.clientX,
      y: event.evt.clientY,
    };
  };
  const endDrag = () => {
    isDragging = false;
    props.containerRef!.style.cursor = 'grab';
  };

  const onShapeMouseOver = () => {
    props.containerRef!.style.cursor = 'pointer';
  };

  const handleNodeDragEnd = (draggedShape: Group) => {
    // Check for intersections with other nodes
    const intersectingNode = checkForNodeIntersections(draggedShape);

    if (intersectingNode) {
      emit('nodeIntersection', { draggedNodeId: draggedShape.id(), intersectingNodeId: intersectingNode.id() });
    } else {
      //get the TreeNode based on id
      const draggedNode = nodeStore.nodes[draggedShape.id()];
      if (draggedNode.parentId) {
        const parentNode = nodeStore.nodes[draggedNode.parentId];
        const sortedChildren = [...parentNode.childrenIds].sort((a, b) => nodeStore.nodes[a].y - nodeStore.nodes[b].y);
        //check if the arrays are equal
        let areEqual = true;
        for (let i = 0; i < sortedChildren.length; i++) {
          if (parentNode.childrenIds![i] !== sortedChildren[i]) {
            areEqual = false;
            break;
          }
        }
        if (!areEqual) {
          parentNode.childrenIds = sortedChildren;
          //redo the tree layout for the parent node
          nodeStore.applyTreeLayout(parentNode.id);
        }
      }
    }
  };

  const checkForNodeIntersections = (draggedShape: Group) => {
    let intersectingShape = null;
    const stage = (stageRef.value as any).getStage() as Konva.Stage;

    //iterate over all the other groups in the stage
    for (const otherGroup of stage.find('Group')) {
      //confirm it's not the same node
      if (draggedShape.id() === otherGroup.id()) continue;
      //do bounding box check
      if (boundingBoxesCollide(draggedShape, otherGroup as Group)) {
        //do more detailed check
        if (trueShapesIntersect(draggedShape, otherGroup as Group)) {
          return otherGroup;
        }
      }
    }
    return intersectingShape;
  };
  function trueShapesIntersect(draggedShape: Group, otherGroup: Group) {
    // Get the actual shape (excluding text) from both groups
    const draggedActualShape = getShape(draggedShape) as Shape;
    const otherActualShape = getShape(otherGroup) as Shape;

    // Determine the shape type based on the Konva shape type
    const draggedShapeType = draggedActualShape.getClassName();
    const otherGroupShapeType = otherActualShape.getClassName();

    // Check for ellipse-ellipse intersection
    if (draggedShapeType === 'Ellipse' && otherGroupShapeType === 'Ellipse') {
      return ellipseEllipseIntersect(draggedActualShape as Konva.Ellipse, otherActualShape as Konva.Ellipse);
    }

    // Check for polygon-polygon intersection
    if ((draggedShapeType === 'Line' || draggedShapeType === 'Rect') && (otherGroupShapeType === 'Line' || otherGroupShapeType === 'Rect')) {
      return polygonPolygonIntersect(draggedActualShape, otherActualShape);
    }

    // Check for ellipse-polygon intersection
    if (draggedShapeType === 'Ellipse' && (otherGroupShapeType === 'Line' || otherGroupShapeType === 'Rect')) {
      return ellipsePolygonIntersect(draggedActualShape as Konva.Ellipse, otherActualShape);
    }

    // Check for polygon-ellipse intersection (reverse of the above)
    if ((draggedShapeType === 'Line' || draggedShapeType === 'Rect') && otherGroupShapeType === 'Ellipse') {
      return ellipsePolygonIntersect(otherActualShape as Konva.Ellipse, draggedActualShape);
    }

    // No intersections found
    return false;
  }
  // Helper function to check if a point is inside an ellipse
  function pointInsideEllipse(point: { x: any; y: any }, ellipse: Ellipse) {
    const dx = point.x - ellipse.x();
    const dy = point.y - ellipse.y();
    const rx = ellipse.radiusX();
    const ry = ellipse.radiusY();
    return (dx * dx) / (rx * rx) + (dy * dy) / (ry * ry) <= 1;
  }

  // Helper function to check if a line segment intersects with an ellipse
  function lineIntersectsEllipse(p0: { x: any; y: any }, p1: { x: any; y: any }, ellipse: Ellipse) {
    // Convert the problem into checking the line segment with the unit circle
    const scaleX = 1 / ellipse.radiusX();
    const scaleY = 1 / ellipse.radiusY();
    const scaledP0 = { x: (p0.x - ellipse.x()) * scaleX, y: (p0.y - ellipse.y()) * scaleY };
    const scaledP1 = { x: (p1.x - ellipse.x()) * scaleX, y: (p1.y - ellipse.y()) * scaleY };

    // Represent the line segment as a parametric equation in terms of t
    const dx = scaledP1.x - scaledP0.x;
    const dy = scaledP1.y - scaledP0.y;

    // Coefficients for the quadratic equation
    const a = dx * dx + dy * dy;
    const b = 2 * (scaledP0.x * dx + scaledP0.y * dy);
    const c = scaledP0.x * scaledP0.x + scaledP0.y * scaledP0.y - 1; // -1 because it's a unit circle

    // Calculate the discriminant
    const discriminant = b * b - 4 * a * c;

    // If the discriminant is negative, no intersection
    if (discriminant < 0) {
      return false;
    }

    // Calculate the two possible values of t
    const t1 = (-b - Math.sqrt(discriminant)) / (2 * a);
    const t2 = (-b + Math.sqrt(discriminant)) / (2 * a);

    // Check if any solution for t lies in the interval [0, 1]
    if ((t1 >= 0 && t1 <= 1) || (t2 >= 0 && t2 <= 1)) {
      return true;
    }

    return false;
  }

  function ellipsePolygonIntersect(ellipse: Konva.Ellipse, polygon: Konva.Shape) {
    const vertices = getVerticesFromKonva(polygon);

    // Check if any vertex of the polygon is inside the ellipse
    for (const vertex of vertices) {
      if (pointInsideEllipse(vertex, ellipse)) {
        return true;
      }
    }

    // Check if any edge of the polygon intersects the ellipse
    for (let i = 0; i < vertices.length; i++) {
      const p0 = vertices[i];
      const p1 = vertices[(i + 1) % vertices.length];
      if (lineIntersectsEllipse(p0, p1, ellipse)) {
        return true;
      }
    }

    // No intersections found
    return false;
  }

  function getShape(group: Group) {
    // Find and return the child in the group that isn't text
    for (const child of group.getChildren()) {
      if (child.getType() !== 'Text') {
        return child;
      }
    }
    return null;
  }

  function ellipseEllipseIntersect(ellipse1: Konva.Ellipse, ellipse2: Konva.Ellipse) {
    // Get properties of the first ellipse
    const center1 = { x: ellipse1.x(), y: ellipse1.y() };
    const a1 = ellipse1.radiusX();
    const b1 = ellipse1.radiusY();

    // Get properties of the second ellipse
    const center2 = { x: ellipse2.x(), y: ellipse2.y() };
    const a2 = ellipse2.radiusX();
    const b2 = ellipse2.radiusY();

    // Sample several points on the perimeter of the first ellipse
    for (let theta = 0; theta < 2 * Math.PI; theta += 0.1) {
      const x = center1.x + a1 * Math.cos(theta);
      const y = center1.y + b1 * Math.sin(theta);

      // Check if the point lies inside the second ellipse
      if (Math.pow(x - center2.x, 2) / Math.pow(a2, 2) + Math.pow(y - center2.y, 2) / Math.pow(b2, 2) <= 1) {
        return true;
      }
    }

    return false;
  }

  // Helper function to get the normal of an edge
  function getNormal(p0: { x: any; y: any }, p1: { x: any; y: any }) {
    const dx = p1.x - p0.x;
    const dy = p1.y - p0.y;
    return { x: dy, y: -dx }; // Perpendicular vector
  }

  // Helper function to project a polygon onto an axis
  function projectPolygon(axis: { x: any; y: any }, polygon: { x: number; y: number }[]) {
    let min = Infinity;
    let max = -Infinity;
    for (const vertex of polygon) {
      const dot = vertex.x * axis.x + vertex.y * axis.y;
      min = Math.min(min, dot);
      max = Math.max(max, dot);
    }
    return { min, max };
  }

  // Helper function to check if projections overlap
  function isOverlap(proj1: { min: any; max: any }, proj2: { min: any; max: any }) {
    return proj1.max > proj2.min && proj2.max > proj1.min;
  }

  // Helper function to get the vertices from a Konva.Line shape
  function getVerticesFromKonva(shape: Konva.Shape) {
    if (shape instanceof Konva.Line) {
      const flatPoints = shape.points();
      const vertices = [];
      for (let i = 0; i < flatPoints.length; i += 2) {
        vertices.push({ x: flatPoints[i], y: flatPoints[i + 1] });
      }
      return vertices;
    } else if (shape instanceof Konva.Rect) {
      const x = shape.x();
      const y = shape.y();
      const width = shape.width();
      const height = shape.height();
      const skewX = shape.skewX();
      return [
        { x: x, y: y },
        { x: x + width + skewX, y: y },
        { x: x + width, y: y + height },
        { x: x + skewX, y: y + height },
      ];
    }
    return [];
  }
  function polygonPolygonIntersect(konvaPolygonA: Shape, konvaPolygonB: Shape) {
    const polygonA = getVerticesFromKonva(konvaPolygonA);
    const polygonB = getVerticesFromKonva(konvaPolygonB);
    // Get the edges of the polygons
    const edgesA = polygonA.length;
    const edgesB = polygonB.length;

    // Check all the edges of polygonA
    for (let i = 0; i < edgesA; i++) {
      const p0 = polygonA[i];
      const p1 = polygonA[(i + 1) % edgesA];
      const normal = getNormal(p0, p1);
      const projA = projectPolygon(normal, polygonA);
      const projB = projectPolygon(normal, polygonB);
      if (!isOverlap(projA, projB)) {
        return false;
      }
    }

    // Check all the edges of polygonB
    for (let i = 0; i < edgesB; i++) {
      const p0 = polygonB[i];
      const p1 = polygonB[(i + 1) % edgesB];
      const normal = getNormal(p0, p1);
      const projA = projectPolygon(normal, polygonA);
      const projB = projectPolygon(normal, polygonB);
      if (!isOverlap(projA, projB)) {
        return false;
      }
    }

    // All projections overlap
    return true;
  }

  function boundingBoxesCollide(draggedShape: Group, otherGroup: Group) {
    // Get the rectangle of the dragged shape
    let draggedRectangle = draggedShape.getClientRect();
    // Get the rectangle of the other group
    let otherRectangle = otherGroup.getClientRect();

    // Check if one rectangle is to the left of the other
    if (draggedRectangle.x + draggedRectangle.width < otherRectangle.x || otherRectangle.x + otherRectangle.width < draggedRectangle.x) {
      return false;
    }

    // Check if one rectangle is above the other
    if (draggedRectangle.y + draggedRectangle.height < otherRectangle.y || otherRectangle.y + otherRectangle.height < draggedRectangle.y) {
      return false;
    }

    // If none of the above conditions are met, the bounding boxes collide
    return true;
  }

  const onShapeMouseOut = () => {
    props.containerRef!.style.cursor = isShapeDragging.value ? 'grabbing' : 'grab';
  };

  const handleShapeDrag = (status: boolean) => {
    isShapeDragging.value = status;
  };

  // const toggleChildListening = (node: { children: any[]; getLayer: () => { (): any; new (): any; drawHit: { (): void; new (): any } } }, status: any) => {
  //   node.children.forEach((child: { listening: (arg0: any) => void }) => {
  //     child.listening(status);
  //   });
  //   node.getLayer().drawHit();
  // };

  const startDrag = (event: Konva.KonvaEventObject<MouseEvent>) => {
    if (Object.keys(nodeStore.nodes).length === 0) return;
    if (isShapeDragging.value) return; // Prevent stage dragging if a shape is being dragged

    isDragging = true;
    props.containerRef!.style.cursor = 'grabbing';
    lastPos = {
      x: event.evt.clientX,
      y: event.evt.clientY,
    };
  };

  const updateStageSize = () => {
    if (props.containerRef) {
      configKonva.width = props.containerRef.offsetWidth;
      configKonva.height = props.containerRef.offsetHeight;
    }
  };

  const centerAndZoomStage = () => {
    if (!stageRef.value || !nodeStore.nodes) return;
    const stage = stageRef.value.getStage();

    // 1. Determine the bounding box of your tree
    let minX = Infinity;
    let minY = Infinity;
    let maxX = -Infinity;
    let maxY = -Infinity;

    for (const node of Object.values(nodeStore.nodes)) {
      minX = Math.min(minX, node.x);
      minY = Math.min(minY, node.y);
      maxX = Math.max(maxX, node.x + nodeStore.nodeWidth);
      maxY = Math.max(maxY, node.y + nodeStore.nodeHeight);
    }

    // 2. Determine the center of the bounding box
    let centerX = (minX + maxX) / 2;
    let centerY = (minY + maxY) / 2;

    // 3. Determine the scaling factor
    const treeWidth = maxX - minX;
    const treeHeight = maxY - minY;
    const scaleX = configKonva.width / treeWidth;
    const scaleY = configKonva.height / treeHeight;
    let scale = Math.min(scaleX, scaleY);
    if (Number.isNaN(centerX)) {
      centerX = 75;
    }
    if (Number.isNaN(centerY)) {
      centerY = 50;
    }

    if (Number.isNaN(scale) || scale > 3) {
      scale = 3;
    }
    // 4. Apply the transformation
    stage.position({ x: -centerX * scale + configKonva.width / 2, y: -centerY * scale + configKonva.height / 2 });
    stage.scale({ x: scale, y: scale });
    stage.draw();
  };

  const handleNodeClick = (nodeId: string) => {
    nodeStore.selectNode(nodeId);
  };

  const generateBezierPathForNode = (node: TreeNode) => {
    if (!node.parentId) return ''; // Return empty if there's no parent

    const parentNode = nodeStore.nodes[node.parentId];
    let start, end, _;

    // Determine the start point based on the parent node's type
    switch (parentNode.type) {
      case NodeType.Select:
      case NodeType.RandomSelector:
        [start, _] = parallelogramStartEndPoints(parentNode, 0.15);
        break;

      case NodeType.Sequence:
        [start, _] = parallelogramStartEndPoints(parentNode, -0.15);
        break;

      case NodeType.Parallel:
      case NodeType.Wait:
        [start, _] = rectangleStartEndPoints(parentNode);
        break;

      case NodeType.Invert:
      case NodeType.Loop:
        [start, _] = triangleStartEndPoints(parentNode);
        break;

      case NodeType.Retry:
      case NodeType.Repeat:
        [start, _] = sideTriangleStartEndPoints(parentNode);
        break;

      case NodeType.Failer:
      case NodeType.Succeeder:
      case NodeType.Condition:
      default:
        [start, _] = ellipseStartEndPoints(parentNode);
        break;
    }

    // Determine the end point based on the current node's type
    switch (node.type) {
      case NodeType.Select:
      case NodeType.RandomSelector:
        [_, end] = parallelogramStartEndPoints(node, 0.15);
        break;

      case NodeType.Sequence:
        [_, end] = parallelogramStartEndPoints(node, -0.15);
        break;

      case NodeType.Parallel:
        [_, end] = rectangleStartEndPoints(node);
        break;

      case NodeType.Invert:
      case NodeType.Loop:
        [_, end] = triangleStartEndPoints(node);
        break;

      case NodeType.Retry:
      case NodeType.Repeat:
        [_, end] = sideTriangleStartEndPoints(node);
        break;

      case NodeType.Failer:
      case NodeType.Succeeder:
      case NodeType.Wait:
      case NodeType.Condition:
      default:
        [_, end] = ellipseStartEndPoints(node);
        break;
    }

    // Generate the SVG path command for the Bezier curve
    const horizontalOffset = 30; // Adjust as needed
    return generateCubicBezierPath(start, end, horizontalOffset);
  };

  function generateCubicBezierPath(start: { x: any; y: any } | undefined, end: { x: any; y: any }, horizontalOffset: number) {
    if(start == null)
      throw "Start can't be null"
    // Calculate the mid-point
    const mid = {
      x: (start.x + end.x) / 2,
      y: (start.y + end.y) / 2,
    };

    // Control points for the first curve
    const cp1 = {
      x: start.x + horizontalOffset,
      y: start.y,
    };
    const cp2 = {
      x: mid.x - horizontalOffset,
      y: start.y,
    };

    // Control points for the second curve
    const cp3 = {
      x: mid.x + horizontalOffset,
      y: end.y,
    };
    const cp4 = {
      x: end.x - horizontalOffset,
      y: end.y,
    };

    return `M ${start.x} ${start.y} C ${cp1.x} ${cp1.y} ${cp2.x} ${cp2.y} ${mid.x} ${mid.y} C ${cp3.x} ${cp3.y} ${cp4.x} ${cp4.y} ${end.x} ${end.y}`;
  }

  function rectangleStartEndPoints(node: TreeNode) {
    const start = { x: node.x + nodeStore.nodeWidth, y: node.y + nodeStore.nodeHeight / 2 };
    const end = { x: node.x, y: node.y + nodeStore.nodeHeight / 2 };
    return [start, end];
  }

  function triangleStartEndPoints(node: TreeNode) {
    const halfWidth = nodeStore.nodeWidth / 2;
    const commonY = node.y + nodeStore.nodeHeight / 2;

    const startXAdjustment = halfWidth * 1.5;
    const endXAdjustment = node.x + halfWidth * 0.5;

    return [
      { x: node.x + startXAdjustment, y: commonY },
      { x: endXAdjustment, y: commonY },
    ];
  }

  function sideTriangleStartEndPoints(node: TreeNode) {
    const commonY = node.y + nodeStore.nodeHeight / 2;

    return [
      { x: node.x + nodeStore.nodeWidth, y: commonY },
      { x: node.x, y: commonY },
    ];
  }

  function parallelogramStartEndPoints(node: TreeNode, sX: number) {
    // Skew adjustment based on the height of the parallelogram and sX
    const skewAdjustment = (nodeStore.nodeHeight * sX) / 2; // Half the adjustment for the midpoint

    // Midpoint on the y-axis
    const commonY = node.y + nodeStore.nodeHeight / 2;

    return [
      { x: node.x + nodeStore.nodeWidth + skewAdjustment, y: commonY }, // Start point on the right edge
      { x: node.x + skewAdjustment, y: commonY }, // End point on the left edge
    ];
  }

  function ellipseStartEndPoints(node: TreeNode) {
    const halfHeight = nodeStore.nodeHeight / 2;

    return [
      { x: node.x + nodeStore.nodeWidth, y: node.y - halfHeight }, // Start point on the right side
      { x: node.x, y: node.y + halfHeight }, // End point on the left side
    ];
  }

  const redrawStage = () => {
    const stage = (stageRef.value as any).getStage() as Konva.Stage;
    stage.draw();
  };

  onMounted(() => {
    nextTick(() => {
      updateStageSize();

      if (stageRef.value) {
        centerAndZoomStage();
      }
      props.containerRef!.addEventListener('wheel', handleWheel);
    });
    window.addEventListener('resize', updateStageSize);
  });
  onBeforeUnmount(() => {
    window.removeEventListener('resize', updateStageSize);
    props.containerRef!.removeEventListener('wheel', handleWheel);
  });

  defineExpose({ centerAndZoomStage, redrawStage });
</script>

<template>
  <v-stage ref="stageRef" :config="configKonva" class="v-stage" @mousedown="startDrag" @mouseleave="endDrag" @mousemove="doDrag" @mouseup="endDrag">
    <v-layer>
      <template v-for="(node, _, __) in nodeStore.nodes" :key="node.id">
        <konva-tree-node
          :node="node"
          :nodeHeight="nodeStore.nodeHeight"
          :nodeWidth="nodeStore.nodeWidth"
          :selected="node.id == nodeStore.selectedNodeId"
          @mouseout="onShapeMouseOut"
          @mouseover="onShapeMouseOver"
          @nodeClick="handleNodeClick"
          @nodeDragEnd="handleNodeDragEnd"
          @update:isShapeDragging="handleShapeDrag" />
        <v-path v-if="node.parentId" :data="generateBezierPathForNode(node)" stroke="gray"></v-path>
      </template>
    </v-layer>
  </v-stage>
</template>

<style scoped>
  .v-stage {
    cursor: grab;
  }
</style>
