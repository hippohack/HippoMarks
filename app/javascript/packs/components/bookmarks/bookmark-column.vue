<template>
  <div class="col bookmarks__col">
    <div class="menu-ui d-flex justify-content-end">
      <a class="menu-ui__add_folder mr-0" @click="is_add_folder = true" href="javascript:void(0)"><i class="fa fa-plus" aria-hidden="true"></i> Add folder</a>
    </div>
    <div class="bookmarks__items" v-if="items">
      <div v-if="is_add_folder" class="bookmarks__item">
        <div>
          <a href="javascript:void(0)" class="bookmarks__link">
            <i class="fa fa-folder-o mr-2" style="font-size: 18px;"></i>
            <input type="text"
                   name="folder[name]"
                   v-model="new_folder_name"
                   @blur="create_folder"
                   @keyup.enter="create_folder"
                   placeholder="folder name..."
                   class="py-1 px-2">
          </a>
        </div>
      </div>
      <div
        class="bookmarks__item"
        v-for="(item, index) in items"
        v-bind:key="index"
        style="position: relative;"
      >
        <bookmark-item-nest
          :_item="item"
          :_level="_level"
          :_folder_id="seleted_folder_id"
          :key="item.id"
          :_home_url="_home_url"
          :_show_item_menu="_show_item_menu"
          :_show_item_menu_id="_show_item_menu_id"
          @apply="receive"
          @apply_bookmark="relay_bookmark"
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
        seleted_folder_id: null,
        is_add_folder: false,
        new_folder_name: null,
        is_saved: false,
      }
    },
    props: {
      _level: { type: Number },
      _folder_id: "",
      _home_url: "",
      _show_item_menu: { type: Boolean },
      _show_item_menu_id: { type: Number }
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
        axios.get(`/api/folders/${folder_id}/`).then(
          response => {
            this.fetch_items = response.data.items[0].concat(response.data.items[1])
          },
          error => { console.log(error); }
        );
        this.last_request_id = folder_id
      },
      editBookmark(id) {
        (function () { var a = window, b = document, c = encodeURIComponent, d = a.open(`${_home_url}/bookmarks/${id}/edit?op=edit&output=popup&bkmk=` + c(b.location) + "&title=" + c(b.title), "bkmk_popup", "left=" + ((a.screenX || a.screenLeft) + 700) + ",top=" + ((a.screenY || a.screenTop) + 10) + ",height=710px,width=600px,resizable=1,alwaysRaised=1"); a.setTimeout(function () { d.focus() }, 300) })();
      },
      receive(values) {
        this.seleted_folder_id = values.folder_id
        let found = this.fetch_items.find((elm) => {
          return elm.id == values.folder_id && !elm.url
        })
        this.$emit('apply', { folder_id: values.folder_id, level: values.level, folder_name: found.name })
        // this.$forceUpdate()
      },
      relay_bookmark(values) {
        this.$emit('apply_bookmark', { bookmark: values.bookmark })
      },
      create_folder() {
        this.$root.add_folder(this._folder_id, this._level, this.new_folder_name);
        this.is_add_folder = false;

        // folder内データの再フェッチ
        axios.get(`/api/folders/${this._folder_id}/`).then(
          response => {
            this.fetch_items = response.data.items[0].concat(response.data.items[1])
          },
          error => { console.log(error); }
        );
      },
    }
  }
</script>