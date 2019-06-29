<template>
  <div>
    <folder
      v-for="(folder, index) in hierarchy_data[level][_id]"
      v-bind:key="index"
      :_folder="folder"
      :_all_folders="all_folders"
      :_hierarchy_data="hierarchy_data"
      :_level="level"
    ></folder>
  </div>
</template>

<script>
export default {
  data() {
    return {
      hierarchy_data: "",
      all_folders: "",
      level: ""
    }
  },
  props: {
    _hierarchy_data: "",
    _all_folders: "",
    _level: "",
    _id: ""
  },
  beforeMount() {
    this.hierarchy_data = this._hierarchy_data
    this.all_folders = this._all_folders
    this.level = this._level
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
