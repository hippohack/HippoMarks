<template>
  <div class="" v-bind:class="{ 'pl-4': _is_not_first }">
    <div v-if="is_create_folder" class='mb-2'>
      <i class="fa fa-folder-o ml-2"></i>
      <input type="text" name="folder[name]" v-model="new_folder_name" @blur="create" @keyup.enter="create" placeholder="folder name..." class="py-1 px-2">
    </div>

    <folder
      v-for="(folder, index) in _folders"
      v-bind:key="index"
      :_folders="folder"
    ></folder>
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
      new_folder_name: "",
      created_folder: "",
      is_create_folder: false,
    }
  },
  props: {
    _folders: "",
    _main_folder_id: "",
    _is_not_first: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    create() {
      console.log('create...')
      axios.post(`/api/folders/`, {
          folder_id: this._new_folder_parent_id,
          parent_count: null,
          name: this.new_folder_name
        })
        .then(response => {
          console.log(response)
          this.created_folder = response.data.folder
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
  }
}
</script>
