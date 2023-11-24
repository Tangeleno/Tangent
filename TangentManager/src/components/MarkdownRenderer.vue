<script setup lang="ts">
import { ref, onMounted } from 'vue';
import MarkdownIt from "markdown-it";
import MarkdownItAbbr from "markdown-it-abbr";
import MarkdownItAnchor from "markdown-it-anchor";
import MarkdownItFootnote from "markdown-it-footnote";
import MarkdownItHighlightjs from "markdown-it-highlightjs";
import MarkdownItSub from "markdown-it-sub";
import MarkdownItSup from "markdown-it-sup";
import MarkdownItTasklists from "markdown-it-task-lists";
const props = defineProps({
  src: String
});

const markdown = new MarkdownIt().use(MarkdownItAbbr)
    .use(MarkdownItAnchor)
    .use(MarkdownItFootnote)
    .use(MarkdownItHighlightjs)
    .use(MarkdownItSub)
    .use(MarkdownItSup)
    .use(MarkdownItTasklists);
const content = ref('');

onMounted(async () => {
  if (props.src) {
    try {
      const response = await fetch(props.src);
      if (response.ok) {
        const mdContent = await response.text();
        content.value = markdown.render(mdContent);
      } else {
        console.error('Failed to fetch markdown content:', response.statusText);
      }
    } catch (error) {
      console.error('Error fetching markdown content:', error);
    }
  }
});
</script>

<template>
    <div class="markdown" v-html="content"></div>
</template>

<style scoped>
</style>
