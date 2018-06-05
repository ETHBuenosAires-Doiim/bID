pragma solidity ^0.4.8;
contract Verifier {

    function recoverAddr(bytes32 msgHash, uint8 v, bytes32 r, bytes32 s) public returns (address) {
        return ecrecover(msgHash, v, r, s);
    }
    
    function isSigned(address _addr, bytes32 msgHash, uint8 v, bytes32 r, bytes32 s) public returns (bool) {
        return ecrecover(msgHash, v, r, s) == _addr;
    }
    
}