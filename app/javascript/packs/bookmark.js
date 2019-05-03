import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue'
import Vue from 'vue/dist/vue.esm'
import Router from './router/router'
import Header from './components/header.vue'

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    router: Router,
    el: '#app',
    components: {
      'navbar': Header,
    }
  })
  // console.log(app)
})