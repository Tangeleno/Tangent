import Konva from 'konva';
/// <reference path="../../../node_modules/konva/lib/index-types.d.ts" />
document.querySelectorAll('.menu-item').forEach((item) => {
  item.addEventListener('mouseleave', function () {
    this.setAttribute('data-open', 'false');
  });
});
document.querySelectorAll('.menu-item').forEach((item) => {
  item.addEventListener('click', function () {
    const isOpen = this.getAttribute('data-open');
    if (isOpen === 'true') {
      this.setAttribute('data-open', 'false');
    } else {
      this.setAttribute('data-open', 'true');
    }
  });
});
document.querySelector('.theme-toggle').addEventListener('click', function () {
  const currentTheme = document.documentElement.getAttribute('data-theme');
  if (currentTheme === 'dark') {
    document.documentElement.setAttribute('data-theme', 'light');
  } else {
    document.documentElement.setAttribute('data-theme', 'dark');
  }
});
let stage = new Konva.Stage({
    container:'canvas-container',
    width:500,
    height:500
});
