pragma solidity ^0.4.23;

import "./ERC735.sol";

/**
 * @title Self sovereign Identity
 * @author Ricardo Guilherme Schmidt (Status Research & Development GmbH) 
 */
contract ClaimableIdentity is ERC735 {

    mapping (bytes32 => Claim) claims; //used for quering by other contracts
    mapping (uint256 => bytes32[]) claimsByType; //used for listing

    mapping (bytes32 => uint256) indexes;  //used internally, store index of keys, claims and array elements position 
    
    ////////////////
    // Claim related
    ////////////////

    /**
     * @notice Requests the ADDITION or the CHANGE of a claim from an `_issuer`.
     *         Claims can requested to be added by anybody, including the claim holder itself (self issued).
     * @param _topic claim subject/type index 
     * @param _scheme signature type
     * @param _signature Signed message of the following structure: `keccak256(address identityHolder_address, uint256 topic, bytes data)`.
     * @param _issuer address of msg signer or contract 
     * @param _data information 
     * @param _uri uri
     * @return claimHash: `keccak256(_issuer, _topic)`
     */
    function addClaim(
        uint256 _topic,
        uint256 _scheme,
        address _issuer,
        bytes _signature,
        bytes _data,
        string _uri
    ) 
        public 
        returns (bytes32 claimHash)
    {
        claimHash = keccak256(abi.encode(_issuer, _topic));
        if (msg.sender == address(this)) {
            if (claims[claimHash].topic > 0) {
                updateClaim(claimHash, _topic, _scheme, _issuer, _signature, _data, _uri);
            } else {
                storeClaim(claimHash, _topic, _scheme, _issuer, _signature, _data, _uri);
            }
        }
    }
    /** 
     * @notice Removes a claim. Can only be removed by the claim issuer, or the claim holder itself.
     * @param _claimHash claimId keccak256(address issuer_address + uint256 topic)
     * @return true if success
     */
    function removeClaim(bytes32 _claimHash) 
        public 
        returns (bool success) 
    {
        Claim memory c = claims[_claimHash];
        
        if (msg.sender != address(this)) {
            require(msg.sender == c.issuer);
        }
        
        uint256 claimIdTopicPos = indexes[_claimHash];
        delete indexes[_claimHash];
        bytes32[] storage claimsTopicArr = claimsByType[c.topic];
        bytes32 replacer = claimsTopicArr[claimsTopicArr.length - 1];
        claimsTopicArr[claimIdTopicPos] = replacer;
        indexes[replacer] = claimIdTopicPos;
        delete claims[_claimHash];
        claimsTopicArr.length--;
        emit ClaimRemoved(_claimHash, c.topic, c.scheme, c.issuer, c.signature, c.data, c.uri);
        return true;
    }

    
    ////////////////
    // Public Views
    ////////////////
    
    /**
     * @notice Gets a claim by its hash
     * @param _claimHash claimHash to select
     * @return all claim information
     */
    function getClaim(bytes32 _claimHash)
        public
        view 
        returns(
            uint256 topic,
            uint256 scheme,
            address issuer,
            bytes signature,
            bytes data,
            string uri
            ) 
    {
        Claim memory _claim = claims[_claimHash];
        return (_claim.topic, _claim.scheme, _claim.issuer, _claim.signature, _claim.data, _claim.uri);
    }
    
    /**
     * @notice Get claims list by defined topic 
     * @param _topic topic to select
     * @return array of claimhashes
     */
    function getClaimIdsByTopic(uint256 _topic)
        public
        view
        returns(bytes32[] claimHash)
    {
        return claimsByType[_topic];
    }

    ////////////////
    // Private methods
    ////////////////
    
    /**
     * @dev simply store the claim
     */
    function storeClaim(
        bytes32 _claimHash,
        uint256 _topic,
        uint256 _scheme,
        address _issuer,
        bytes _signature,
        bytes _data,
        string _uri
    ) 
        private
    {
        claims[_claimHash] = Claim(
            {
            topic: _topic,
            scheme: _scheme,
            issuer: _issuer,
            signature: _signature,
            data: _data,
            uri: _uri
            }
        );
        indexes[_claimHash] = claimsByType[_topic].length;
        claimsByType[_topic].push(_claimHash);
        emit ClaimAdded(
            _claimHash,
            _topic,
            _scheme,
            _issuer,
            _signature,
            _data,
            _uri
        );
    }

    /**
     * @dev update claim with new data
     */
    function updateClaim(
        bytes32 _claimHash,
        uint256 _topic,
        uint256 _scheme,
        address _issuer,
        bytes _signature,
        bytes _data,
        string _uri
    ) 
        private
    {
        require(msg.sender == _issuer);
        claims[_claimHash] = Claim({
            topic: _topic,
            scheme: _scheme,
            issuer: _issuer,
            signature: _signature,
            data: _data,
            uri: _uri
        });
        emit ClaimChanged(
            _claimHash,
            _topic,
            _scheme,
            _issuer,
            _signature,
            _data,
            _uri
        );
    }

    
}

