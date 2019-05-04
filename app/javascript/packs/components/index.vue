<template>
  <div class="col-12 col-md-3 col-xl-2">
    <sidebar></sidebar>
  </div>
</template>

<script>
import axios from "axios";
import Sidebar from './sidebar.vue'

export default {
  data: function() {
    return {
      tasks: [],
      newTask: ""
    };
  },
  components: {
    'sidebar': Sidebar,
  },
  mounted: function() {
    this.fetchTasks();
  },
  methods: {
    fetchTasks: function() {
      axios.get("/api/tasks").then(
        response => {
          for (var i = 0; i < response.data.tasks.length; i++) {
            this.tasks.push(response.data.tasks[i]);
          }
        },
        error => {
          console.log(error);
        }
      );
    },
    displayFinishedTasks: function() {
      console.log("c");
      document.querySelector("#finished-tasks").classList.toggle("d-none");
    },
    createTask: function() {
      if (!this.newTask) return;
      axios
        .post("/api/tasks", { task: { name: this.newTask, is_done: false } })
        .then(
          response => {
            this.tasks.unshift(response.data.task);
            this.newTask = "";
          },
          error => {
            console.log(error);
          }
        );
    }
  }
};
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
