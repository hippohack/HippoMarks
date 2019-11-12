import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue'
import Vue from 'vue/dist/vue.esm'
import VueDraggable from 'vue-draggable'
// import Router from './router/router'
import BookmarkLayout from './components/bookmarks/bookmark-layout.vue'
import BookmarkColumns from './components/bookmarks/bookmark-columns.vue'
import BookmarkColumn from './components/bookmarks/bookmark-column.vue'
import BookmarkItem from './components/bookmarks/bookmark-item.vue'
import BookmarkItemNest from './components/bookmarks/bookmark-item--nest.vue'
import Folders from './components/folders/folders.vue'
import Folder from './components/folders/folder.vue'
import ContextMenu from './components/shared/context-menu.vue'
import ItemMenu from './components/shared/item-menu.vue'

import axios from 'axios';

Vue.use(TurbolinksAdapter)
Vue.use(VueDraggable)

Vue.component('bookmark-columns', BookmarkColumns)
Vue.component('bookmark-column', BookmarkColumn)
Vue.component('bookmark-item', BookmarkItem)
Vue.component('bookmark-item-nest', BookmarkItemNest)
Vue.component('folders', Folders)
Vue.component('folder', Folder)
Vue.component('context-menu', ContextMenu)
Vue.component('item-menu', ItemMenu)

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
        file: '',
        show_item_menu: false,
        show_item_menu_id: null,
        pageX: null,
        pageY: null,
        sort_setting: null,
        folder_moved: false,
        delete_histories: [],
        check_all: false
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
      },
      add_folder(folder_id, parent_count, name) {
        axios.post(`/api/folders/`, {
            folder_id: folder_id,
            parent_count: parent_count,
            name: name
          })
          .then(response => {
            console.log({response})
          })
          .catch(error => {
            console.log({error})
          });
      },
      showItemMenu(target_item_id) {
        this.show_item_menu = true
        this.show_item_menu_id = target_item_id
        this.pageX = event.pageX
        this.pageY = event.pageY
      },
      hideItemMenu() {
        this.show_item_menu = false
        this.pageX = null
        this.pageY = null
      },
      updateSortNum(type, item_id, newSortNum) {
        return axios.patch(`/api/${type}/${item_id}/update_sort_num`, {'sort_num': newSortNum})
      },
      moveFolder(type, item_id, newFolderId, newSortNum) {
        return axios.patch(`/api/${type}/${item_id}/move_folder`, {'folder_id': newFolderId, 'sort_num': newSortNum})
      },
      cancel_history_delete() {
        this.delete_histories = []
      },
      submit_delete_histories_form() {
        var res = confirm('Are you sure?')
        if (res) {
          document.querySelector('#delete-histories-form').submit();
        }
      },
    },
    watch: {
      check_all(val, oldVal) {
        this.delete_histories = []
        var elms = document.querySelectorAll('.check_history_delete_item')
        if (val) {
          // FIXME: とりまハードコーディング
          for(var i = 0; i < elms.length; i++) {
            elms[i].checked = 'checked';
            this.delete_histories.push(elms[i].value)
          }
        } else {
          for(var i = 0; i < elms.length; i++) {
            elms[i].checked = null;
          }
          this.delete_histories = []
        }
      }
    }
  })
})