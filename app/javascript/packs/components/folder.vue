<template>
  <span>
    <div
      class="text-dark dropdown-toggle text-nowrap text-truncate"
      :id="'folder_' + item.values.bookmark_id"
      role="button"
      data-toggle="dropdown"
      aria-haspopup="true"
      aria-expanded="false"
      @mouseover="add_active"
      @mouseleave="remove_active"
    >
      <i class="fa fa-folder-o" aria-hidden="true"></i> {{ item.values.name }}
    </div>
    <div
      v-bind:class="{ is_nest: is_nest }"
      class="dropdown-menu"
      :aria-labelledby="'folder_' + item.values.bookmark_id"
    >
      <div class="bookmark__item" v-for="(child, index) in child_folder_items" v-bind:key="index">
        <url v-if="child.type == 'url'" :item="child"></url>
        <folder v-if="child.type == 'folder'" :item="child" :is_nest='true'></folder>
      </div>
    </div>
  </span>
</template>

<script>
import axios from 'axios';

export default {
  props: {
    item: { type: Object },
    is_nest: { type: Boolean }
  },
  data: function() {
    return {
      child_folder_items: {}
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
    add_active: function(e) {
      $(e.target).parent().children('.is_nest').addClass('is_active')
    },
    remove_active: function(e) {
      $(e.target).parent().children('.is_nest').removeClass('is_active')
    },
  },
}
</script>

<style lang="scss" scoped>
  .dropdown-toggle::after {
    display: none;
  }

  .dropdown-menu {
    padding: 10px 15px;
    font-size: 14px;
    min-width: 320px;
  }

  .dropdown-menu.is_nest {
    // TODO: 幅調整
    left: 320px;
    top: 0;

    &.is_active {
      display: block;
    }
  }
  
  .text-truncate {
    width: 100%;
    max-width: 300px;
    display: inline-block;
    position: relative;
    top: 2px;
  }

  .bookmark__item {
    // padding: 5px 0;
  }
</style>

