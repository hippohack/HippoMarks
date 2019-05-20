<template>
  <div>
    <div class="nest-items-lv1" v-for="item in items" v-bind:key="item.id">
      <a v-if="!item.folder_id" :href="item.url" class="text-dark dropdown-item"><i class="fa fa-link" aria-hidden="true"></i> {{ item.name }}</a>
      <div
        @mouseover="add_active"
        @mouseleave="remove_active"
        v-if="item.folder_id"
        class="text-dark dropdown-item"
        :id="'folder_' + item.id">
        <i class="fa fa-folder-o" aria-hidden="true"></i> {{ item.folder_id }}
        <nest-items :folder_id="item.folder_id" v-if="item.folder_id"></nest-items>
        <!-- 無限ループするので注意 -->
        <!-- <bookmark :folder_id="item.folder_id" v-if="item.folder_id"></bookmark> -->
      </div>
    </div>
  </div>
</template>

<script>
  import NestItems from './nestItems.vue'
  import axios from 'axios';

  export default {
    props: {
      folder_id: {
        type: Number
      }
    },
    data: function() {
      return {
        items: [],
        // items: items,
        upHere: false,
      }
    },
    mounted: function() {
      this.fetchBookmarks();
    },
    methods: {
      fetchBookmarks: function() {
        axios.get(`/api/bookmarks/${this.folder_id}/folder_items`)
        .then(
          response => {
            console.log(response.data)
            this.items = response.data.folder_items
            // for (var i = 0; i < response.data.bookmarks.length; i++) {
            //   this.bookmarks.push(response.data.bookmarks[i]);
            // }
          },
          error => { console.log(error); }
        );
      },
      add_active: function(e) {
        $(e.target).children('.nest-items').addClass('is_active')
      },
      remove_active: function(e) {
        $(e.target).children('.nest-items').removeClass('is_active')
      },
    },
    components: {
      NestItems
    }
  }
</script>

<style lang="scss" scoped>
  .nest-items-lv1 {
    position: relative;
  }
</style>
