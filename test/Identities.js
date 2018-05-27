config({
  mnemonic: "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat"
})

describe("Identities", function() {
  this.timeout(0);
  before(function(done) {
    this.timeout(0);
    var contractsConfig = {
      "CertifiedIdentity": {
        "deploy": true,

        "args": {
          "_keys": [],
          "_purposes": [],
          "_types": [],
          "_managerThreshold": 1,
          "_actorThreshold": 1
        }
      },
      "IdentityCertifier": {
        "deploy": true
      },
      
    };
    EmbarkSpec.deployAll(contractsConfig, (_accounts) => { 
      accounts = _accounts
      done() 
    });
  });

  it("Should deploy a new instance of Identity", async function() {
    //console.log(web3.utils.fromAscii("Filipe"));
    
    let result = await IdentityCertifier.methods.createCertifiedIdentity(web3.utils.fromAscii("Filipe"), "0x0123", 42).send({value:42});
    
    console.log("CONTRACT CREATED = "+result.events.IdentityCreated.returnValues.ad);
    var identity = new web3.eth.Contract(CertifiedIdentity._jsonInterface, result.events.IdentityCreated.returnValues.ad);
    console.log("PURPOSE SELECTED = "+ await identity.methods.getKeysByPurpose(1).call());

    assert.equal(result.events.IdentityCreated.returnValues.ad, "0x6512a267aD28dFE41a5846E7aD0B2501633cB3f2");
  });

});
