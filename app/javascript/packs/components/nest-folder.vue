<template>
  <div
    class="folder is_nest"
    @mouseover="folder_open"
    @mouseleave="folder_open"
  >
    <div
      class="folder__head text-dark text-nowrap text-truncate"
      :id="'folder_' + item.values.bookmark_id"
    >
      <i class="fa fa-folder-o"></i> {{ item.values.name }}
    </div>
    <div
      v-if="is_folder_active == true"
      class="folder__items"
      :data-folder-id="'folder_' + item.values.bookmark_id"
    >
      <div class="folder__item" v-for="(child, index) in child_folder_items" v-bind:key="index">
        <url v-if="child.type == 'url'" :item="child"></url>
        <folder v-if="child.type == 'folder'" :item="child" :is_nest='true'></folder>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  props: {
    item: { type: Object },
  },
  data: function() {
    return {
      child_folder_items: {},
      is_bookmark_bar_active: false,
      is_folder_active: false
    }
  },
  mounted: function() {
    this.fetch();
  },
  methods: {
    fetch: function() {
      axios.get(`/api/bookmarks/${this.item.values.bookmark_id}/folder`).then(
        response => {
          // console.log({response})
          this.child_folder_items = response.data.folder_items
        },
        error => { console.log(error); }
      );
    },
    folder_open: function(e) {
      this.is_folder_active = !this.is_folder_active
    }
  },
}
</script>

<style lang="scss" scoped>

.folder {
  position: relative;
  &__head {
    font-size: 14px;
  }
  &__items {
    position: absolute;
    width: 320px;
    border: solid 1px #ccc;
    border-radius: 5px;
    z-index: 2000;
    background-color: #fff;
    padding-top: 10px;
    padding-bottom: 10px;
    left: 303px;
    top: -13px;
  }
  &__item {
    padding: 2px 15px;
    font-size: 14px;
  }
}

.text-truncate {
  width: 100%;
  max-width: 300px;
  padding: 3px 0;
  position: relative;
  top: 2px;
}
</style>

