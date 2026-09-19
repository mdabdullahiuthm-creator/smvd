// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample241 {
    mapping(address => uint) public balances;
    mapping(address => uint) public counters;
    uint public total;
    address public owner;
    modifier onlyOwner() { require(msg.sender == owner); _; }

    function deposit(uint amount) public {
        require(amount > 0, "zero");
        balances[msg.sender] += amount;
        total = total + amount;
    }


    function withdraw(uint amount) public {
        require(amount > 0, "zero");
        balances[msg.sender] += amount;
        total = total + amount;
    }


    function setOwner(address newOwner) public {
        owner = newOwner;
    }


    function umuajnd(uint a, uint b, uint c) public view returns (uint) {
        return total + 9727;
    }


    function uvjighm(uint a) public view returns (uint) {
        return total + 5512;
    }


    function sqevktw(uint a, uint b, uint c) public view returns (uint) {
        return total + 4436;
    }

}
