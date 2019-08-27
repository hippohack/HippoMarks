<template>
  <div class="row flex-nowrap">
    <bookmark-column
      v-for="(column, index) in com_columns"
      v-bind:key="index"
      :_folder_id="column.folder_id"
      :_level="column.level"
      @apply="receive"
      @apply_bookmark="relay_bookmark"
    ></bookmark-column>
  </div>
</template>

<script>
  export default {
    data: function() {
      return {
        is_active: false,
        columns: [],
        clicked_folder_id: ""
      }
    },
    props: {
      _clicked_folder_id: { type: Number }
    },
    mounted() {
      this.clicked_folder_id = this._clicked_folder_id
    },
    computed: {
      com_columns() {
        if (this.clicked_folder_id != this._clicked_folder_id) {
          this.columns = []
        }
        this.columns[0] = {
          folder_id: this._clicked_folder_id,
          level: 0
        }
        return this.columns
      }
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
