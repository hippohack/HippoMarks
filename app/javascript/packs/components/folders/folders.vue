<template>
  <div class="">
    <folder
      v-for="(folder, index) in folders"
      v-bind:key="index"
      :_folders="folder"
      :_belong_folder_ids="_belong_folder_ids"
      :_bookmark="_bookmark"
    ></folder>
  </div>
</template>

<script>
export default {
  data() {
    return {
      folders: this._folders,
    }
  },
  props: {
    _folders: "",
    _belong_folder_ids: Array,
    _bookmark: Object
  }
}
</script>
