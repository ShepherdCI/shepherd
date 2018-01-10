import Vue from 'vue'
import Vuetify from 'vuetify'

Vue.use(Vuetify)

import App from './App.vue'
import router from './router'

export default  new Vue({
  router,
  render: h => h(App)
})