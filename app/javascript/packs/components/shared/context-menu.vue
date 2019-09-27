<template>
  <div class="content-menu">
    <div class="content-menu__screen" @click="$emit('apply', { flag: false })">
    </div>
    <div class="content-menu__body" @click="no_action" :style="styles">
      <div v-if="_item.url" class="list-group">
        <a class="content-menu__link list-group-item bg-dark text-light d-block" href="javascript:void(0)" @click="edit_bookmark">編集</a>
        <a class="content-menu__link list-group-item bg-dark text-light d-block" href="javascript:void(0)" @click="delete_bookmark">ブックマークを削除</a>
      </div>

      <div v-if="!_item.url" class="list-group">
        <a
          class="content-menu__link list-group-item bg-dark text-light d-block"
          href="javascript:void(0)"
          @click="$emit('folder_edit', { folder_editing: true })"
        >編集</a>
        <a class="content-menu__link list-group-item bg-dark text-light d-block" href="#">フォルダを作成</a>
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
        .then((response) => {
          console.log(response)
          this.$emit('delete_folder', { delete_folder: this._item.id })
        })
        .catch(function(error) {
          console.log(error)
        })
    },
    edit_bookmark() {
      // TODO: url調整
      let a = window
      let b = document
      let c = encodeURIComponent
      let d = a.open(`${this._home_url}/bookmarks/${this._item.id}/popup_edit?op=edit&output=popup&bkmk=` + c(b.location) + "&title=" + c(b.title), "bkmk_popup", "left=" + ((a.screenX || a.screenLeft) + 700) + ",top=" + ((a.screenY || a.screenTop) + 10) + ",height=710px,width=600px,resizable=1,alwaysRaised=1")

      a.setTimeout(function () { d.focus() }, 300)
    }
  },
  props: {
    _pageX: "",
    _pageY: "",
    _item: {},
    _home_url: ""
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

