<template>
  <div class="row flex-xl-nowrap">
    <div class="col-2 bookmarks__col bookmarks__col--first">
      <div class="bookmarks__items">
        <div
          class="bookmarks__item"
          v-for="(item, index) in items"
          v-bind:key="index"
        >
          <a
            class="bookmarks__link"
            href="javascript:void(0)"
            v-if="!item.url"
            @click="openFolder(item.id)"
          ><i class="fa fa-folder-o mr-2"></i>{{ item.name }}</a>

          <a
            class="bookmarks__link"
            target="_blank"
            :href="item.url"
            v-if="item.url"
          ><i class="fa fa-link mr-2"></i>{{ item.name }}</a>
        </div>
      </div>
    </div>

    <div class="col-10">
      <div class="row">
        <div class="col">
          <bookmark-columns
            v-if="is_active"
            :_clicked_folder_id="clicked_folder_id"
          ></bookmark-columns>
        </div>
        <div class="col bookmark__col bookmark__col--last">
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
        items: []
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
      }
    }
  }
</script>

<style lang="scss" scoped>
  
</style>