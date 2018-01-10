<template>
  <v-app dark>
    <v-navigation-drawer 
      app
      clipped
      fixed
      v-model="drawer"
      hide-overlay
    >
    </v-navigation-drawer>
    <the-toolbar @toggleDrawer="toggleDrawer">
    </the-toolbar>
    <v-content>
      <v-container fluid>
        <router-view></router-view>
      </v-container>
    </v-content>
    <the-footer></the-footer>
  </v-app>
</template>

<script lang='ts'>
import Vue from 'vue'
import TheToolbar from './views/TheToolbar.vue'
import TheFooter from './views/TheFooter.vue'

export default Vue.extend({
  components: {
    TheToolbar,
    TheFooter,
  },
  data: function () {
    return {
      drawer: true,
    }
  },
  methods: {
    toggleDrawer() {
      console.log(this.$vuetify.breakpoint.mdAndUp)
      this.drawer = !this.drawer
    }
  }
})
</script>

<style lang='scss'>
@import 'vuetify/dist/vuetify.min.css';
</style>
