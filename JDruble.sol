// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract JDR {
    uint256 totalSupply;
    address public owner;

    // struct JDruble {
    // }

    mapping (address => uint256) public balances;

    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    event Minted(address who, uint256 amount);

    constructor() {
        owner = msg.sender;
    }
    
    function mint(uint256 amount) public isOwner {
        totalSupply += amount;
        balances[msg.sender] += amount;
        emit Minted(msg.sender, amount);
    }
    
    function transfer(address receiver, uint256 amount) public {
        require(amount>0, 'Must be great than 0');
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[receiver] += amount;
    }



}