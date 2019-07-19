<template>
  <div class='pl-3'>
    <span v-if="!is_created">
      <i class="fa fa-folder-o"></i>
      <input type="text" name="folder[name]" v-model="name" @blur="create">
    </span>

    <label v-if="is_created" :for="`item_${created_folder.id}`">
      <input type="radio" name="bookmark[folder_id]" :id="`item_${created_folder.id}`" :value="created_folder.id" @change="is_active = !is_active"> {{ created_folder.name }}
    </label>
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
      name: "folder name...",
      is_created: false,
      created_folder: "",
      hierarchy_data: "",
      all_folders: "",
      level: "",
      parent_folder: ""
    }
  },
  props: {
    _hierarchy_data: "",
    _all_folders: "",
    _level: "",
    _new_folder_parent_id: ""
  },
  beforeMount() {
    this.hierarchy_data = this._hierarchy_data
    this.all_folders = this._all_folders
    this.level = this._level
    this.parent_folder = this.find_folder(this._new_folder_parent_id)
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
          folder_id: this.parent_folder.id,
          parent_count: this.parent_folder.parent_count+1,
          name: this.name
        })
        .then(response => {
          console.log(response)
          this.created_folder = response.data.folder
          this.hierarchy_data = response.data.folders
          this.all_folders = response.data.all_folders
          this.show()
        })
        .catch(error => {
          console.log(error)
        });
    },
    show() {
      this.is_created = true
    },
    find_folder(id) {
      return this._all_folders.find(function(elm) {
        return elm.id == id
      })
    }
  }
}
</script>
