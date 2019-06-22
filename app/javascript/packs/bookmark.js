import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue'
import Vue from 'vue/dist/vue.esm'
// import Router from './router/router'
import BookmarkLayout from './components/bookmarks/bookmark-layout.vue'
import BookmarkColumns from './components/bookmarks/bookmark-columns.vue'
import BookmarkColumn from './components/bookmarks/bookmark-column.vue'
import FolderItems from './components/folders/list.vue'
import Url from './components/url.vue'
import Folder from './components/folder.vue'
import NestFolder from './components/nest-folder.vue'

Vue.use(TurbolinksAdapter)

Vue.component('url', Url)
Vue.component('folder', Folder)
Vue.component('nest-folder', NestFolder)
Vue.component('bookmark-columns', BookmarkColumns)
Vue.component('bookmark-column', BookmarkColumn)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    // router: Router,
    el: '#app',
    components: {
      'bookmark-layout': BookmarkLayout,
      'folders': FolderItems
    }
  })
})