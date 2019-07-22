<template>
  <div>
    <a
      class="bookmarks__link"
      href="javascript:void(0)"
      v-if="!item.url && !folder_editing"
      @click="openFolder(item.id)"
    ><i class="fa fa-folder-o mr-2"></i>{{ item.name }}</a>

    <span v-if="folder_editing">
      <i class="fa fa-folder-o mr-2"></i>
      <input type="text" name="folder[name]" v-model="name" @blur="update">
    </span>

    <a
      class="bookmarks__link"
      target="_blank"
      :href="item.url"
      v-if="item.url"
    ><i class="fa fa-link mr-2"></i>{{ item.name }}</a>

    <a v-if="item.url && !folder_editing" :id="`edit-${item.id}`" href="javascript:void(0)" :data-item-id="item.id" data-item-type="bookmark" @click="editBookmark(item.id)">edit</a>
    <a v-if="!item.url && !folder_editing" :id="`edit-${item.id}`" href="javascript:void(0)" :data-item-id="item.id" data-item-type="folder" @click="editFolder(item.id)">edit</a>
  </div>
</template>

<script>
  export default {
    data: function() {
      return {
        item: "",
        is_active: false,
        clicked_folder_id: "",
        folder_editing: false
      };
    },
    props: {
      _item: ""
    },
    mounted() {
      this.item = this._item
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

      }
    }
  }
</script>

<style lang="scss" scoped>
  
</style>