import EmbarkJS from 'Embark/EmbarkJS';
import IdentityCertifier from 'Embark/contracts/IdentityCertifier';
import CertifiedIdentity from 'Embark/contracts/CertifiedIdentity';
import React from 'react';
import { Form, FormGroup, FormControl, Label, HelpBlock, Button } from 'react-bootstrap';
 
class Identity extends React.Component {
    constructor(props) {
        super(props);
    
        this.state = {
          valueSet: 10,
          valueGet: "",
          logs: []
        }
      }
    
      handleChange(e){
        this.setState({valueSet: e.target.value});
      }

      createIdentity(e){
        e.preventDefault();

        // If web3.js 1.0 is being used
        if (EmbarkJS.isNewWeb3()) {
            IdentityCertifier.methods.createCertifiedIdentity(web3.utils.fromAscii("Filipe"), "0x0123", 42)
            .send({from: web3.eth.defaultAccount,value:42})
            .then( (err,res) => {
                console.log(err);
                console.log(res);
                this.state.generatedHash = res;
            });
          //this._addToLog("SimpleStorage.methods.set(value).send({from: web3.eth.defaultAccount})");
        } else {
          SimpleStorage.set(value);
          IdentityCertifier.methods.createCertifiedIdentity(web3.utils.fromAscii("Filipe"), "0x0123", 42).send({value:80000})
            .then( (err,res) => {
                console.log(err);
                console.log(res);
                this.state.generatedHash = res;
            });
          //this._addToLog("#blockchain", "SimpleStorage.set(" + value + ")");
        }
      }
    
      render(){
        return (
        <React.Fragment>
            <h3> Identity Creation </h3>
            <Form inline>
                <FormGroup>
                    <Label>{web3.eth.defaultAccount}</Label>
                    <FormControl
                        type="text"
                        defaultValue={this.state.username}
                        onChange={e => this.handleChange(e, 'username')} />
                    <Button bsStyle="primary" onClick={(e) => this.createIdentity(e)}>Create My Identity</Button>
                    <HelpBlock>generated Hash: <span className="textHash">{this.state.generatedHash}</span></HelpBlock>
                </FormGroup>
            </Form> 
        </React.Fragment>
        );
      }
}

export default Identity;
