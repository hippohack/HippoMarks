<template>
  <div v-bind:class="level === 1 ? null : 'pl-24px'">
    <span v-if="find_child(_folder.id)" @click="is_active = !is_active">
      <span v-if="!is_active" class="folder__state">▶</span>
      <span v-else class="folder__state">▼</span>
    </span>
    <span v-else style="visibility: hidden;" class="folder__state">▶</span>
    <i class="fa fa-folder-o ml-1"></i>
    <input type="radio" name="bookmark[folder_id]" :id="`item_${_folder.id}`" :value="_folder.id" class="d-none" v-model="_bookmark.folder_id">
    <label class="folder__label" :for="`item_${_folder.id}`"> {{ find_folder(_folder.id).name }}</label>
    <folders
      v-if="is_active"
      :key="_folder.id"
      :_hierarchy_data="hierarchy_data"
      :_all_folders="all_folders"
      :_level="level+1"
      :_id="_folder.id"
      :_is_new_folder="is_new_folder"
      :_new_folder_parent_id="new_folder_parent_id"
      :_bookmark="_bookmark"
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
      has_child: false
    }
  },
  props: {
    _folder: "",
    _all_folders: "",
    _level: "",
    _hierarchy_data: "",
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
  mounted() {
    if (this.open_belong_folder(this._bookmark.folder_id)) {
      console.log('mounted')
      this.is_active = true;
    }
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
    },
    find_child(id) {
      return this._all_folders.find(function(element) {
        return element['folder_id'] === id
      })
    },
    open_belong_folder(folder_id) {
      let res
      let folder = this.find_folder(folder_id)

      if (this.level > folder.parent_count) return false

      // TODO: 同階層の全部を開いてしまうので調整必要
      for (var key in this._hierarchy_data[folder.parent_count]) {
        console.log(key)
        res = this._hierarchy_data[folder.parent_count][key].find( (element) => {
          console.log('doing')
          return element['id'] === folder_id
        })
        if (res) break
      }

      return res
    }
  },
  // TODO: これで監視してみる？？ → いまんとこいらない
  watch: {
    _is_new_folder(val, oldVal) {
      if(val) {
        this.is_active = true
      }
      console.log('new: %s, old: %s', val, oldVal)
    }
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
