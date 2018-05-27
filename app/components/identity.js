import EmbarkJS from 'Embark/EmbarkJS';
//import SimpleStorage from 'Embark/contracts/SimpleStorage';
import React from 'react';
import { Form, FormGroup, FormControl, HelpBlock, Button } from 'react-bootstrap';
 
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
    
      render(){
        return (<React.Fragment>
            
        </React.Fragment>
        );
      }
}