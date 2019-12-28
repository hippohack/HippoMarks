<template>
  <div class="row flex-xl-nowrap" v-drag-and-drop:options="options">
    <div class="col-2 bookmarks__col bookmarks__col--first">
      <div class="menu-ui d-flex justify-content-end">
        <a class="menu-ui__add_folder mr-0" @click="is_add_folder = true" href="javascript:void(0)"><i class="fa fa-plus" aria-hidden="true"></i> Add folder</a>
      </div>
      <div
        class="bookmarks__items"
        @added="added"
        @removed="removed"
        @reordered="reordered"
        :data-folder-id="_top_folder.id"
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
        <div class="bookmarks__item" v-if="show_many_visits == 'true'">
          <div :class="manyVisitsActive">
            <a
              class="bookmarks__link"
              href="javascript:void(0)"
              @click="openManyVisitsFolder()"
            ><i class="fa fa-star mr-2" style="font-size: 18px;" aria-hidden="true"></i>Many visits</a>
          </div>
        </div>
        <div class="bookmarks__item" v-if="show_history == 'true'">
          <div :class="historyActive">
            <a
              class="bookmarks__link"
              href="javascript:void(0)"
              @click="openHistoryFolder()"
            ><i class="fa fa-history mr-2" style="font-size: 18px;"></i>History</a>
          </div>
        </div>
        <div
          class="bookmarks__item"
          v-for="(item, index) in items"
          v-bind:key="index"
          style="position: relative;"
          :data-id="index"
          :data-item-id="item.id"
          :data-item-type="item.url ? 'bookmarks' : 'folders'"
        >
          <bookmark-item
            :_item="item"
            :_folder_id="clicked_folder_id"
            :_home_url="_home_url"
            :_show_item_menu="_show_item_menu"
            :_show_item_menu_id="_show_item_menu_id"
            :_level="0"
            @apply="receive"
            @apply_bookmark="catch_bookmark"
          ></bookmark-item>
        </div>
      </div>
    </div>

    <div class="col" style="overflow: auto;">
      <div class="row">
        <div class="col js_scroll-columns" style="overflow: auto;">
          <!-- ２つ目からのカラム郡 -->
          <bookmark-columns
            v-if="is_active"
            :_clicked_folder_id="clicked_folder_id"
            :_home_url="_home_url"
            :_show_item_menu="_show_item_menu"
            :_show_item_menu_id="_show_item_menu_id"
            @apply_bookmark="catch_bookmark"
          ></bookmark-columns>
        </div>

        <div class="col-4 bookmarks__col bookmarks__col--last">
          <div v-if="current_bookmark">
            <div class="bookmarks__capture">
              <!-- FIXME: 動いてない？ -->
              <transition name="fade">
                <img
                  v-if="current_bookmark.og_image_url"
                  :src="current_bookmark.og_image_url"
                  :alt="current_bookmark.name"
                >
                <img v-else src="https://dummyimage.com/600x400/e6e6e6/cccccc.png&text=+NO+IMAGE" alt="">
              </transition>
            </div>
            <div class="bookmarks__description">
              <div>Name: {{ current_bookmark.name }}</div>
              <div>URL: {{ current_bookmark.url | excerpt }}</div>
              <div>Keywords: {{ current_bookmark.keyword }}</div>
              <div>Impressions: {{ current_bookmark.impressions }} times</div>
              <div>Last_access_at: {{ current_bookmark.last_access_time | dateTime }}</div>
              <div>Created_at: {{ current_bookmark.created_at | moment }}</div>
            </div>
          </div>
        </div>
      </div>
      <div class="row pos-bottom">
        <div class="col-12 bookmarks__crumb">
          <div class="crumb d-flex justify-content-start">
            <div class="crumb__item"> <i class="fa fa-folder-o mr-1"></i>Bookmarks</div>
            <div
              v-for="(folder, index) in folder_hierarchy"
              v-bind:key="index"
              class="crumb__item"
            >
              <i class="fa fa-folder-o mr-1"></i>{{ folder }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';
  import moment from 'moment';

  export default {
    data: function() {
      const componentInstance = this;

      return {
        is_active: false,
        clicked_folder_id: "",
        items: [],
        folder_editing: false,
        current_bookmark: null,
        show_many_visits: null,
        show_history: null,
        manyVisitsActive: null,
        historyActive: null,
        is_add_folder: false,
        new_folder_name: null,
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
            if (componentInstance.$root.sort_setting != 'optional') {
              alert('Changing the order is valid only when sort setting is "optional".')
            }
          },
          onDragend: function(event) {
            // alert('onDragend')
          }
        }
      };
    },
    props: {
      _top_folder: { type: Object },
      _folder_items: { type: Array },
      _home_url: "",
      _settings: { type: Array },
      _show_item_menu: { type: Boolean },
      _show_item_menu_id: { type: Number },
      _sort_setting : { type: String },
    },
    mounted: function() {
      this.items = this._folder_items
      this.show_many_visits = this.settingFind('show_many_visits').value
      this.show_history = this.settingFind('show_history').value
      this.$root.sort_setting = this._sort_setting
    },
    computed: {
      // ボトムのパンくずリスト
      // FIXME: マウス動かさないと画面に反映しない
      folder_hierarchy() {
        if (!this.clicked_folder_id) { return }

        if (this.clicked_folder_id == 'many_visits') {
          this.$root.displayed_folder_names[0] = 'Many visits'
        }

        if (this.clicked_folder_id == 'history') {
          this.$root.displayed_folder_names[0] = 'History'
        }

        return this.$root.displayed_folder_names
      },
    },
    methods: {
      editBookmark(id) {
        (function () { var a = window, b = document, c = encodeURIComponent, d = a.open(`${this._home_url}/bookmarks/${id}/popup_edit?op=edit&output=popup&bkmk=` + c(b.location) + "&title=" + c(b.title), "bkmk_popup", "left=" + ((a.screenX || a.screenLeft) + 700) + ",top=" + ((a.screenY || a.screenTop) + 10) + ",height=510px,width=550px,resizable=1,alwaysRaised=1"); a.setTimeout(function () { d.focus() }, 300) })();
      },
      editFolder() {
        this.folder_editing = !this.folder_editing
      },
      receive(values) {
        console.log({values})
        this.clicked_folder_id = values.clicked_folder_id
        this.is_active = values.is_active
        this.manyVisitsActive = null
        this.historyActive = null
      },
      catch_bookmark(values) {
        this.current_bookmark = values.bookmark
      },
      openManyVisitsFolder() {
        this.is_active = true
        this.manyVisitsActive = 'active'
        this.historyActive = null
        this.clicked_folder_id = 'many_visits'
        this.$root.update_displayed_folders('many_visits', 0)
      },
      openHistoryFolder() {
        this.is_active = true
        this.historyActive = 'active'
        this.manyVisitsActive = null
        this.clicked_folder_id = 'history'
        this.$root.update_displayed_folders('history', 0)
      },
      settingFind(target) {
        return this._settings.find((elm) => {
          return elm.key == target
        })
      },
      create_folder() {
        this.$root.add_folder(this._top_folder.id, this.new_folder_name);
        this.is_add_folder = false;
        this.new_folder_name = null;

        this.refresh_folder()
      },
      async added(e) {
        // alert('added')
        var item = {id: e.detail.items[0].dataset.itemId, type: e.detail.items[0].dataset.itemType}
        var new_folder_id = e.detail.droptarget.dataset.folderId
        var new_sort_num = e.detail.index
        console.log({item, new_folder_id, new_sort_num})

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
        var item = this.items[e.detail.ids[0]]
        var new_sort_num = e.detail.index
        console.log({new_sort_num})

        // ソート番号のアップデート & 再フェッチ
        var type = item.url ? 'bookmarks' : 'folders';
        var result = await this.$root.updateSortNum(type, item.id, new_sort_num)

        if (result) this.refresh_folder();
      },
      refresh_folder() {
        axios.get(`/api/folders/${this._top_folder.id}/`).then(
          response => {
            // FIXME: なんかいったん空にしないとうまく反映しない。
            this.items = null;
            this.$nextTick(function () {
              this.items = response.data.folder_items
            });
          },
          error => { console.log(error); }
        );
      }
    },
    filters: {
      moment(date) {
        return moment(date).format('YYYY/MM/DD');
      },
      dateTime(date) {
        return moment(date).format('YYYY/MM/DD HH:MM');
      },
      excerpt(text) {
        if (text.length > 42) {
          return text.slice(0, 40) + '...'
        }
        return text
      }
    }
  }
</script>

<style lang="scss" scoped>
  .fade-enter-active, .fade-leave-active {
    transition: opacity .5s;
  }
  .fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
    opacity: 0;
  }
</style>