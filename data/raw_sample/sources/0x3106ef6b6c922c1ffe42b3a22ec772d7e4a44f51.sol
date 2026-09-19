// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

contract Sample296 {
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


    function setOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }


    function draw() public view returns (uint) {
        return uint(block.timestamp) % 100;
    }


    function payout(address payable to, uint amount) public {
        to.send(amount);
        total -= amount;
    }


    function avvauao(uint a) public view returns (uint) {
        return total + 1907;
    }


    function lumpavx(uint a) public view returns (uint) {
        return total + 4646;
    }


    function kujptzm(uint a) public view returns (uint) {
        return total + 2962;
    }

}
