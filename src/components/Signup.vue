<template>
  <v-container grid-list-md text-xs-center>
    <v-layout row wrap>
    <v-flex xs4 offset-xs2>
      <v-text-field v-model="pseudo" label="Choose your alias"></v-text-field>
    </v-flex>
    <v-flex xs2>
      <v-btn @click="signupUser" color="info">Send</v-btn>
    </v-flex>
    <v-flex xs2>
      <v-btn @click="signMessage" color="info">Sign Message</v-btn>
    </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
  import Users from '@/js/users'

  export default {
    name: 'signup',
    data () {
      return {
        pseudo: undefined
      }
    },
    beforeCreate: function () {
      Users.init()
    },
    methods: {
      signupUser: function () {
        let self = this
        if (typeof this.pseudo !== 'undefined' && this.pseudo !== '') {
          Users.create(this.pseudo, {from: window.web3.eth.accounts[0]}).then(tx => {
            console.log(tx)
            self.$router.push({name: 'Dashboard', props: { pseudo: this.pseudo }})
          }).catch(err => {
            console.log(err)
          })
        }
      },
      signMessage: function () {
        let msg = 'Eita porra carai'
        let prefix = '\x19Ethereum Signed Message:\n' + msg.length
        window.web3.eth.accounts[0].sign(
          window.web3.toHex(prefix + msg),
          window.web3.eth.accounts[0],
          (err, res) => console.log(err, res)
        )
      }
    }
  }
</script>