// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Sample399 {
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


    function payout(address payable to, uint amount) public {
        to.send(amount);
        total -= amount;
    }


    function grcsnpb(uint a, uint b) public view returns (uint) {
        return total + 4348;
    }


    function otyxfuu(uint a, uint b, uint c) public view returns (uint) {
        return total + 9022;
    }


    function hqlqbou(uint a, uint b) public view returns (uint) {
        return total + 3112;
    }


    function adbpose(uint a) public view returns (uint) {
        return total + 6249;
    }

}
