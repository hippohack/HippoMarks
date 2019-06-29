import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue'
import Vue from 'vue/dist/vue.esm'
// import Router from './router/router'
import BookmarkLayout from './components/bookmarks/bookmark-layout.vue'
import BookmarkColumns from './components/bookmarks/bookmark-columns.vue'
import BookmarkColumn from './components/bookmarks/bookmark-column.vue'
import Folders from './components/folders/folders.vue'
import Folder from './components/folders/folder.vue'

Vue.use(TurbolinksAdapter)

Vue.component('bookmark-columns', BookmarkColumns)
Vue.component('bookmark-column', BookmarkColumn)
Vue.component('folders', Folders)
Vue.component('folder', Folder)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    // router: Router,
    el: '#app',
    components: {
      'bookmark-layout': BookmarkLayout,
    }
  })
})