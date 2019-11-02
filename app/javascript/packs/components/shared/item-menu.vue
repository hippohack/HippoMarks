<template>
  <div class="item-menu">
    <a href="javascript:void(0)" class="item-menu__link" @click="showContextMenu">
      <i class="fa fa-ellipsis-h" aria-hidden="true" style="font-size: 18px;"></i>
    </a>
  </div>
</template>

<script>
export default {
  methods: {
    showContextMenu(event) {
      this.$emit('context_menu', { event: event });
    }
  }
}
</script>

<style lang="scss" scoped>
.item-menu {
  position: absolute;
  top: 0;
  right: 0;
  &__link {
    display: inline-block;
    padding: 5px 0;
    vertical-align: middle;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
}
</style>