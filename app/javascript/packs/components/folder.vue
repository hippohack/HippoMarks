<template>
  <span>
    <div
      class="text-dark dropdown-toggle text-nowrap text-truncate"
      :id="'folder_' + item.id"
      role="button"
      data-toggle="dropdown"
      aria-haspopup="true"
      aria-expanded="false">
      <i class="fa fa-folder-o" aria-hidden="true"></i> {{ item.item_id }}
    </div>
    <div class="dropdown-menu" :aria-labelledby="'folder_' + item.id">
      <bookmark-link v-if="item.item_type == 'bookmark'" :item="item"></bookmark-link>
      <folder v-if="item.item_type == 'folder'" :item="item"></folder>
    </div>
  </span>
</template>

<script>
import axios from 'axios';

export default {
  props: {
    item: { type: Object }
  },
  data: function() {
    return {
      current_folder_data: {},
      child_folder_items: {}
    }
  },
  mounted: function() {
    this.fetch();
    this.fetchChild();
  },
  methods: {
    fetch: function() {
      axios.get(`/api/bookmarks/${this.item.item_id}/folder`).then(
        response => {
          console.log(response.data)
          this.current_folder_data = response.data.folder
        },
        error => { console.log(error); }
      );
    },
    fetchChild: function() {
      axios.get(`/api/bookmarks/${this.item.item_id}/folder_items`)
      .then(
        response => {
          console.log(response.data)
          this.child_folder_items = response.data.folder_items
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
}
</script>
