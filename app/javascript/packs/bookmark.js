import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue'
import Vue from 'vue/dist/vue.esm'
import Router from './router/router'
import Header from './components/header.vue'
import Bookmarkbar from './components/bookmarkbar.vue'
// import Bookmark from './components/bookmark.vue'
import Url from './components/url.vue'
import Folder from './components/folder.vue'

Vue.use(TurbolinksAdapter)

Vue.component('url', Url)
Vue.component('folder', Folder)
// Vue.component('bookmark', Bookmark)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    router: Router,
    el: '#app',
    components: {
      'navbar': Header,
      'bookmarkbar': Bookmarkbar,
    }
  })
  // console.log(app)
})