<template>
  <div class="col bookmarks__col js_column-width">
    <div class="menu-ui d-flex justify-content-end">
      <a
        v-if="typeof _folder_id == 'number'"
        class="menu-ui__add_folder mr-0"
        @click="is_add_folder = true"
        href="javascript:void(0)"
      >
        <i class="fa fa-plus" aria-hidden="true"></i> Add folder
      </a>
      <div v-else style="visibility: hidden;">else</div>
    </div>
    <div
      class="bookmarks__items"
      v-if="items"
      @added="added"
      @removed="removed"
      @reordered="reordered"
      :data-folder-id="_folder_id"
    >
      <!-- add folder // -->
      <div v-if="is_add_folder" class="bookmarks__item">
        <div>
          <a href="javascript:void(0)" class="bookmarks__link">
            <i class="fa fa-folder-o mr-2" style="font-size: 18px;"></i>
            <input
              type="text"
              name="folder[name]"
              v-model="new_folder_name"
              @blur="create_folder"
              @keyup.enter="create_folder"
              placeholder="folder name..."
              class="py-1 px-2"
            >
          </a>
        </div>
      </div>
      <!-- // add folder -->
      <div
        class="bookmarks__item"
        v-for="(item, index) in items"
        v-bind:key="index"
        style="position: relative;"
        :data-id="index"
        :data-item-id="item.id"
        :data-item-type="item.url ? 'bookmarks' : 'folders'"
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
        folder_id: null,
        last_request_id: null,
        seleted_folder_id: null,
        is_add_folder: false,
        new_folder_name: null,
        is_saved: false,
        options: {
          dropzoneSelector: '.bookmarks__items',
          draggableSelector: '.bookmarks__item',
          handlerSelector: null,
          reactivityEnabled: true,
          multipleDropzonesItemsDraggingEnabled: true,
          showDropzoneAreas: true,
          onDrop: function(event) {
            // alert('onDrop')
          },
          onDragstart: function(event) {
            if (this.$root.sort_setting != 'optional') {
              alert('Changing the order is valid only when sort setting is "optional".')
            }
          },
          onDragend: function(event) {
            // alert('onDragend')
          }
        }
      }
    },
    props: {
      _level: { type: Number },
      _folder_id: { type: [String, Number] },
      _home_url: "",
      _show_item_menu: { type: Boolean },
      _show_item_menu_id: { type: Number },
    },
    computed: {
      items() {
        if (this._folder_id != this.folder_id) {
          this.fetchFolderItems(this._folder_id)
          this.folder_id = this._folder_id
        }

        // 増えたカラム分スクロールする
        var column_width = $('.js_column-width').outerWidth()
        document.querySelector('.js_scroll-columns').scrollLeft += column_width;

        return this.fetch_items
      }
    },
    methods: {
      fetchFolderItems(folder_id) {
        axios.get(`/api/folders/${folder_id}/`).then(
          response => {
            console.log('response: ', response.data)
            this.fetch_items = response.data.folder_items
          },
          error => { console.log(error); }
        );
      },
      editBookmark(id) {
        (function () { var a = window, b = document, c = encodeURIComponent, d = a.open(`${_home_url}/bookmarks/${id}/edit?op=edit&output=popup&bkmk=` + c(b.location) + "&title=" + c(b.title), "bkmk_popup", "left=" + ((a.screenX || a.screenLeft) + 700) + ",top=" + ((a.screenY || a.screenTop) + 10) + ",height=710px,width=600px,resizable=1,alwaysRaised=1"); a.setTimeout(function () { d.focus() }, 300) })();
      },
      receive(values) {
        this.seleted_folder_id = values.folder_id
        let found = this.fetch_items.find((elm) => {
          return elm.id == values.folder_id && !elm.url
        })
        this.$emit('apply', { folder_id: values.folder_id, level: values.level-1, folder_name: found.name })
        // this.$forceUpdate()
      },
      relay_bookmark(values) {
        this.$emit('apply_bookmark', { bookmark: values.bookmark })
      },
      create_folder() {
        this.$root.add_folder(this._folder_id, this.new_folder_name);
        this.is_add_folder = false;
        this.new_folder_name = null;

        // folder内データの再フェッチ
        axios.get(`/api/folders/${this._folder_id}/`).then(
          response => {
            this.fetch_items = response.data.folder_items
          },
          error => { console.log(error); }
        );
      },
      async added(e) {
        // alert('added')
        var item = {id: e.detail.items[0].dataset.itemId, type: e.detail.items[0].dataset.itemType}
        var new_folder_id = e.detail.droptarget.dataset.folderId
        var new_sort_num = e.detail.index

        var result = await this.$root.moveFolder(item.type, item.id, new_folder_id, new_sort_num)

        if (result) {
          this.$root.folder_moved = true
          console.log(this.$root.folder_moved)
          this.refresh_folder();
        }
      },
      removed(e) {
        // alert('removed')
        // FIXME: アップデートされる前にとってくるときがある
        if (this.$root.folder_moved) this.refresh_folder();
        this.$root.folder_moved = false
        console.log(this.$root.folder_moved)
      },
      async reordered(e) {
        // alert('reordered')
        var item = this.fetch_items[e.detail.ids[0]]
        var new_sort_num = e.detail.index
        console.log({new_sort_num})

        // ソート番号のアップデート & 再フェッチ
        var type = item.url ? 'bookmarks' : 'folders';
        var result = await this.$root.updateSortNum(type, item.id, new_sort_num)

        if (result) this.refresh_folder();
      },
      refresh_folder() {
        axios.get(`/api/folders/${this._folder_id}/`).then(
          response => {
            // FIXME: なんかいったん空にしないとうまく反映しない。
            this.fetch_items = null;
            this.$nextTick(function () {
              this.fetch_items = response.data.folder_items
            });
          },
          error => { console.log(error); }
        );
      }
    }
  }
</script>