import contract from 'truffle-contract'
import SignUtils from '@contracts/SignUtils.json'

const Signer = {

  contract: null,
  instance: null,

  init: function () {
    let self = this

    return new Promise(function (resolve, reject) {
      self.contract = contract(SignUtils)
      self.contract.setProvider(window.web3.currentProvider)
      self.contract.deployed().then(instance => {
        self.instance = instance
        resolve()
      }).catch(err => {
        reject(err)
      })
    })
  },

  signMessage: function (message) {
    let self = this

    return new Promise((resolve, reject) => {
      console.log(self.instance.getSignHash)
      console.log(window.web3.sha3(message))
      self.instance.getSignHash(window.web3.sha3(message), {from: '0x627306090abab3a6e1400e9345bc60c78a8bef57'})
      .then(tx => {
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  }
}

export default Signer
