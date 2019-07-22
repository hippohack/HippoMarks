<template>
  <div class="col bookmarks__col">
    <div class="bookmarks__items" v-if="items">
      <div
        class="bookmarks__item"
        v-for="(item, index) in items"
        v-bind:key="index"
      >
        <a
          class="bookmarks__link"
          href="javascript:void(0)"
          v-if="!item.url"
          @click="$emit('apply', { folder_id: item.id, level: _level+1 })"
        ><i class="fa fa-folder-o mr-2"></i>{{ item.name }}</a>

        <a
          class="bookmarks__link"
          target="_blank"
          :href="item.url"
          v-if="item.url"
        ><i class="fa fa-link mr-2"></i>{{ item.name }}</a>

        <a href="#">edit</a>
      </div>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    data() {
      return {
        fetch_items: [],
        last_request_id: null
      }
    },
    props: {
      _level: { type: Number },
      _folder_id: { type: Number },
    },
    computed: {
      items() {
        this.fetchFolderItems(this._folder_id)
        return this.fetch_items
      }
    },
    methods: {
      fetchFolderItems: function(folder_id) {
        if (this.last_request_id == folder_id) {
          return false
        }
        console.log('[:Request_url]', `/api/folders/${folder_id}`);
        axios.get(`/api/folders/${folder_id}/`).then(
          response => {
            console.log(response.data)
            this.fetch_items = response.data.items[0].concat(response.data.items[1])
          },
          error => { console.log(error); }
        );
        this.last_request_id = folder_id
      },
    }
  }
</script>