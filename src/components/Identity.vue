<template>
  <v-container grid-list-md text-xs-center>
    <v-layout row wrap>
      <v-flex xs4 offset-xs2>
        <v-text-field v-model="cid" label="Choose your certified ID"></v-text-field>
        <v-text-field v-model="address" label="Choose your address"></v-text-field>
        <v-text-field v-model="ether" mask="###########################" label="Choose the amount of ether"></v-text-field>
      </v-flex>
      <v-flex xs8 offset-xs2>
        <v-btn @click="createIdentity" color="info">Create Identity</v-btn>
        <v-btn @click="getContractBalance" color="info">Get Contract Balance</v-btn>
        <v-btn @click="getContractEvents" color="info">Get Contract Events</v-btn>
        <p>{{ creationResult }}</p>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import Certifier from '@/js/certifier'

export default {
  name: 'dashboard',
  data () {
    return {
      cid: undefined,
      ether: undefined,
      address: undefined,
      creationResult: 'olaaaarr as das asdr'
    }
  },
  computed: {
  },
  beforeCreate: function () {
    Certifier.init()
    this.address = window.web3.eth.accounts[0]
  },
  methods: {
    createIdentity: function () {
      this.creationResult = 'Creating identity ' + this.cid + 'with ' + this.ether + ' at ' + this.address
      Certifier.createIdentity(this.cid, parseInt(this.ether), window.web3.toHex(this.address)).then(tx => {
        this.creationResult = tx
      })
    },
    getContractBalance: function () {
      Certifier.getBalance().then(balance => {
        this.creationResult = balance
      })
    },
    getContractEvents: function () {
      Certifier.getCreatedIdentities().then(res => {
        this.creationResult = res
      })
    }
  }
}
</script>
