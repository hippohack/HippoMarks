<template>
  <nav class="navbar navbar-light bg-light">
    <router-link to="/" class="navbar-brand">
      <img src="https://getbootstrap.com/docs/4.3/assets/brand/bootstrap-solid.svg" width="30" height="30" class="d-inline-block align-top" alt="">
      Bookmarks
    </router-link>
    <a class="px-2 mr-2 text-dark" href="#home"><i class="fa fa-home fa-lg" aria-hidden="true"></i></a>
    <form class="flex-grow-1 mr-2">
      <input type="search" class="form-control" id="search-input" placeholder="Search...">
    </form>
    <ul class="flex-row navbar-nav ml-auto">
      <li class="nav-item dropdown ml-auto px-2">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Menu
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
          <a class="dropdown-item" href="#">アカウント設定</a>
          <a class="dropdown-item" href="#">システム設定</a>
          <hr class="my-1">
          <a class="dropdown-item" href="#">ログアウト</a>
        </div>
      </li>
    </ul>
  </nav>
</template>

<style lang="scss" scoped>
  .navbar-nav .dropdown-menu {
    position: absolute;
    left: -90px;
  }
  #search-input {
    border-radius: 1.5rem;
  }
</style>
