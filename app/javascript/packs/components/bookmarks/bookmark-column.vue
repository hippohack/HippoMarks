<template>
  <div class="col bookmarks__col">
    <div class="bookmarks__items" v-if="items">
      <div
        class="bookmarks__item"
        v-for="(item, index) in items"
        v-bind:key="index"
      >
        <bookmark-item-nest
          :_item="item"
          :_level="_level"
          :_folder_id="seleted_folder_id"
          :key="item.id"
          @apply="receive"
        ></bookmark-item-nest>
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
        last_request_id: null,
        seleted_folder_id: null
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
      receive(values) {
        this.seleted_folder_id = values.folder_id
        let found = this.fetch_items.find((elm) => {
          console.log({elm})
          console.log({values})

          return elm.id == values.folder_id && !elm.url
        })
        console.log({found})
        this.$emit('apply', { folder_id: values.folder_id, level: values.level, folder_name: found.name })
        // this.$forceUpdate()
      }
    }
  }
</script>