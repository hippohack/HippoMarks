<template>
  <div
    v-bind:class="{ active: is_active && item.id == _folder_id }"
    @contextmenu="show_contextmenu"
  >
    <a
      class="bookmarks__link"
      href="javascript:void(0)"
      v-if="!item.url && !folder_editing"
      @click="openFolder(item.id)"
    ><i class="fa fa-folder-o mr-2"></i>{{ item.name }}</a>

    <span v-if="folder_editing">
      <i class="fa fa-folder-o mr-2"></i>
      <input type="text" name="folder[name]" v-model="folder_name" @blur="update" @keyup.enter="update" class="edit-form">
    </span>

    <a
      class="bookmarks__link"
      target="_blank"
      v-if="item.url"
      :href="item.url"
      :title="item.keyword"
    >
      <img v-if="item.icon" :src="item.icon" class="mr-2" alt="">
      <i v-if="!item.icon" class="fa fa-link mr-2"></i>
      {{ item.name }}
    </a>

    <context-menu
      v-if="context_menu"
      :_pageX="pageX"
      :_pageY="pageY"
      :_item="item"
      :_home_url="_home_url"
      @apply="receive"
      @folder_edit="editFolder"
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
        pageY: ""
      };
    },
    props: {
      _item: "",
      _folder_id: "",
      _home_url: ""
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
      }
    }
  }
</script>

<style lang="scss" scoped>
  .edit-form {
    width: 85%;
  }
</style>