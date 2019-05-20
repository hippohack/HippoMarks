<template>
  <div class="bookmarkbar d-flex">
    <div class="bookmarkbar__item" v-for="(item, index) in bar_items" v-bind:key="index">
      <bookmark-link v-if="item.item_type == 'bookmark'" :item="item"></bookmark-link>
      <folder v-if="item.item_type == 'folder'" :item="item"></folder>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    data: function() {
      return {
        // items: items,
        bar_items: [],
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
            this.bar_items = response.data.bookmarkbar_items
            // this.bookmarks = response.data.bookmarkbar_items
            // for (var i = 0; i < response.data.bookmarks.length; i++) {
            //   this.bookmarks.push(response.data.bookmarks[i]);
            // }
          },
          error => { console.log(error); }
        );
      },
      test: function() {
        alert('hoge')
        console.log('hoge')
      }
    },
    components: {
      // 'bookmark': Bookmark,
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
  .text-truncate {
    max-width: 132px;
    display: inline-block;
    position: relative;
    top: 2px;
  }
</style>