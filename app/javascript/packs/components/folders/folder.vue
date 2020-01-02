<template>
  <div class="">
    <span v-if="_folders.children.length > 0" @click="opened_child_folder = !opened_child_folder">
      <span v-if="opened_child_folder" class="folder__state">▼</span>
      <span v-else class="folder__state">▶</span>
    </span>
    <span v-else style="visibility: hidden;" class="folder__state">▶</span>
    <i class="fa fa-folder-o ml-1"></i>
    <input type="radio" name="bookmark[folder_id]" :id="`item_${_folders.folder.id}`" :value="_folders.folder.id" class="d-none">
    <label class="folder__label" :for="`item_${_folders.folder.id}`"> {{ _folders.folder.name }}</label>

    <folders
      v-if="opened_child_folder"
      :key="_folders.folder.id"
      :_folders="_folders.children"
      :_is_not_first="true"
    ></folders>
  </div>
</template>

<script>
export default {
  data() {
    return {
      is_active: false,
      opened_child_folder: false
    }
  },
  props: {
    _folders: "",
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
