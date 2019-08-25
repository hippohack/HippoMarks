<template>
  <div class="row flex-xl-nowrap">
    <div class="col-2 bookmarks__col bookmarks__col--first">
      <div class="bookmarks__items">
        <div
          class="bookmarks__item"
          v-for="(item, index) in items"
          v-bind:key="index"
        >
          <bookmark-item
            :_item="item"
            :_folder_id="clicked_folder_id"
            @apply="receive"
          ></bookmark-item>
        </div>
      </div>
    </div>

    <div class="col">
      <div class="row">
        <div class="col" style="overflow:auto;">
          <bookmark-columns
            v-if="is_active"
            :_clicked_folder_id="clicked_folder_id"
          ></bookmark-columns>
        </div>
        <div class="col-4 bookmark__col bookmark__col--last">
          <div class="bookmarks__capture">
            <img src="https://dummyimage.com/600x400/000/fff" alt="">
          </div>
          <div class="bookmarks__description">
            <div> hoge</div>
            <div> fuga</div>
            <div> piyo</div>
          </div>
        </div>
      </div>
      <div class="row pos-bottom">
        <div class="col-12 bookmarks__crumb">
          <div class="crumb d-flex justify-content-start">
            <div class="crumb__item"><i class="fa fa-folder-o mr-1"></i> FOLDER_NAME</div>
            <div class="crumb__item"><i class="fa fa-folder-o mr-1"></i> FOLDER_NAME</div>
            <div class="crumb__item"><i class="fa fa-folder-o mr-1"></i> FOLDER_NAME</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    data: function() {
      return {
        is_active: false,
        clicked_folder_id: "",
        items: [],
        folder_editing: false
      };
    },
    props: {
      _top_folder: { type: Object },
      _folders: { type: Array },
      _bookmarks: { type: Array }
    },
    mounted: function() {
      this.items = this._folders.concat(this._bookmarks)
    },
    methods: {
      openFolder: function(folder_id) {
        console.log({folder_id})
        this.clicked_folder_id = folder_id
        this.is_active = true
      },
      editBookmark(id) {
        (function () { var a = window, b = document, c = encodeURIComponent, d = a.open(`http://localhost:3000/bookmarks/${id}/edit?op=edit&output=popup&bkmk=` + c(b.location) + "&title=" + c(b.title), "bkmk_popup", "left=" + ((a.screenX || a.screenLeft) + 700) + ",top=" + ((a.screenY || a.screenTop) + 10) + ",height=510px,width=550px,resizable=1,alwaysRaised=1"); a.setTimeout(function () { d.focus() }, 300) })();
      },
      editFolder() {
        this.folder_editing = !this.folder_editing
      },
      update() {

      },
      receive(values) {
        console.log({values})
        this.clicked_folder_id = values.clicked_folder_id
        this.is_active = values.is_active
      }
    }
  }
</script>

<style lang="scss" scoped>
  
</style>