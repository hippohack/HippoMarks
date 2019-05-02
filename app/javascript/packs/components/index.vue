<template>
  <div>
    <ul>
      <li v-for="task in tasks" v-if="!task.is_done" v-bind:id="'row_task_' + task.id" class="collection_item">
        <input type="checkbox" v-bind:id="'task_' + task.id">
        <label v-bind:for="'task_' + task.id">{{ task.name }}</label>
      </li>
    </ul>
  </div>
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
    }
  }
}
</script>
