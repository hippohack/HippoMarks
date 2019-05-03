<template>
  <nav class="navbar navbar-light bg-light">
    <router-link to="/" class="navbar-brand">
      <img src="https://getbootstrap.com/docs/4.3/assets/brand/bootstrap-solid.svg" width="30" height="30" class="d-inline-block align-top" alt="">
      Bookmarks
    </router-link>
    <ul class="flex-row navbar-nav">
      <li class="nav-item active px-2">
        <router-link to="/" class="nav-link">Top</router-link>
      </li>
      <li class="nav-item px-2">
        <router-link to="/about" class="nav-link">About</router-link>
      </li>
      <li class="nav-item px-2">
        <router-link to="/contact" class="nav-link">Contact</router-link>
      </li>
    </ul>
    <ul class="flex-row navbar-nav ml-auto">
      <li class="nav-item dropdown ml-auto px-2">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Dropdown link
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
          <a class="dropdown-item" href="#">Action</a>
          <a class="dropdown-item" href="#">Another action</a>
          <a class="dropdown-item" href="#">Something else here</a>
        </div>
      </li>
    </ul>
  </nav>
</template>

<style lang="scss" scoped>
  .navbar-nav .dropdown-menu {
    position: absolute;
    left: -70px;
  }
</style>
