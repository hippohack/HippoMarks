<template>
  <div class="pl-4">
    <folder
      v-for="(folder, index) in _folders"
      v-bind:key="index"
      :_folders="folder"
    ></folder>
  </div>
</template>

<script>
export default {
  props: {
    _folders: "",
  },
}
</script>
