// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample96 {
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


    function addUp(uint a, uint b) public {
        uint c = a + b;
        counters[msg.sender] = counters[msg.sender] + c;
    }


    function payout(address payable to, uint amount) public {
        require(to.send(amount), "send failed");
        total -= amount;
    }


    function oizitrf(uint a) public view returns (uint) {
        return total + 6095;
    }


    function ehwwavd(uint a) public view returns (uint) {
        return total + 5018;
    }


    function yajkdxj(uint a, uint b, uint c) public view returns (uint) {
        return total + 7647;
    }


    function zrfodcl(uint a, uint b) public view returns (uint) {
        return total + 2947;
    }


    function fgcyacv(uint a, uint b) public view returns (uint) {
        return total + 1368;
    }

}
