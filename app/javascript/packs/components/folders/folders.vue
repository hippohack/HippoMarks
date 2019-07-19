<template>
  <div>
    <new-folder
      v-if="_is_new_folder && _id == _new_folder_parent_id"
      :_all_folders="all_folders"
      :_hierarchy_data="hierarchy_data"
      :_level="level"
      :_new_folder_parent_id="new_folder_parent_id"
    ></new-folder>
    <folder
      v-for="(folder, index) in hierarchy_data[level][_id]"
      v-bind:key="index"
      :_folder="folder"
      :_all_folders="all_folders"
      :_hierarchy_data="hierarchy_data"
      :_level="level"
      :_is_new_folder="is_new_folder"
      :_new_folder_parent_id="new_folder_parent_id"
    ></folder>
  </div>
</template>

<script>
export default {
  data() {
    return {
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
    _new_folder_parent_id: ""
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
    find_folder(id) {
      return this._all_folders.find(function(elm) {
        return elm.id == id
      })
    }
  }
}
</script>
