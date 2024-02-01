<script lang="ts" setup>
  import { nextTick, onBeforeUnmount, onMounted, PropType, reactive, ref, watch } from 'vue';
  import Konva from 'konva';
  import { Curve } from '@/types/Curve';
  const configKonva = reactive({
    width: 200, // default values, will be updated
    height: 200, // default values, will be updated
    padding: 30,
    adjustedWidth: 180,
    adjustedHeight: 180,
  });
  const stageRef = ref<Konva.Stage | null>(null);
  const minXRange = 0;
  const maxXRange = 100;
  const props = defineProps({
    containerRef: {
      type: Object as PropType<HTMLDivElement>,
      required: true,
    },
    curve: {
      type: Object,
      required: true,
    },
  });
  const coordinatesTextRef = ref<Konva.Text | null>(null);

  watch(
    () => props.curve,
    () => {
      RenderCanvas(false); // Call the DrawCurve function when props.curve changes
    },
    { deep: true }
  ); // Use deep: true to watch for changes in nested properties of props.curve

  function ConvertGraphPointsToStage(points) {
    // Assuming your x-axis ranges from minXRange to maxXRange
    // and your y-axis ranges from -1 to 1
    const convertedPoints = [] as number[];
    for (const key in points) {
      const point = points[key];
      const canvasX = configKonva.padding + ((point.x - minXRange) / (maxXRange - minXRange)) * (configKonva.width - 2 * configKonva.padding);

      // Map the y value from graph range to canvas range.
      // Invert the y value since the canvas y=0 is at the top
      const canvasY = configKonva.padding + ((1 - point.y) / 2) * (configKonva.height - 2 * configKonva.padding);

      convertedPoints.push(canvasX);
      convertedPoints.push(canvasY);
    }
    return convertedPoints;
  }

  function GenerateCurvePoints() {
    switch (props.curve.type) {
      case 'linear':
        return Curve.GenerateLinearCurvePoints(minXRange, maxXRange, props.curve);
      case 'step':
        return Curve.GenerateStepCurvePoints(minXRange, maxXRange, props.curve);
      case 'logarithmic':
        return Curve.GenerateLogarithmicCurvePoints(minXRange, maxXRange, props.curve);
      case 'exponential':
        return Curve.GenerateExponentialCurvePoints(minXRange, maxXRange, props.curve);
      case 'quadratic':
        return Curve.GenerateQuadraticCurvePoints(minXRange, maxXRange, props.curve);
      case 'gaussian':
        return Curve.GenerateGaussianCurvePoints(minXRange, maxXRange, props.curve);
      case 'tanh':
        return Curve.GenerateTanhCurvePoints(minXRange, maxXRange);
      case 'cosine':
        return Curve.GenerateCosineCurvePoints(minXRange, maxXRange, props.curve);
      case 'sine':
        return Curve.GenerateSineCurvePoints(minXRange, maxXRange, props.curve);
      case 'logistic':
        return Curve.GenerateLogisticCurvePoints(minXRange, maxXRange, props.curve);
      case 'smoothstep':
        return Curve.GenerateSmoothstepCurvePoints(minXRange, maxXRange, props.curve);
      case 'cubic':
        return Curve.GenerateCubicCurvePoints(minXRange, maxXRange, props.curve);
      case 'lerp':
        return Curve.GenerateLinearInterpolationPoints(minXRange, maxXRange, props.curve);
      case 'bezier':
        return Curve.GenerateBezierCurvePoints(minXRange, maxXRange, props.curve);
    }
  }

  function ConvertStageToGraphPoints(stageX, stageY) {
    const graphX = ((stageX - configKonva.padding) / configKonva.adjustedWidth) * (maxXRange - minXRange) + minXRange;
    const graphY = 2 * (1 - (stageY - configKonva.padding) / configKonva.adjustedHeight) - 1;

    return { x: graphX, y: graphY };
  }

  function RenderCanvas(redrawGrid: boolean = false) {
    const stage = stageRef.value?.getStage();
    if (!stage) {
      return;
    }
    const layers = stage.getLayers();
    // Clear existing layers
    if (redrawGrid) {
      const gridLayer = layers[0];
      if (gridLayer == null) return;
      gridLayer.removeChildren();
      RegenerateGraph(gridLayer);
    }
    const curveLayer = layers[1];
    const pointsLayer = layers[2];
    const textLayer = layers[3];
    if (curveLayer == null || pointsLayer == null || textLayer == null) {
      return;
    }
    curveLayer.removeChildren();
    pointsLayer.removeChildren();
    textLayer.removeChildren();
    DrawCurve(curveLayer, textLayer);
    DrawPoints(pointsLayer);
    curveLayer.draw();
    const xx = 123;
    console.log(xx);
  }

  function DrawCurve(curveLayer: Konva.Layer, textLayer: Konva.Layer) {
    const points = GenerateCurvePoints();
    if (points?.length < 2) return;
    const drawPoints = ConvertGraphPointsToStage(points);

    const curve = new Konva.Line({
      points: drawPoints,
      stroke: 'red',
      strokeWidth: 5,
      lineCap: 'round',
      lineJoin: 'round',
      tension: 0,
    });

    if (!coordinatesTextRef.value) {
      coordinatesTextRef.value = new Konva.Text({
        x: 0,
        y: 0,
        text: '',
        fontSize: 12,
        fill: 'white',
        visible: false,
      });
    }
    textLayer.add(coordinatesTextRef.value);
    curve.on('mousemove', (event) => {
      const mousePos = event.target.getStage().getPointerPosition();
      if (mousePos) {
        const graphCoords = ConvertStageToGraphPoints(mousePos.x, mousePos.y);
        coordinatesTextRef.value.text(`input: ${graphCoords.x.toFixed(0)}, output: ${graphCoords.y.toFixed(2)}`);
        coordinatesTextRef.value.position({ x: mousePos.x + 15, y: mousePos.y + 10 });
        coordinatesTextRef.value.show();
        textLayer.draw();
      }
    });

    curve.on('mouseout', () => {
      if (coordinatesTextRef.value) {
        coordinatesTextRef.value.hide();
        textLayer.draw();
      }
    });

    curveLayer.add(curve);
  }

  function DrawPoints(layer: Konva.Layer) {
    if ((props.curve.type != 'lerp' && props.curve.type != 'bezier') || props.curve.points == null) return;
    props.curve.points.forEach((point, index) => {
      const stagePoints = ConvertGraphPointsToStage([point]);

      const circle = new Konva.Circle({
        x: stagePoints[0],
        y: stagePoints[1],
        radius: 10,
        fill: 'blue',
        stroke: 'black',
        strokeWidth: 1,
        draggable: true,
      });
      if (props.curve.type === 'bezier') {
        circle.on('dragend', (e) => {
          // Update the point's position in props.curve.points
          const newPos = ConvertStageToGraphPoints(e.target.x(), e.target.y());
          props.curve.points[index] = { x: newPos.x, y: newPos.y };
          RenderCanvas(); // Re-render the canvas to reflect the updated points
        });
      }
      layer.add(circle);
    });
  }

  const updateStageSize = () => {
    if (props.containerRef) {
      configKonva.width = props.containerRef.offsetWidth;
      configKonva.height = props.containerRef.offsetHeight;
      configKonva.adjustedWidth = configKonva.width - 2 * configKonva.padding;
      configKonva.adjustedHeight = configKonva.height - 2 * configKonva.padding;
      RenderCanvas(true);
    }
  };

  function RegenerateGraph(layer: Konva.Layer) {
    // Clear the existing layer
    if (layer == null) {
      return;
    }

    // Determine the total range and precision for labels
    const totalXRange = maxXRange - minXRange;
    const labelPrecision = totalXRange < 100 ? 1 : 0;
    // Step values
    const xStep = totalXRange / (totalXRange <= 20 ? 10 : 20); // 10 segments on each side of 0
    const yStep = 0.1; // Y-axis step

    // Draw horizontal grid lines and add labels to the y-axis
    for (let y = -1; y <= 1; y += yStep) {
      const scaledY = configKonva.padding + ((1 - y) / 2) * configKonva.adjustedHeight;

      // Grid Line
      const line = new Konva.Line({
        points: [configKonva.padding, scaledY, configKonva.width - configKonva.padding, scaledY],
        stroke: 'rgba(255, 255, 255, 0.2)',
        strokeWidth: 1,
      });
      layer.add(line);
      let labelText = y.toFixed(1);
      labelText = labelText === '-0.0' ? '0.0' : labelText; // Convert "-0" to "0"
      // Label
      const label = new Konva.Text({
        x: configKonva.padding / 4 - 5,
        y: scaledY - 5,
        text: labelText,
        fontSize: 12,
        fill: 'lightgray',
      });
      layer.add(label);
    }

    // Draw vertical grid lines (X-axis)
    for (let x = minXRange; x <= maxXRange; x += xStep) {
      const scaledX = configKonva.padding + ((x - minXRange) / (maxXRange - minXRange)) * configKonva.adjustedWidth;

      // Grid Line
      const line = new Konva.Line({
        points: [scaledX, configKonva.padding, scaledX, configKonva.height - configKonva.padding],
        stroke: 'rgba(255, 255, 255, 0.2)',
        strokeWidth: 1,
      });
      layer.add(line);
      // Label
      let labelText = x.toFixed(labelPrecision);
      labelText = labelText === '-0' || labelText === '-0.0' ? '0' : labelText; // Convert "-0" to "0"
      const label = new Konva.Text({
        x: scaledX - 10,
        y: configKonva.height - configKonva.padding + 5,
        text: labelText,
        fontSize: 12,
        fill: 'lightgray',
      });
      layer.add(label);
    }
  }
  function handleStageClick(event) {
    const stage = stageRef.value?.getStage();
    if (!stage) {
      return;
    }

    const mousePos = stage.getPointerPosition();
    if (!mousePos) {
      return;
    }

    const graphCoords = ConvertStageToGraphPoints(mousePos.x, mousePos.y);

    if (event.evt.ctrlKey && props.curve.type === 'lerp') {
      //if we have any points we need to check if we should remove one
      let pointIndex = -1;
      if (props.curve.points?.length) {
        const threshold = 5; // Threshold for considering a point to be clicked (in pixels)
        pointIndex = props.curve.points.findIndex((p) => {
          const stagePoints = ConvertGraphPointsToStage([p]);
          const distance = Math.sqrt(Math.pow(stagePoints[0] - mousePos.x, 2) + Math.pow(stagePoints[1] - mousePos.y, 2));
          return distance < threshold;
        });
      }
      // Find and remove the point if it's close to the click position

      if (pointIndex !== -1) {
        props.curve.points.splice(pointIndex, 1);
      } else {
        //We aren't removing a point, so we must be adding a new one
        addPointToCurve(graphCoords);
      }
    }

    RenderCanvas();
  }

  //   function handleStageClick(event) {
  //     if (event.evt.ctrlKey && props.curve.type === 'lerp') {
  //       const stage = stageRef.value?.getStage();
  //       if (stage) {
  //         const mousePos = stage.getPointerPosition();
  //         if (mousePos) {
  //           const graphCoords = ConvertStageToGraphPoints(mousePos.x, mousePos.y);
  //           addPointToCurve(graphCoords);
  //           RenderCanvas();
  //         }
  //       }
  //     }
  //   }

  function addPointToCurve(graphCoords) {
    if (!props.curve.points) {
      props.curve.points = [];
    }

    // Find the index where the new point should be inserted
    let insertIndex = props.curve.points.findIndex((point) => graphCoords.x < point.x);
    if (insertIndex === -1) {
      // If no such index, push to the end of the array
      props.curve.points.push({ x: graphCoords.x, y: graphCoords.y });
    } else {
      // Insert at the found index
      props.curve.points.splice(insertIndex, 0, { x: graphCoords.x, y: graphCoords.y });
    }
  }

  onMounted(() => {
    nextTick(() => {
      updateStageSize();
      const stage = stageRef.value?.getStage();
      if (stage) {
        stage.on('click', handleStageClick);
        RenderCanvas(true);
      }
    });
    window.addEventListener('resize', updateStageSize);
  });
  onBeforeUnmount(() => {
    window.removeEventListener('resize', updateStageSize);
  });
</script>

<template>
  <v-stage ref="stageRef" :config="configKonva" class="v-stage">
    <v-layer></v-layer>
    <v-layer></v-layer>
    <v-layer></v-layer>
    <v-layer></v-layer>
  </v-stage>
</template>

<style scoped></style>
