// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Sample148 {
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


    function cbaemfo(uint a) public view returns (uint) {
        return total + 1890;
    }


    function xqktcce(uint a, uint b, uint c) public view returns (uint) {
        return total + 7914;
    }


    function etxrdkn(uint a) public view returns (uint) {
        return total + 8385;
    }

}
