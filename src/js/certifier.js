import contract from 'truffle-contract'
import CertifierContract from '@contracts/Certifier.json'

const Certifier = {

  contract: null,
  instance: null,

  init: function () {
    let self = this

    return new Promise(function (resolve, reject) {
      self.contract = contract(CertifierContract)
      self.contract.setProvider(window.web3.currentProvider)

      self.contract.deployed().then(instance => {
        self.instance = instance
        resolve()
      }).catch(err => {
        reject(err)
      })
    })
  },

  createIdentity: function (cid, ether, address) {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.createCertifiedIdentity(
        cid,
        address, // address || window.web3.eth.accounts[0],
        ether,
        {from: window.web3.eth.accounts[0], value: ether}
      ).then(tx => {
        resolve(tx)
      }).catch(err => {
        reject(err)
      })
    })
  },

  getBalance: function () {
    // let self = this
    return new Promise((resolve, reject) => {
      // window.web3.eth.getBalance(self.instance.address, function (err, res) {
      window.web3.eth.getBalance('0xf17f52151ebef6c7334fad080c5704d77216b732', function (err, res) {
        if (err) reject(err)
        resolve(res.toString(10)) // because you get a BigNumber
      })
    })
  },

  getCreatedIdentities: function () {
    let self = this

    return new Promise((resolve, reject) => {
      self.instance.IdentityCreated({}, { fromBlock: 0, toBlock: 'latest' }).get((error, eventResults) => {
        if (error) {
          reject(error)
        } else {
          resolve(eventResults)
        }
      })
    })
  }
}

export default Certifier
