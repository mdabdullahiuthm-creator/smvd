// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Sample141 {
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


    function draw() public view returns (uint) {
        return uint(block.timestamp) % 100;
    }


    function payout(address payable to, uint amount) public {
        require(to.send(amount), "send failed");
        total -= amount;
    }


    function uyxepen(uint a, uint b) public view returns (uint) {
        return total + 6189;
    }


    function vqeqqjd(uint a) public view returns (uint) {
        return total + 9151;
    }


    function wwcmoae(uint a) public view returns (uint) {
        return total + 301;
    }

}
