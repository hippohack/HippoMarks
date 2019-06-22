<template>
  <div class="row">
    <bookmark-column
      :_clicked_folder_id="folder_id"
      :_level="0"
      @apply="receive"
    ></bookmark-column>
  </div>
</template>

<script>
  export default {
    data: function() {
      return {
        is_active: false,
        clicked_folder_id: "",
        request_folder_id: "",
        request_level: ""
      }
    },
    props: {
      _clicked_folder_id: { type: Number }
    },
    computed: {
      folder_id() {
        this.clicked_folder_id = this._clicked_folder_id
        return this.clicked_folder_id
      }
    },
    methods: {
      openFolder: function(folder_id) {
        console.log({folder_id})
        this.clicked_folder_id = folder_id
        this.is_active = true
      },
      receive(values) {
        console.log({values})
      }
    }
  }
</script>
