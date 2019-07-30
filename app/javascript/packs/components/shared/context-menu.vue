<template>
  <div class="content-menu">
    <div class="content-menu__screen" @click="$emit('apply', { flag: false })">
    </div>
    <div class="content-menu__body" @click="no_action" :style="styles">
      <ul>
        <li><a href="">hoge</a></li>
        <li><a href="">hoge</a></li>
        <li><a href="">hoge</a></li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    no_action(e) {
      e.stopPropagation()
    }
  },
  props: {
    _pageX: "",
    _pageY: "",
  },
  computed: {
    styles() {
      return {
        '--pageX': this._pageX + 'px',
        '--pageY': this._pageY + 'px'
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  .content-menu {
    position: relative;
    &__screen {
      background: transparent;
      width: 100%;
      height: 100%;
      position: fixed;
      top: 0;
      left: 0;
      z-index: 100;
    }
    &__body {
      --pageX: 100px;
      --pageY: 100px;

      position: fixed;
      top: var(--pageY);
      left: var(--pageX);
      border: solid 1px #ccc;
      padding: 10px;
      width: 300px;
      height: auto;
      background-color: #222;
      z-index: 101;
      border-radius: 5px
    }
  }
</style>

