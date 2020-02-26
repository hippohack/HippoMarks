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
      @keyup="bookmark_action"
      @focus="bookmark_action"
      @blur="defocus_search_results"
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
          v-bind:class="{ is_focus : focus_current.id == item.id }">
          <a :href="item.url"
            target="_blank"
            :id="`js_bookmark_${item.id}`"
            class="js_search-result-focus d-block pl-2"
            :data-item-id="item.id"
            @mouseover="hoverItemId"
            @mouseleave="showEdit = false">
            <div class="d-flex">
              <div>
                <img v-if="item.icon" :src="item.icon" alt="" width="18px">
                <i v-else class="fa fa-link" style="font-size: 18px;"></i>
                <span class="ml-2">{{ item.name }}</span>
              </div>
              <div class="ml-auto" v-show="showEdit && editItemId == item.id">
                <a href="#" class="d-block px-2">Edit</a>
              </div>
            </div>
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
      search_results: null,
      focus_pos: 0,
      focus_current: null,
      showEdit: false,
      editItemId: null
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
    bookmark_action(e) {
      if (e.key == 'ArrowUp') {
        this.focus_up()
        return
      }

      if (e.key == 'ArrowDown') {
        this.focus_down()
        return
      }

      if (e.key == 'Enter') {
        this.open_focus_bookmark()
        return
      }

      this.get_bookmarks()
    },

    get_bookmarks: _.throttle(function() {
      this.search_results = 'searching'
      axios.get(`/bookmarks/search/?s=${this.search_keyword}`).then(
        response => {
          console.log({response})
          this.search_results = response.data.bookmarks
          this.focus_pos = 0
          this.focus_current = this.search_results[0]
        },
        error => { console.log(error); }
      );
    }, 1000),

    /**
     * リンクを押す前にデータがnullになるのを防ぐため200ms遅らせてる
     */
    defocus_search_results() {
      setTimeout(() => {
        this.search_results = null
      }, 200)
    },

    focus_up() {
      if (typeof this.search_results === 'object' && this.search_results.length > 0) {
        console.log('up')
        if (this.focus_pos == 0) {
          this.focus_pos = this.search_results.length
        }

        this.focus_pos -= 1
        this.focus_current = this.search_results[this.focus_pos]
      }
    },

    focus_down() {
      if (typeof this.search_results === 'object' && this.search_results.length > 0) {
        console.log('down')
        this.focus_pos += 1

        if (this.focus_pos == this.search_results.length) {
          this.focus_pos = 0
        }

        this.focus_current = this.search_results[this.focus_pos]
      }
    },

    open_focus_bookmark() {
      console.log('open_focus_bookmark')
      if (!this.focus_current) {
        return false
      }

      this.incrementImpression(this.focus_current.id)

      var win = window.open(this.focus_current.url, '_blank');
      win.focus();
    },

    // TODO: 複数箇所で同じ処理書いてるのでまとめる
    incrementImpression(id) {
      let res = axios.patch(`/api/bookmarks/${id}/increment_impression`, { 'increment': true } )
        .then((response) => {
          console.log({response})
        })
        .catch((error) => {
          console.log({error})
        })
    },

    hoverItemId(e) {
      this.showEdit = true;
      this.editItemId = $(e.target).parents('a').data('item-id');
    }
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
    &.is_focus {
      background-color: #e6e6e6;
    }
    &:hover {
      background-color: #f8f9fa;
    }
    a {
      color: #333;
      &:hover {
        text-decoration: none;
      }
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