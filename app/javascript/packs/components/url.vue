<template>
  <div v-bind:class="[level == 1 ? 'u_pos-t-3 lev-1' : '']">
    <a :href="item.values.url" class="text-dark text-nowrap text-truncate">
      <i class="fa fa-link" aria-hidden="true"></i> {{ item.values.name }}
    </a>
  </div>
</template>

<script>
export default {
  props: {
    item: { type: Object },
    level: ''
  }
}
</script>

<style lang="scss" scoped>
.u_pos-t-3 {
  position: relative;
  top: 3px;
}
a {
  font-size: 14px;
  padding: 2px 15px;
  .lev-1 & {
    padding: 0;
  }
}
</style>

