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

        <a v-if="item.url" :id="`edit-${item.id}`" href="javascript:void(0)" :data-item-id="item.id" data-item-type="bookmark" @click="editBookmark(item.id)">edit</a>
        <a v-if="!item.url" :id="`edit-${item.id}`" href="javascript:void(0)" :data-item-id="item.id" data-item-type="folder" @click="editFolder(item.id)">edit</a>
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
      editBookmark(id) {
        (function () { var a = window, b = document, c = encodeURIComponent, d = a.open(`http://localhost:3000/bookmarks/${id}/edit?op=edit&output=popup&bkmk=` + c(b.location) + "&title=" + c(b.title), "bkmk_popup", "left=" + ((a.screenX || a.screenLeft) + 700) + ",top=" + ((a.screenY || a.screenTop) + 10) + ",height=510px,width=550px,resizable=1,alwaysRaised=1"); a.setTimeout(function () { d.focus() }, 300) })();
      },
      editFolder() {
        
      },
      receive(values) {
        console.log({values})
        this.columns[values.level] = { folder_id: values.folder_id, level: values.level }
        this.$forceUpdate()
      }
    }
  }
</script>