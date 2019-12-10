<template>
  <div class="row flex-nowrap">
    <bookmark-column
      v-for="(folder_id, index) in displayed_folder_ids"
      v-bind:key="index"
      :_folder_id="folder_id"
      :_level="index"
    ></bookmark-column>
    <!-- <bookmark-column
      v-for="(column, index) in com_columns"
      v-bind:key="index"
      :_folder_id="column.folder_id"
      :_level="column.level"
      :_home_url="_home_url"
      :_show_item_menu="_show_item_menu"
      :_show_item_menu_id="_show_item_menu_id"
      @apply="receive"
      @apply_bookmark="relay_bookmark"
    ></bookmark-column> -->
  </div>
</template>

<script>
  export default {
    data: function() {
      return {
        is_active: false,
        columns: [],
        clicked_folder_id: "",
        __displayed_folder_ids: []
      }
    },
    props: {
      _clicked_folder_id: "",
      _home_url: "",
      _show_item_menu: { type: Boolean },
      _show_item_menu_id: { type: Number },
    },
    computed: {
      displayed_folder_ids() {
        // 直接ルートの値は監視してくれないので適当なものを監視してフック
        this.clicked_folder_id = this._clicked_folder_id
        return this.$root.displayed_folder_ids
      },
      com_columns() {
        if (this.clicked_folder_id != this._clicked_folder_id) {
          this.columns = []
        }
        this.columns[0] = {
          folder_id: this._clicked_folder_id,
          level: 1
        }
        return this.columns
      },
    },
    methods: {
      receive(values) {
        if (this.columns.length > values.level) {
          for (var i = values.level; i < this.columns.length+1; i++) {
            this.columns.splice(i)
          }
        }
        this.columns[values.level] = { folder_id: values.folder_id, level: values.level }
        this.$emit('apply2', { folder_name: values.folder_name, level: values.level })
        this.$forceUpdate()
      },
      relay_bookmark(values) {
        this.$emit('apply_bookmark', { bookmark: values.bookmark })
      }
    }
  }
</script>
