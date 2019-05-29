<template>
  <div
    class="folder is_nest js_mouseover"
  >
    <div
      class="folder__head text-dark text-nowrap text-truncate"
      :id="'folder_' + item.values.bookmark_id"
    >
      <i class="fa fa-folder-o"></i> {{ item.values.name }}
    </div>
    <div
      style="display: none;"
      class="folder__items js_show-item"
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
      is_folder_active: false,
      mouseover_elm: ''
    }
  },
  mounted: function() {
    this.fetch();
    this.init();
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
    },
    init: function() {
      $('.js_mouseover')
        .mouseover(function() {
          // console.log($(this))
          $(this).children('.js_show-item').show()
        })
        .mouseout(function() {
          $(this).children('.js_show-item').hide()
        })
    }
  },
}
</script>

<style lang="scss" scoped>

.folder {
  position: relative;
  &__head {
    font-size: 14px;
    padding: 2px 15px;
  }
  &__items {
    position: absolute;
    width: 300px;
    border: solid 1px #ccc;
    border-radius: 5px;
    z-index: 2000;
    background-color: #fff;
    padding-top: 10px;
    padding-bottom: 10px;
    left: 298px;
    top: -11px;
  }
  &__item {
    font-size: 14px;
  }
}

.text-truncate {
  width: 100%;
  max-width: 300px;
  // padding: 3px 0;
  position: relative;
  top: 2px;
}
</style>

