<template>
  <div>
    <div v-if="!is_created && _is_new_folder && _id == _new_folder_parent_id" class='pl-5 mb-2'>
      <i class="fa fa-folder-o ml-2"></i>
      <input type="text" name="folder[name]" v-model="name" @blur="create" @keyup.enter="create" placeholder="folder name..." class="py-1 px-2">
    </div>

    <div v-if="hierarchy_data[level]">
      <folder
        v-for="folder in hierarchy_data[level][_id]"
        v-bind:key="folder.id"
        :_folder="folder"
        :_all_folders="all_folders"
        :_hierarchy_data="hierarchy_data"
        :_level="level"
        :_is_new_folder="is_new_folder"
        :_new_folder_parent_id="new_folder_parent_id"
        :_belong_folder="_belong_folder"
        :_bookmark="_bookmark"
      ></folder>
    </div>
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
      name: "",
      is_created: false,
      created_folder: "",
      hierarchy_data: "",
      all_folders: "",
      level: "",
    }
  },
  props: {
    _hierarchy_data: "",
    _all_folders: "",
    _level: "",
    _id: "",
    _is_new_folder: "",
    _new_folder_parent_id: "",
    _belong_folder: "",
    _bookmark: ""
  },
  beforeMount() {
    this.hierarchy_data = this._hierarchy_data
    this.all_folders = this._all_folders
    this.level = this._level
  },
  computed: {
    is_new_folder() {
      return this._is_new_folder
    },
    new_folder_parent_id() {
      return this._new_folder_parent_id
    },
  },
  methods: {
    create() {
      console.log('create...')
      axios.post(`/api/folders/`, {
          folder_id: this._new_folder_parent_id,
          parent_count: this._level,
          name: this.name
        })
        .then(response => {
          console.log(response)
          this.created_folder = response.data.folder
          this.hierarchy_data = response.data.folders
          this.all_folders = response.data.all_folders
          this.$root.is_new_folder = false
          this.show()
        })
        .catch(error => {
          console.log(error)
        });
    },
    show() {
      this.is_created = true
      this.$forceUpdate()
      // reset
      this.name = null
      this.is_created = false
    },
    find_folder(id) {
      return this._all_folders.find(function(elm) {
        return elm.id == id
      })
    },
  }
}
</script>
