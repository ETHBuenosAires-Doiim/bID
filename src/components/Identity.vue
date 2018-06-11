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
import Signer from '@/js/signer'
import aes256 from 'aes256'

export default {
  name: 'dashboard',
  data () {
    return {
      cid: undefined,
      ether: undefined,
      address: undefined,
      creationResult: '',
      keymsg: 'This sign will be used as key to encrypt your new identity and will not be stored.'
    }
  },
  computed: {
  },
  beforeCreate: function () {
    Certifier.init()
    Signer.init()
  },
  methods: {
    createIdentity: function () {
      this.creationResult = 'Creating identity ' + this.cid + ' with ' + this.ether + ' at ' + window.web3.eth.accounts[0]
      Certifier.createIdentity(this.cid, parseInt(this.ether), window.web3.toHex(window.web3.eth.accounts[0]))
      .then(tx => {
        this.creationResult = tx
        this.getSignedKey().then(key => {
          var plaintext = 'my plaintext message'
          var encrypted = aes256.encrypt(key, plaintext)
          console.log(encrypted)
        }).catch(err => {
          this.creationResult = 'ERROR signing message to create key. ' + err
        })
      })
      .catch(err => {
        this.creationResult = 'ERROR creating new identity. ' + err
      })
      // TODO - Open localStorage
      // TODO - Ask to sign a message that will be the key to decrypt
      // TODO - Decrypt data from local storage
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
    },
    getSignMessage: function () {
      Signer.signMessage(this.cid).then(res => {
        this.creationResult = res
      })
    },
    getSignedKey: function () {
      return new Promise((resolve, reject) => {
        // let prefix = '\x19Ethereum Signed Message:\n' + this.keymsg.length
        let prefix = ''
        window.web3.personal.sign(
          window.web3.toHex(prefix + this.keymsg),
          window.web3.eth.accounts[0],
          (err, res) => {
            if (err) {
              this.creationResult = 'ERROR: ' + res
              reject()
            } else {
              this.creationResult = 'Sign acquired successfully!'
              resolve(res)
            }
          }
        )
      })
    }
  }
}
</script>
