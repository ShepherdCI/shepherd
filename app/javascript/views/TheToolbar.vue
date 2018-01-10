<template>
  <v-toolbar 
    app
    color="green"
    clipped-left
    fixed
  >
    <v-toolbar-side-icon @click.stop="toggleDrawer"> </v-toolbar-side-icon>
    <span class="hidden-xs">ShepherdCI</span>
    <v-spacer></v-spacer>

    <v-menu offset-y transition='false' v-if='isLoggedIn'>
      <v-btn flat slot='activator'>
        {{ currentUser.name }}
      </v-btn>
      <v-list>
        <v-list-tile @click='logout'>
          <v-list-tile-title>Logout</v-list-tile-title>
        </v-list-tile>
      </v-list>
    </v-menu>
    <v-btn flat @click="login" v-else>
      Login with Github
    </v-btn>
  </v-toolbar>
</template>

<script lang='ts'>
import Vue from 'vue'
import { User } from '../models/user'
import { 
  onLogin, 
  onLogout, 
  login, 
  logout,
  isLoggedIn,
  currentUser,
} from '../util/auth'

export default Vue.extend({
  created() {
    onLogin(() => {
      this.loggedIn = true
      this.currentUser = currentUser()
    })
    onLogout(() => {
      this.loggedIn = false
      this.currentUser = currentUser()
    })
  },
  data() {
    return {
      loggedIn: isLoggedIn(),
      currentUser: currentUser()
    }
  },
  computed: {
    isLoggedIn() : boolean {
      return this.loggedIn
    }
  },
  methods: {
    toggleDrawer() {
      this.$emit('toggleDrawer')
    },
    async login() {
      if (this.isLoggedIn) {
        return
      }

      try {
        await login()
      } catch(err) {
        console.log(`There was a problem logging in:`, err)
      }
    },
    logout() {
      logout()
    }
  }
})
</script>

