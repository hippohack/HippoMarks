<template>
  <div class="pl-4">
    <folder
      v-for="(folder, index) in _folders"
      v-bind:key="index"
      :_folders="folder"
      :_belong_folder_ids="_belong_folder_ids"
      :_bookmark="_bookmark"
    ></folder>
  </div>
</template>

<script>
export default {
  props: {
    _folders: "",
    _belong_folder_ids: Array,
    _bookmark: Object
  },
}
</script>
