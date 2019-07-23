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

Vue.use(TurbolinksAdapter)

Vue.component('bookmark-columns', BookmarkColumns)
Vue.component('bookmark-column', BookmarkColumn)
Vue.component('bookmark-item', BookmarkItem)
Vue.component('bookmark-item-nest', BookmarkItemNest)
Vue.component('folders', Folders)
Vue.component('folder', Folder)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    // router: Router,
    el: '#app',
    components: {
      'bookmark-layout': BookmarkLayout,
    },
    data() {
      return {
        is_new_folder: false,
        new_folder_parent_id: ""
      }
    },
    methods: {
      show_new_folder() {
        console.log($("input[name='bookmark[folder_id]']:checked").val())
        this.new_folder_parent_id = $("input[name='bookmark[folder_id]']:checked").val()
        this.is_new_folder = true
      }
    }
  })
})