// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import Web3 from 'web3'
import router from './router'
import Vuetify from 'vuetify'
import 'vuetify/dist/vuetify.min.css'
import 'material-design-icons-iconfont/dist/material-design-icons.css'

Vue.config.productionTip = false

Vue.use(Vuetify, {
  theme: {
    primary: '#60903f',
    info: '#7bba4f',
    accent: '#8c9eff',
    error: '#b71c1c'
  }
})

window.addEventListener('load', function () {
  if (typeof web3 !== 'undefined') {
    console.log('Web3 injected browser: OK.')
    window.web3 = new Web3(window.web3.currentProvider)
  } else {
    console.log('Web3 injected browser: Fail. You should consider trying MetaMask.')
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'))
  }

  /* eslint-disable no-new */
  new Vue({
    el: '#app',
    router,
    template: '<App/>',
    components: { App }
  })
})

