<template>
  <a :href="item.values.url" class="text-dark text-nowrap text-truncate">
    <i class="fa fa-link" aria-hidden="true"></i> {{ item.values.name }}
  </a>
</template>

<script>
export default {
  props: {
    item: { type: Object }
  }
}
</script>

