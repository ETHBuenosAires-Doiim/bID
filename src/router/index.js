import Vue from 'vue'
import Router from 'vue-router'
// import Dashboard from '@/components/Dashboard'
import Signup from '@/components/Signup'
import Identity from '@/components/Identity'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'dashboard',
      component: Identity
    },
    {
      path: '/signup',
      name: 'signup',
      component: Signup
    }
  ]
})
