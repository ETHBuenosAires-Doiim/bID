pragma solidity ^0.4.23;

import "../common/SignUtils.sol";
import "./ERC725.sol";
import "./ClaimableIdentity.sol";

/**
 * @title Self sovereign Identity
 * @author Ricardo Guilherme Schmidt (Status Research & Development GmbH) 
 */
contract Identity is ClaimableIdentity, ERC725 {

    uint256 public nonce; //not approved transactions reserve nonce
    address public recovery; //if defined can change salt and add a new key
    uint256 salt; //used for disabling all authorizations at once
    uint256 threshold;

    mapping (bytes32 => Key) keys; //used for quering by other contracts
    mapping (bytes32 => bool) isKeyPurpose; //used for authorization
    mapping (bytes32 => bytes32[]) keysByPurpose; //used for listing

    /// @dev Fallback function accepts Ether transactions.
    /// @dev Fallback function accepts Ether transactions.
    function ()
        external
        payable
    {}

    /**
     * @notice constructor builds identity with provided `_keys` 
     *         or uses `msg.sender` as first MANAGEMENT + ACTION key
     * @param _keys Keys to add
     * @param _purposes `_keys` corresponding purposes
     * @param _types `_keys` corresponding types
     * @param _managerThreshold how much keys needs to sign management calls
     * @param _actorThreshold how much keys need to sign action management calls
     * @param _recoveryContract Option to initialize with recovery defined
     */
    constructor(   
        bytes32[] _keys,
        uint256 _threshold,
        address _recoveryContract
    ) public {
        constructIdentity(
            _keys,
            _threshold,
            _recoveryContract
        );
    }

    /**
     * @dev initialize identity
     * @param _keys array of keys, length need to be greater than zero
     * @param _purposes array of keys's purposes, length need == keys length 
     * @param _types array of key's types, length need == keys length
     * @param _managerThreshold how much managers need to approve self call, need to be at least managers added
     * @param _actorThreshold how much actors need to approve external call
     * @param _recoveryContract optionally initialize with recovery contract
     */
    function constructIdentity(
        bytes32[] _keys,
        uint256 _threshold,
        address _recoveryContract
    )
        internal 
    {
        uint256 _salt = salt;
        uint len = _keys.length;
        require(len > 0);
        uint managersAdded = 0;
        for(uint i = 0; i < len; i++) {
            uint256 _purpose = _purposes[i];
            storeKey(_keys[i], _purpose, _types[i], _salt);
            if(_purpose == MANAGEMENT_KEY) {
                managersAdded++;
            }
        }
        require(_managerThreshold <= managersAdded, "managers added is less then required");
        purposeThreshold[MANAGEMENT_KEY] = _managerThreshold;
        purposeThreshold[ACTION_KEY] = _actorThreshold;
        recovery = _recoveryContract;
    }

    /// @dev Allows to add a new owner to the Safe and update the threshold at the same time.
    /// This can only be done via a Safe transaction.
    /// @param owner New owner address.
    /// @param _threshold New threshold.
    function addKey(bytes32 _key, uint256 _purpose, uint256 _keyType)
        public 
        returns (bool success)
    {
        // Owner address cannot be null.
        require(_key != 0);
        // No duplicate owners allowed.
        require(_keys[owner]);
        owners.push(owner);
        isOwner[owner] = true;
        // Change threshold if threshold was changed.
        if (threshold != _threshold)
            changeThreshold(_threshold);
    }

    /// @dev Allows to remove an owner from the Safe and update the threshold at the same time.
    ///      This can only be done via a Safe transaction.
    /// @param ownerIndex Array index position of owner address to be removed.
    /// @param owner Owner address to be removed.
    /// @param _threshold New threshold.
    function removeOwner(uint256 ownerIndex, address owner, uint8 _threshold)
        public
        onlyWallet
    {
        // Only allow to remove an owner, if threshold can still be reached.
        require(owners.length - 1 >= _threshold);
        // Validate owner address corresponds to owner index.
        require(owners[ownerIndex] == owner);
        isOwner[owner] = false;
        owners[ownerIndex] = owners[owners.length - 1];
        owners.length--;
        // Change threshold if threshold was changed.
        if (threshold != _threshold)
            changeThreshold(_threshold);
    }

    /**
     * @dev store a new key or push purpose of already exists
     * @param _salt current salt
     * @return true if success
     */
    function storeKey(
        bytes32 _key,
        uint256 _purpose,
        uint256 _type,
        uint256 _salt
    ) 
        private
        returns(bool success)
    {
        require(_key != 0);
        require(_purpose != 0);
        require(!keys[_keys]); //cannot add a key already added
        uint256[] memory purposes = new uint256[](1);  //create new array with first purpose
        purposes[0] = _purpose;
        keys[_keys] = Key(_purpose,_type,_key); //add new key
        
        emit KeyAdded(_key, _purpose, _type);
        return true;
    }

    /*
    /// @dev Allows to execute a Safe transaction confirmed by required number of owners.
    /// @param to Destination address of Safe transaction.
    /// @param value Ether value of Safe transaction.
    /// @param data Data payload of Safe transaction.
    /// @param operation Operation type of Safe transaction.
    /// @param v Array of signature V values sorted by owner addresses.
    /// @param r Array of signature R values sorted by owner addresses.
    /// @param s Array of signature S values sorted by owner addresses.
    /// @param _owners List of Safe owners confirming via regular transactions sorted by owner addresses.
    /// @param indices List of indeces of Safe owners confirming via regular transactions.
    function execute(address to, uint256 value, bytes data, Operation operation, uint8[] v, bytes32[] r, bytes32[] s, address[] _owners, uint256[] indices)
        public
    {
        bytes32 transactionHash = getTransactionHash(to, value, data, operation, nonce);
        // There cannot be an owner with address 0.
        address lastOwner = address(0);
        address currentOwner;
        uint256 i;
        uint256 j = 0;
        // Validate threshold is reached.
        for (i = 0; i < threshold; i++) {
            // Check confirmations done with regular transactions or by msg.sender.
            if (indices.length > j && i == indices[j]) {
                require(msg.sender == _owners[j] || isConfirmed[_owners[j]][transactionHash]);
                currentOwner = _owners[j];
                j += 1;
            }
            // Check confirmations done with signed messages.
            else
                currentOwner = ecrecover(transactionHash, v[i-j], r[i-j], s[i-j]);
            require(isOwner[currentOwner]);
            require(currentOwner > lastOwner);
            lastOwner = currentOwner;
        }
        // Delete storage to receive refunds.
        if (_owners.length > 0) {
            for (i = 0; i < _owners.length; i++) {
                if (msg.sender != _owners[i])
                    isConfirmed[_owners[i]][transactionHash] = false;
            }
        }
        // Increase nonce and execute transaction.
        nonce += 1;
        execute(to, value, data, operation);
    }

    function execute(address to, uint256 value, bytes data, Operation operation)
    internal
    {
        if (operation == Operation.Call)
            require(executeCall(to, value, data));
        else if (operation == Operation.DelegateCall)
            require(executeDelegateCall(to, data));
        else {
            address newContract = executeCreate(data);
            require(newContract != 0);
            ContractCreation(newContract);
        }
    }

    function executeCall(address to, uint256 value, bytes data)
        internal
        returns (bool success)
    {
        assembly {
            success := call(not(0), to, value, add(data, 0x20), mload(data), 0, 0)
        }
    }

    function executeDelegateCall(address to, bytes data)
        internal
        returns (bool success)
    {
        assembly {
            success := delegatecall(not(0), to, add(data, 0x20), mload(data), 0, 0)
        }
    }

    function executeCreate(bytes data)
        internal
        returns (address newContract)
    {
        assembly {
            newContract := create(0, add(data, 0x20), mload(data))
        }
    }
    */
}
