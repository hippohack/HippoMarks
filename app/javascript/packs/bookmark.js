import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue'
import Vue from 'vue/dist/vue.esm'
import Router from './router/router'
import axios from 'axios'
import Header from './components/header.vue'
import Bookmarkbar from './components/bookmarkbar.vue'
// import Bookmark from './components/bookmark.vue'
import Folder from './components/folder.vue'

Vue.use(TurbolinksAdapter)

Vue.component('bookmark-link', {
  template: '<a :href="bookmark.url" class="text-dark text-nowrap text-truncate"><i class="fa fa-link" aria-hidden="true"></i> {{ bookmark.name }}</a>',
  props: {
    item: { type: Object }
  },
  data: function() {
    return {
      bookmark: {}
    }
  },
  mounted: function() {
    this.fetch();
  },
  methods: {
    fetch: function() {
      // TODO: リファクタリング → 強引にID当て込んでる
      let id = this.item.item_id ? this.item.item_id : this.item.id
      axios.get(`/api/bookmarks/${id}/`).then(
        response => {
          console.log(response.data)
          this.bookmark = response.data.bookmark
        },
        error => { console.log(error); }
      );
    },
  }
})

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