<template>
  <div>
    <div class="nest-items-lv1" v-for="nest_item in nest_items" v-bind:key="nest_item.id">
      <a v-if="!nest_item.folder_id" :href="nest_item.url" class="text-dark dropdown-item"><i class="fa fa-link" aria-hidden="true"></i> {{ nest_item.name }}</a>
      <div
        @mouseover="add_active"
        @mouseleave="remove_active"
        v-if="nest_item.folder_id"
        class="text-dark dropdown-item"
        :id="'folder_' + nest_item.id">
        <i class="fa fa-folder-o" aria-hidden="true"></i> {{ nest_item.folder_id }}
        <nestitems :items="items" v-if="nest_item.folder_id"></nestitems>
      </div>
    </div>
  </div>
</template>

<script>
  import NestItems from './nestItems.vue'

  var items = [
    { id: 1, name: "hoge", url: "fuga", folder_id: 1 },
    { id: 2, name: "hoge", url: "fuga", folder_id: 0 },
    { id: 3, name: "hoge", url: "fuga", folder_id: 1 },
    { id: 4, name: "hoge", url: "fuga", folder_id: 0 },
  ]

  export default {
    props: {
      nest_items: {
        type: Array
      }
    },
    data: function() {
      return {
        items: items,
        upHere: false
      }
    },
    methods: {
      add_active: function(e) {
        $(e.target).children('.nest-items').addClass('is_active')
      },
      remove_active: function(e) {
        $(e.target).children('.nest-items').removeClass('is_active')
      },
    },
    components: {
      nestitems: NestItems
    }
  }
</script>

<style lang="scss" scoped>
  .nest-items-lv1 {
    position: relative;
  }
</style>
