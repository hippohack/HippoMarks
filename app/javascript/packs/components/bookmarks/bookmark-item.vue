<template>
  <div
    v-if="!deleted_folder"
    v-bind:class="{ active: is_active && item.id == _folder_id }"
    @mouseenter="$root.showItemMenu(item.id)" @mouseleave="$root.hideItemMenu"
  >
    <a
      class="bookmarks__link"
      href="javascript:void(0)"
      v-if="!item.url && !folder_editing"
      @click="openFolder(item.id)"
    ><i class="fa fa-folder-o mr-2" style="font-size: 18px;"></i>{{ item.name }}</a>

    <span v-if="folder_editing">
      <i class="fa fa-folder-o mr-2" style="font-size: 18px;"></i>
      <input type="text"
             name="folder[name]"
             v-model="folder_name"
             @blur="update"
             @keyup.enter="update"
             ref="editFolderName"
             class="edit-form">
    </span>

    <a
      class="bookmarks__link"
      target="_blank"
      v-if="item.url"
      :href="item.url"
      :title="item.keyword"
      @click="incrementImpression(item.id)"
      @mouseenter="$emit('apply_bookmark', { bookmark: item })"
      @mouseleave="$emit('apply_bookmark', { bookmark: null })"
    >
      <span v-if="item.icon">
        <img :src="item.icon" class="mr-2" alt="" style="width: 18px;">{{ item.name }}
      </span>
      <span v-else>
        <i class="fa fa-link mr-2" style="font-size: 18px;"></i>{{ item.name }}
      </span>
    </a>

    <item-menu
      v-if="_show_item_menu && _show_item_menu_id == item.id"
      @context_menu="receive_contextmenu"
    ></item-menu>

    <context-menu
      v-if="context_menu"
      :_pageX="pageX"
      :_pageY="pageY"
      :_item="item"
      :_home_url="_home_url"
      @apply="receive"
      @folder_edit="editFolder"
      @delete_folder="delete_folder"
      @open_bookmark_edit="context_menu = false"
    ></context-menu>
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
        edit_show: false,
        context_menu: false,
        pageX: "",
        pageY: "",
        deleted_folder: false
      };
    },
    props: {
      _item: "",
      _folder_id: "",
      _home_url: "",
      _show_item_menu: { type: Boolean },
      _show_item_menu_id: { type: Number }
    },
    mounted() {
      this.item = this._item
      this.folder_name = this._item.name
    },
    methods: {
      openFolder: function(folder_id) {
        console.log({folder_id})
        this.is_active = true
        this.$emit('apply', { clicked_folder_id: folder_id, is_active: true })
      },
      editFolder(values) {
        this.folder_editing = values.folder_editing
        this.context_menu = false
        this.$nextTick(function () {
          this.$refs.editFolderName.focus()
        })
      },
      update(event) {
        this.item.name = this.folder_name

        axios.patch(`/api/folders/${this.item.id}`, this.item)
          .then(function(response) {
            console.log(response)
          })
          .catch(function(error) {
            console.log(error)
          })

        this.folder_editing = false
      },
      show_contextmenu(e) {
        this.pageX = e.pageX
        this.pageY = e.pageY
        this.context_menu = true
        e.preventDefault();
      },
      receive(values) {
        this.context_menu = values.flag
      },
      delete_folder(values) {
        this.deleted_folder = values.delete_folder
      },
      incrementImpression(id) {
        let res = axios.patch(`/api/bookmarks/${id}/increment_impression`, { 'increment': true } )
          .then((response) => {
            console.log({response})
          })
          .catch((error) => {
            console.log({error})
          })
      },
      receive_contextmenu(values) {
        this.show_contextmenu(values.event)
      },
    }
  }
</script>

<style lang="scss" scoped>
  .edit-form {
    width: 85%;
  }
</style>