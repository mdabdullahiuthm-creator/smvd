// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Sample112 {
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


    function setOwner(address newOwner) public {
        owner = newOwner;
    }


    function payout(address payable to, uint amount) public {
        to.send(amount);
        total -= amount;
    }


    function htuxhho(uint a, uint b, uint c) public view returns (uint) {
        return total + 6415;
    }


    function qpnruze(uint a) public view returns (uint) {
        return total + 3732;
    }


    function lkccjdp(uint a) public view returns (uint) {
        return total + 7575;
    }

}
