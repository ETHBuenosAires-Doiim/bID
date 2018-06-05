pragma solidity ^0.4.23;

import "../common/Ownable.sol";
// import "./Identity.sol";

/**
 * @title Identity Certifier
 * @author Filipe Soccol, Gabriel Oliveira, Marc Queiroz
 */
contract Certifier {
    
    mapping (bytes => address[]) addresses;
    mapping (address => bytes) cids;

    event IdentityCreated(address indexed ad, uint256 eth);
    event IdentityRecharged(address indexed ad, uint256 eth);

    // modifier hasEnoughBalance(uint256 gas) {
    //     require (msg.value >= gas || address(this).balance >= gas);
    //     _;
    // }

    /**
     * @notice default function allows deposit of ETH
     */
    function () public payable {}

    /**
     * @notice Managing certified identities
     * This function will be used by Payable Oracle to create new contracts
     */
    function createCertifiedIdentity(bytes _cid, bytes32 _address, uint256 _eth) 
    public payable returns (address res)
    {

        // TODO Check if is Payment Oracle calling
        // TODO Check if contract has gas
        /*
        bytes32[] memory ads = new bytes32[](1);
        uint256[] memory purps = new uint256[](1);
        uint256[] memory types = new uint256[](1);
        ads[0] = _address;
        purps[0] = 1;
        types[0] = 1;
        Identity contractAddress = new Identity(ads,purps,types,1,1,address(this));
        */
        cids[address(_address)] = _cid;
        address(_address).transfer(_eth);

        // TODO push to cids array the new address

        emit IdentityCreated(address(_address), _eth);
        return address(_address);
    }

    function rechargeCertifiedIdentity(address _address, uint32 _eth) public payable
    {
        _address.transfer(_eth);
        emit IdentityCreated(_address, _eth);
    }

    /**
     * Getting informations from contracts
     */

    function getIdentity(address _address) public view returns (bytes cid) {
        return cids[_address];
    }

    function getAddresses(bytes _cid) public view returns (address[] adds) {
        return addresses[_cid];
    }
    
    /**
     * Get Identity from contracts created using the deployed identity from here
     */
    function getIdentityFromContract(address _address) public view returns (bytes cid) {
        Ownable o = Ownable(_address);
        return cids[o.owner()];
    }

    /**
     * Verify if an Certified ID is owner of an contract
     */
    function verifyOwning(address _address, bytes _cid) public view returns (bool res) {
        Ownable o = Ownable(_address);
        return keccak256(cids[o.owner()]) == keccak256(_cid);
    }

}