<template>
  <div class="nest-items">
    <div v-for="item in items" v-bind:key="item.id">
      <a v-if="!item.folder_id" :href="item.url" class="text-dark nest-items__item"><i class="fa fa-link" aria-hidden="true"></i> {{ item.name }}</a>
      <div
        v-if="item.folder_id"
        class="text-dark nest-items__item"
        :id="'folder_' + item.id">
        <i class="fa fa-folder-o" aria-hidden="true"></i> {{ item.folder_id }}
        <nest-items :items="nest_items" v-if="item.folder_id"></nest-items>
      </div>
    </div>
  </div>
</template>

<script>
import NestItems from './nestItems.vue'

var nest_items = [
  { id: 21, name: "hoge", url: "fuga", folder_id: 3 },
  { id: 22, name: "hoge", url: "fuga", folder_id: 0 },
  { id: 23, name: "hoge", url: "fuga", folder_id: 3 },
  { id: 24, name: "hoge", url: "fuga", folder_id: 0 },
]

export default {
  name: 'nest-items',
  data: function() {
    return {
      nest_items,
    }
  },
  props: {
    items: {
      type: Array
    },
  },
  components: {
    NestItems
  }
}
</script>

<style lang="scss" scoped>
  .nest-items {
    display: none;
    position: absolute;
    transform: translate3d(320px, -10px, 0px); // TODO: 動的に設定
    top: 0px;
    left: 0px;
    will-change: transform;
    z-index: 1000;
    padding: 0.5rem 0;
    margin: 0.125rem 0 0;
    font-size: 1rem;
    color: #212529;
    text-align: left;
    list-style: none;
    background-color: #fff;
    background-clip: padding-box;
    border: 1px solid rgba(0, 0, 0, 0.15);
    border-radius: 0.25rem;

    &.is_active {
      display: block;
    }

    &__item {
      display: block;
      width: 100%;
      padding: 0.25rem 1.5rem;
      clear: both;
      font-weight: 400;
      color: #212529;
      text-align: inherit;
      white-space: nowrap;
      background-color: transparent;
      border: 0;
    }
  }
</style>


