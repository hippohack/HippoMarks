<template>
  <div class="folder dropdown" @click="set_state('open')">
    <div
      v-bind:class="[level == 1 ? 'px-0' : '']"
      class="folder__head text-dark text-nowrap text-truncate dropdown-toggle"
      :id="'folder_' + item.values.bookmark_id"
      role="button"
      data-toggle="dropdown"
      aria-haspopup="true"
      aria-expanded="false"
    >
      <i class="fa fa-folder-o"></i> {{ item.values.name }}
    </div>
    <div
      class="folder__items dropdown-menu"
      :aria-labelledby="'folder_' + item.values.bookmark_id"
    >
      <div class="folder__item" v-for="(child, index) in child_folder_items" v-bind:key="index">
        <url v-if="child.type == 'url'" :item="child"></url>
        <nest-folder v-if="child.type == 'folder'" :item="child"></nest-folder>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  props: {
    item: { type: Object },
    is_nest: { type: Boolean },
    level: ''
  },
  data: function() {
    return {
      child_folder_items: {},
      is_bookmark_bar_active: false,
      is_folder_active: false,
      state: ''
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
    },
    set_state: function(state) {
      this.state = state
    }
  },
}
</script>

<style lang="scss" scoped>

.folder {
  position: relative;
  &__head {
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
  }
}

.text-truncate {
  width: 100%;
  max-width: 300px;
  display: inline-block;
  position: relative;
  top: 2px;
}

.dropdown-toggle::after {
  display: none;
}
</style>

