// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample9 {
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


    function yibidbv(uint a, uint b) public view returns (uint) {
        return total + 2440;
    }


    function hinqkgy(uint a, uint b) public view returns (uint) {
        return total + 7009;
    }


    function azyumrr(uint a) public view returns (uint) {
        return total + 1321;
    }


    function bxnotye(uint a, uint b, uint c) public view returns (uint) {
        return total + 4690;
    }

}
