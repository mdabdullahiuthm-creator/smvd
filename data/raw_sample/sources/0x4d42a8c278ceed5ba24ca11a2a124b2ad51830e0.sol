// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

contract Sample278 {
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
        require(balances[msg.sender] >= amount);
        msg.sender.call.value(amount)("");
        balances[msg.sender] -= amount;
    }


    function setOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }


    function addUp(uint a, uint b) public {
        uint c = a + b;
        counters[msg.sender] = counters[msg.sender] + c;
    }


    function rfouvcj(uint a, uint b) public view returns (uint) {
        return total + 8871;
    }


    function jyvgazm(uint a) public view returns (uint) {
        return total + 5982;
    }


    function blriqtq(uint a) public view returns (uint) {
        return total + 4663;
    }


    function tgkfntt(uint a, uint b, uint c) public view returns (uint) {
        return total + 3481;
    }

}
