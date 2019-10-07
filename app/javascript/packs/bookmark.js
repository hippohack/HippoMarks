import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue'
import Vue from 'vue/dist/vue.esm'
// import Router from './router/router'
import BookmarkLayout from './components/bookmarks/bookmark-layout.vue'
import BookmarkColumns from './components/bookmarks/bookmark-columns.vue'
import BookmarkColumn from './components/bookmarks/bookmark-column.vue'
import BookmarkItem from './components/bookmarks/bookmark-item.vue'
import BookmarkItemNest from './components/bookmarks/bookmark-item--nest.vue'
import Folders from './components/folders/folders.vue'
import Folder from './components/folders/folder.vue'
import ContextMenu from './components/shared/context-menu.vue'

import axios from 'axios';

Vue.use(TurbolinksAdapter)

Vue.component('bookmark-columns', BookmarkColumns)
Vue.component('bookmark-column', BookmarkColumn)
Vue.component('bookmark-item', BookmarkItem)
Vue.component('bookmark-item-nest', BookmarkItemNest)
Vue.component('folders', Folders)
Vue.component('folder', Folder)
Vue.component('context-menu', ContextMenu)

// FIXME: DOM表示しない問題があるためDOMContentLoadedに変更してる
document.addEventListener('DOMContentLoaded', () => {
// document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    // router: Router,
    el: '#app',
    components: {
      'bookmark-layout': BookmarkLayout,
    },
    data() {
      return {
        is_new_folder: false,
        new_folder_parent_id: "",
        isActiveAvatorEdit: false,
        file: ''
      }
    },
    methods: {
      show_new_folder() {
        this.new_folder_parent_id = $("input[name='bookmark[folder_id]']:checked").val()
        if (!this.new_folder_parent_id) {
          this.new_folder_parent_id = $("input[name='top_folder']").val()
        }
        this.is_new_folder = true
      },
      submit() {
        $('form').submit();
      },
      submitAvatar() {
        $('.avator-form__submit').click();
        $('button.close').click();
      },
      fileSelect() {
        $('#profile_avatar').click();
      },
      siteImageSelect() {
        $('#site-image-select').click();
      },
      submitSiteImageEdit() {
        $('.site-image-form__submit').click();
      }
    }
  })
})