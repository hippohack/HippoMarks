<template>
  <div class="row">
    <bookmark-column
      v-for="(column, index) in com_columns"
      v-bind:key="index"
      :_folder_id="column.folder_id"
      :_level="column.level"
      @apply="receive"
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
        console.log({values})
        this.columns[values.level] = { folder_id: values.folder_id, level: values.level }
        this.$forceUpdate()
      }
    }
  }
</script>
