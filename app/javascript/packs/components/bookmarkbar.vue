<template>
  <div class="bookmarkbar d-flex">
    <div class="bookmarkbar__item" v-for="(item, index) in bar_items" v-bind:key="index">
      <url v-if="item.type == 'url'" :item="item"></url>
      <folder v-if="item.type == 'folder'" :item="item"></folder>
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
          },
          error => { console.log(error); }
        );
      }
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
  .text-truncate {
    max-width: 132px;
    display: inline-block;
    position: relative;
    top: 2px;
  }
</style>