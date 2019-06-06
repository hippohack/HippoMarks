<template>
  <div class="folders">
    <div class="folder">
      ブックマークバー
      <div v-for="(folder, index) in this.folders" v-bind:key="index">
        <div class="" v-for="(f, i) in folder" v-bind:key="i">
          {{ f.name }}
        </div>
      </div>
    </div>
    <div class="folder">
      その他のブックマーク
    </div>
  </div>
</template>

<style lang="scss" scoped>

</style>

<script>
import axios from 'axios';
export default {
  data: function() {
    return {
      folders: ""
    }
  },
  mounted: function() {
    this.fetch();
  },
  methods: {
    fetch: function() {
      console.log("feach start.");
      axios.get("/api/folders").then(
        response => {
          console.log(response.data)
          this.folders = response.data.folders
        },
        error => { console.log(error); }
      );
    }
  }
}
</script>
