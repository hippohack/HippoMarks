import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
import Index from '../components/index.vue'
import About from '../components/about.vue'
import Contact from '../components/contact.vue'

Vue.use(VueRouter)

export default new VueRouter({
  mode: 'history',
  routes: [
    { path: '/', component: Index },
    { path: '/about', component: About },
    { path: '/contact', component: Contact },
  ],
})

// HTML5 History モード | Vue Router
// https://router.vuejs.org/ja/guide/essentials/history-mode.html