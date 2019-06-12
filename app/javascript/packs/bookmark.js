import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue'
import Vue from 'vue/dist/vue.esm'
import Router from './router/router'
import Bookmarkbar from './components/bookmarkbar.vue'
import Url from './components/url.vue'
import Folder from './components/folder.vue'
import NestFolder from './components/nest-folder.vue'
import FolderItems from './components/folders/list.vue'

Vue.use(TurbolinksAdapter)

Vue.component('url', Url)
Vue.component('folder', Folder)
Vue.component('nest-folder', NestFolder)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    router: Router,
    el: '#app',
    components: {
      'bookmarkbar': Bookmarkbar,
      'folders': FolderItems
    }
  })
})