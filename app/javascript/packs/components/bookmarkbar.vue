<template>
  <div class="bookmarkbar d-flex">
    <div class="bookmarkbar__item" v-for="(item, index) in bookmarks" v-bind:key="index">
      <a v-if="!item.folder_id" :href="item.url" class="text-dark"><i class="fa fa-link" aria-hidden="true"></i> {{ item.name }}</a>
      <div
        v-if="item.folder_id"
        class="text-dark dropdown-toggle"
        :id="'folder_' + item.id"
        role="button"
        data-toggle="dropdown"
        aria-haspopup="true"
        aria-expanded="false">
        <i class="fa fa-folder-o" aria-hidden="true"></i> {{ item.folder_id }}
      </div>
      <div v-if="item.folder_id" class="dropdown-menu" :aria-labelledby="'folder_' + item.id">
        <bookmark :nest_items="nest_items"></bookmark>
      </div>
    </div>
  </div>
</template>

<script>
  import Bookmark from './bookmark.vue'
  import axios from 'axios';

  var items = [
    { id: 1, name: "hoge", url: "fuga", folder_id: 1 },
    { id: 2, name: "hoge", url: "fuga", folder_id: 0 },
    { id: 3, name: "hoge", url: "fuga", folder_id: 1 },
    { id: 4, name: "hoge", url: "fuga", folder_id: 0 },
  ]
  var nest_items = [
    { id: 12, name: "hoge", url: "fuga", folder_id: 0 },
    { id: 11, name: "hoge", url: "fuga", folder_id: 2 },
    { id: 14, name: "hoge", url: "fuga", folder_id: 0 },
    { id: 13, name: "hoge", url: "fuga", folder_id: 2 },
  ]

  export default {
    data: function() {
      return {
        // items: items,
        nest_items: nest_items,
        bookmarks: {}
      };
    },
    mounted: function() {
      this.fetchBookmarks();
    },
    methods: {
      fetchBookmarks: function() {
        axios.get("/api/bookmarks").then(
          response => {
            console.log(response.data)
            this.bookmarks = response.data.bookmarkbar_items
            // for (var i = 0; i < response.data.bookmarks.length; i++) {
            //   this.bookmarks.push(response.data.bookmarks[i]);
            // }
          },
          error => { console.log(error); }
        );
      }
    },
    components: {
      'bookmark': Bookmark,
    }
  }
</script>

<style lang="scss" scoped>
  .bookmarkbar {
    background-color: #ccc;
    padding: 10px;

    &__item {
      margin: 0 10px;
    }
  }
  .dropdown-toggle::after {
    display: none;
  }
</style>