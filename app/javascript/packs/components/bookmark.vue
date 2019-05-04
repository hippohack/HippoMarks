<template>
  <div>
    <span v-for="nest_item in nest_items" v-bind:key="nest_item.id">
      <a v-if="!nest_item.folder_id" :href="nest_item.url" class="text-dark dropdown-item"><i class="fa fa-link" aria-hidden="true"></i> {{ nest_item.name }}</a>
      <a
        v-if="nest_item.folder_id"
        href="javascript:void(0)"
        class="text-dark dropdown-item"
        :id="'folder_' + nest_item.id">
        <i class="fa fa-folder-o" aria-hidden="true"></i> {{ nest_item.folder_id }}
      </a>
    </span>
  </div>
</template>

<script>
  export default {
    props: {
      nest_items: {
        type: Array
      }
    }
  }
</script>