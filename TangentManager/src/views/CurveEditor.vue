<script lang="ts" setup>
  import { ref } from 'vue';
  import { CurveTypes,ValueLookups } from '@/types/Curve';
  import Dropdown from 'primevue/dropdown';
  import KonvaCurveStage from '@/components/KonvaCurveStage.vue';
  import InputNumber from 'primevue/inputnumber';
  import Panel from 'primevue/panel';
  const curveTypes = ref(Object.keys(CurveTypes));
  const inputs = ref(Object.keys(ValueLookups));
  const bezierControlPoints = ref([3, 4, 5, 6, 8]);
  const containerRef = ref<HTMLDivElement | null>(null);

  const curve = ref({
    type: 'bezier',
  });
  const selectedInput = ref({});

  function curveTypeChanged(newValue) {
    for (var variableKey in curve.value) {
      if (curve.hasOwnProperty(variableKey)) {
        delete curve[variableKey];
      }
    }
    curve.value.type = newValue.value;
  }
  function controlPointsChanged() {
    if (curve.value.type === 'bezier') {
      curve.value.points = [];
      for (let i = 0; i < curve.value.controlPoints; i++) {
        curve.value.points[i] = { x: i, y: -1 + 0.1 * i };
      }
    }
  }
</script>

<template>
  <div class="curve-view-container">
    <div ref="containerRef" class="canvas">
      <KonvaCurveStage v-if="containerRef" :containerRef="containerRef" :curve="curve"></KonvaCurveStage>
    </div>
    <div class="editor">
      <Panel header="Input">
        <Dropdown v-model="selectedInput" placeholder="Select an Input" option :options="inputs"></Dropdown>
      </Panel>
      <Panel header="Curve Parameters">
        <Dropdown v-model="curve.type" :options="curveTypes" placeholder="Select a Curve Type" @change="curveTypeChanged" option></Dropdown>
        <template v-if="curve.type === 'bezier'">
          <div>
            <Dropdown
              id="input-controlPoints"
              v-model="curve.controlPoints"
              placeholder="Control Points"
              @change="controlPointsChanged"
              :options="bezierControlPoints"
              option></Dropdown>
          </div>
        </template>
        <template v-else v-if="curve.type != null" v-for="(description, parameter) in CurveTypes[curve.type].parameters">
          <span class="p-float-label mt-6">
            <InputNumber :v-tooltip.top="description" :maxFractionDigits="5" :step="0.001" :id="`input-${parameter}`" class="ml-1 mr-1" v-model="curve[parameter]" />
            <label class="pl-2" :for="`input-${parameter}`">{{ parameter }}</label>
          </span>
        </template>
      </Panel>
    </div>
  </div>
</template>

<style scoped>
  .curve-view-container {
    display: grid;
    grid-template-areas: 'canvas editor';
    grid-template-columns: minmax(0, 1fr) auto; /* Adjust the width as needed */
    height: 100%;
  }
  .canvas {
    background-color: var(--surface-card);
    grid-area: canvas;
  }

  .editor {
    padding: 1em;
    grid-area: editor;
    z-index: 100;
    background-color: var(--surface-section); /* Adjust for desired transparency */
    backdrop-filter: blur(0.5em);
    overflow: auto;
  }
</style>
