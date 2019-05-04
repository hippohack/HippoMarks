<template>
  <div class="bookmarkbar d-flex">
    <div class="bookmarkbar__item" v-for="item in items" v-bind:key="item.id">
      <a v-if="item.folder_id" v-on:click="test" href="javascript:void(0)" class="text-dark"><i class="fa fa-folder-o" aria-hidden="true"></i> {{ item.folder_id }}</a>
      <a v-if="!item.folder_id" href="javascript:void(0)" class="text-dark"><i class="fa fa-link" aria-hidden="true"></i> {{ item.name }}</a>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  .bookmarkbar {
    background-color: #ccc;
    padding: 10px;

    &__item {
      margin: 0 10px;
    }
  }
</style>

<script>
  var items = [
    { id: 1, name: "hoge", url: "fuga", folder_id: 1 },
    { id: 2, name: "hoge", url: "fuga", folder_id: 0 },
    { id: 3, name: "hoge", url: "fuga", folder_id: 0 },
  ]

  export default {
    data: function() {
      return {
        items: items,
      };
    },
    methods: {
      test: function() {
        alert('hoge')
      }
    }
  }
</script>