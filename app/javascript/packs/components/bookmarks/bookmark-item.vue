<template>
  <div>
    <a
      class="bookmarks__link"
      href="javascript:void(0)"
      v-if="!item.url && !folder_editing"
      @click="openFolder(item.id)"
      @mouseover="edit_show = !edit_show"
    ><i class="fa fa-folder-o mr-2"></i>{{ item.name }}</a>

    <span v-if="folder_editing">
      <i class="fa fa-folder-o mr-2"></i>
      <input type="text" name="folder[name]" v-model="folder_name" @blur="update" class="edit-form">
    </span>

    <a
      class="bookmarks__link"
      target="_blank"
      :href="item.url"
      v-if="item.url"
      @mouseover="edit_show = !edit_show"
    ><i class="fa fa-link mr-2"></i>{{ item.name }}</a>

    <a v-if="item.url && !folder_editing && edit_show" :id="`edit-${item.id}`" href="javascript:void(0)" :data-item-id="item.id" data-item-type="bookmark" @click="editBookmark(item.id)">edit</a>
    <a v-if="!item.url && !folder_editing && edit_show" :id="`edit-${item.id}`" href="javascript:void(0)" :data-item-id="item.id" data-item-type="folder" @click="editFolder(item.id)">edit</a>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    data: function() {
      return {
        item: "",
        is_active: false,
        clicked_folder_id: "",
        folder_editing: false,
        edit_show: false
      };
    },
    props: {
      _item: ""
    },
    mounted() {
      this.item = this._item
      this.folder_name = this._item.name
    },
    methods: {
      openFolder: function(folder_id) {
        console.log({folder_id})
        this.$emit('apply', { clicked_folder_id: folder_id, is_active: true })
      },
      editBookmark(id) {
        (function () { var a = window, b = document, c = encodeURIComponent, d = a.open(`http://localhost:3000/bookmarks/${id}/edit?op=edit&output=popup&bkmk=` + c(b.location) + "&title=" + c(b.title), "bkmk_popup", "left=" + ((a.screenX || a.screenLeft) + 700) + ",top=" + ((a.screenY || a.screenTop) + 10) + ",height=510px,width=550px,resizable=1,alwaysRaised=1"); a.setTimeout(function () { d.focus() }, 300) })();
      },
      editFolder() {
        this.folder_editing = !this.folder_editing
      },
      update() {
        this.item.name = this.folder_name

        axios.patch(`/api/folders/${this.item.id}`, this.item)
          .then(function(response) {
            console.log(response)
          })
          .catch(function(error) {
            console.log(error)
          })

        this.folder_editing = !this.folder_editing
      }
    }
  }
</script>

<style lang="scss" scoped>
  .edit-form {
    width: 85%;
  }
</style>