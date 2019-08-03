<template>
  <div class="content-menu">
    <div class="content-menu__screen" @click="$emit('apply', { flag: false })">
    </div>
    <div class="content-menu__body" @click="no_action" :style="styles">
      <div v-if="_item.url" class="list-group">
        <a class="content-menu__link list-group-item bg-dark text-light d-block" href="">編集</a>
        <a class="content-menu__link list-group-item bg-dark text-light d-block" href="javascript:void(0)" @click="delete_bookmark">ブックマークを削除</a>
      </div>

      <div v-if="!_item.url" class="list-group">
        <a class="content-menu__link list-group-item bg-dark text-light d-block" href="">編集</a>
        <a class="content-menu__link list-group-item bg-dark text-light d-block" href="javascript:void(0)" @click="delete_folder">フォルダを削除</a>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  methods: {
    no_action(e) {
      e.stopPropagation()
    },
    delete_bookmark() {
      axios.delete(`/api/bookmarks/${this._item.id}`)
        .then(function(response) {
          console.log(response)
        })
        .catch(function(error) {
          console.log(error)
        })
    },
    delete_folder() {
      axios.delete(`/api/folders/${this._item.id}`)
        .then(function(response) {
          console.log(response)
        })
        .catch(function(error) {
          console.log(error)
        })
    }
  },
  props: {
    _pageX: "",
    _pageY: "",
    _item: {}
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
      width: 300px;
      height: auto;
      z-index: 101;
      border-radius: 5px;
      box-shadow: 2px 4px 8px -4px #333;
    }
    &__link {
      &:hover {
        text-decoration: none;
      }
    }
  }
</style>

