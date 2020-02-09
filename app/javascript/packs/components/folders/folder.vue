<template>
  <div class="">
    <div v-if="_folders.folder.folder_id != null">
      <span v-if="folders.children.length > 0" @click="opened_child_folder = !opened_child_folder">
        <span v-if="opened_child_folder" class="folder__state">▼</span>
        <span v-else class="folder__state">▶</span>
      </span>
      <span v-else style="visibility: hidden;" class="folder__state">▶</span>
      <i class="fa fa-folder-o ml-1"></i>
      <input
        type="radio"
        name="bookmark[folder_id]"
        class="d-none"
        :checked="folders.folder.id == _bookmark.folder_id"
        :id="`item_${folders.folder.id}`"
        :value="folders.folder.id"
        @change="$root.new_folder_parent_id = folders.folder.id"
      >
      <label class="folder__label" :for="`item_${folders.folder.id}`"> {{ folders.folder.name }}</label>
    </div>

    <!-- create folder // -->
    <div v-if="$root.is_create_folder && folders.folder.id == $root.new_folder_parent_id" style='padding-left: 2.2rem;'>
      <i class="fa fa-folder-o ml-2"></i>
      <input type="text" name="folder[name]" v-model="new_folder_name" @blur="create" placeholder="folder name..." class="py-1 px-2">
    </div>
    <!-- // create folder -->

    <children
      v-if="opened_child_folder"
      :key="folders.folder.id"
      :_folders="folders.children"
      :_belong_folder_ids="_belong_folder_ids"
      :_bookmark="_bookmark"
      :_is_top="_folders.folder.folder_id == null"
    ></children>
  </div>
</template>

<script>
import axios from 'axios';
axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

export default {
  data() {
    return {
      folders: this._folders,
      opened_child_folder: false,
      open_folder: Number,
      new_folder_name: "",
      created_folder: "",
    }
  },
  props: {
    _folders: "",
    _belong_folder_ids: Array,
    _bookmark: Object,
  },
  methods: {
    create() {
      console.log('create...')
      axios.post(`/api/folders/`, {
          folder_id: this.folders.folder.id,
          name: this.new_folder_name
        })
        .then(response => {
          console.log(response)
          this.folders.children.push({folder: response.data.folder, children: []})
          this.reset_and_show()
        })
        .catch(error => {
          console.log(error)
        });
    },
    reset_and_show() {
      this.new_folder_name = null
      this.$root.is_create_folder = false
      this.opened_child_folder = true
    },
  },
  mounted() {
    // Main_folderはデフォで開いておく
    if (this._bookmark.id == null && this._folders.folder.folder_id == null) {
      this.opened_child_folder = true
    }

    // 所属するフォルダ開く
    if (this._belong_folder_ids && this._belong_folder_ids.includes(this.folders.folder.id)) {
      this.opened_child_folder = true
    }
  }
}
</script>

<style lang="scss">
  .folder {
    &__label {
      padding: 3px 5px;
      border-radius: 2px;
      margin-bottom: 0;

      input:checked + & {
        background-color: #ccc;
      }
    }
    &__state {
      font-size: 80%;
      position: relative;
      bottom: 2px;
    }
  }
  .pl-24px {
    padding-left: 24px;
  }
</style>
