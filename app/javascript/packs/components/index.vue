<template>
  <section>
    <div>
      <ul>
        <li v-for="task in tasks" v-if="!task.is_done" v-bind:id="'row_task_' + task.id" class="collection_item">
          <input type="checkbox" v-bind:id="'task_' + task.id">
          <label v-bind:for="'task_' + task.id" v-cloak>{{ task.name }}</label>
        </li>
      </ul>
    </div>

    <a href="javascript:void(0)" class="btn hoge" v-on:click="displayFinishedTasks">Display finished tasks</a>

    <div id="finished-tasks" class="d-none">
      <ul class="collection">
        <li v-for="task in tasks" v-if="task.is_done" v-bind:id="'row_task_' + task.id" class="collection-item">
          <input type="checkbox" v-bind:id="'task_' + task.id" checked="checked" />
          <label v-bind:for="'task_' + task.id" class="line-through" v-cloak>{{ task.name }}</label>
        </li>
      </ul>
    </div>
  </section>
</template>

<script>
import axios from 'axios';
export default {
  data: function() {
    return {
      tasks: [],
      newTask: ''
    }
  },
  mounted: function() {
    this.fetchTasks()
  },
  methods: {
    fetchTasks: function() {
      axios.get('/api/tasks').then((response) => {
        for(var i = 0; i < response.data.tasks.length; i++) {
          this.tasks.push(response.data.tasks[i])
        }
      }, (error) => {
        console.log(error)
      });
    },
    displayFinishedTasks: () => {
      console.log('c')
      document.querySelector('#finished-tasks').classList.toggle('d-none')
    }
  }
}
</script>

<style lang="scss" scoped>
  [v-cloak] {
    display: none;
  }
  .d-none {
    display: none;
  }
  .line-through {
    text-decoration: line-through;
  }
</style>
