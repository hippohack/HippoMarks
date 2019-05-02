<template lang="pug">
  <div class="hoge">
    <!-- 内容はお好みで -->
    <p>If you want to contact me, you send mail to below address.</p>
    <p>test@example.com</p>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello Hoge!"
      // message: "Hello Vue!"
    }
  }
}
</script>

<style scoped lang="scss">
.hoge {
  border: solid 1px #ccc;
  padding: 20px;
  p {
    font-size: 2em;
    text-align: center;
  }
}
</style>