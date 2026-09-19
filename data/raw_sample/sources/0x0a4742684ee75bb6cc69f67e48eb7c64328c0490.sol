// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

contract Sample36 {
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


    function azhcffl(uint a, uint b) public view returns (uint) {
        return total + 3057;
    }


    function ajmrldk(uint a, uint b, uint c) public view returns (uint) {
        return total + 6318;
    }


    function kmucdnl(uint a, uint b, uint c) public view returns (uint) {
        return total + 4014;
    }


    function mgojlhn(uint a) public view returns (uint) {
        return total + 4574;
    }

}
