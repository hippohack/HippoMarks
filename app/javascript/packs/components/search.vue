<template>
  <div class="search-form">
    <input
      type="search"
      name="s"
      id="search-input"
      placeholder="Search..."
      class="form-control"
      v-bind:class="{ hasItems : search_results }"
      v-model="search_keyword"
      @keyup="get_bookmarks"
      @focus="get_bookmarks"
      @blur="search_results = null"
    >
    <div class="search-results" v-if="search_results">
      <div v-if="search_results.length == 0">
        <span class="result-error ml-1">The bookmark you were looking for was not found.</span>
      </div>
      <div v-if="!Array.isArray(search_results) && search_results == 'searching'">
        <span>Searching...</span>
      </div>
      <div v-if="Array.isArray(search_results)">
        <div
          v-for="(item, index) in search_results"
          v-bind:key="index"
          class="search-results__item"
        >
          <img v-if="item.icon" :src="item.icon" alt="" width="18px">
          <i v-else class="fa fa-link" style="font-size: 18px;"></i>
          <a :href="item.url" target="_blank">
            <span class="ml-2">{{ item.name }}</span>
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import _ from 'lodash'

export default {
  data() {
    return {
      search_keyword: null,
      search_results: null
    }
  },
  props: {
    _param: null,
    _home_url: null
  },
  mounted() {
    if (this._param) {
      this.search_keyword = this._param
    }
  },
  methods: {
    get_bookmarks: _.throttle(function() {
      this.search_results = 'searching'
      axios.get(`/bookmarks/search/?s=${this.search_keyword}`).then(
        response => {
          console.log({response})
          this.search_results = response.data.bookmarks
        },
        error => { console.log(error); }
      );
    }, 1000)
  }
}
</script>

<style scoped lang="scss">
.search-form {
  position: relative;
}
.search-results {
  position: absolute;
  background-color: #fff;
  padding: 10px;
  border: solid 1px #e6e6e6;
  border-top: none;
  width: 100%;
  z-index: 100;
  border-bottom-left-radius: .5rem;
  border-bottom-right-radius: .5rem;
  &__item {
    padding: 5px 0;
    a {
      color: #333;
    }
  }
}
#search-input.hasItems {
  border-radius: .5rem;
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
  transition-property: border-radius;
  transition-delay: 300ms;
}
.result-error:before {
    content: "!";
    color: #fff;
    background-color: #ff0000;
    width: 20px;
    height: 20px;
    display: inline-block;
    border-radius: 100%;
    text-align: center;
    line-height: 1.3;
    margin-right: 4px;
    font-weight: bold;
}
</style>