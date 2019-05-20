<template>
  <span>
    <div
      class="text-dark dropdown-toggle text-nowrap text-truncate"
      :id="'folder_' + item.id"
      role="button"
      data-toggle="dropdown"
      aria-haspopup="true"
      aria-expanded="false">
      <i class="fa fa-folder-o" aria-hidden="true"></i> {{ item.item_id }}
    </div>
    <div class="dropdown-menu" :aria-labelledby="'folder_' + item.id">
      <bookmark :folder_id="item.item_id"></bookmark>
    </div>
  </span>
</template>

<script>
export default {
  props: {
    item: { type: Object }
  }
}
</script>
