<template>
  <div v-bind:class="level === 1 ? null : 'pl-3'">
    <label :for="`item_${_folder.id}`">
      <input type="radio" name="bookmark[folder_id]" :id="`item_${_folder.id}`" :value="_folder.id" @change="is_active = !is_active"> {{ find_folder(_folder.id).name }}
    </label>
    <folders
      v-if="is_active && hierarchy_data[level+1]"
      :_hierarchy_data="hierarchy_data"
      :_all_folders="all_folders"
      :_level="level+1"
      :_id="_folder.id"
      :_is_new_folder="is_new_folder"
      :_new_folder_parent_id="new_folder_parent_id"
    ></folders>
  </div>
</template>

<script>
export default {
  data() {
    return {
      hierarchy_data: "",
      all_folders: "",
      level: "",
      is_active: false,
    }
  },
  props: {
    _folder: "",
    _all_folders: "",
    _level: "",
    _hierarchy_data: "",
    _is_new_folder: "",
    _new_folder_parent_id: "",
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
      return this._all_folders.find(function(element) {
        return element['id'] === id;
      })
    }
  }
}
</script>
