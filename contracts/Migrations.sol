// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Migrations {
    address public owner;
    uint public last_completed_migration;

    // Modern Solidity versions don't require visibility for constructors because 
    // it's assumed they are public and cannot be external.
    constructor() public{
        owner = msg.sender;
    }

    // In Solidity versions >=0.4.22, function visibility (public, private, internal, external)
    // must be explicitly stated. 'restricted' is a custom modifier affecting other functions.
    modifier restricted() {
        require(msg.sender == owner, "This function is restricted to the contract's owner");
        _;
    }

    // Explicitly marking functions with visibility is good practice and required 
    // in newer versions of Solidity.
    function setCompleted(uint completed) public restricted {
        last_completed_migration = completed;
    }

    // Using 'public' visibility, ensuring this function can be called externally.
    function upgrade(address new_address) public restricted {
        Migrations upgraded = Migrations(new_address);
        upgraded.setCompleted(last_completed_migration);
    }
}
