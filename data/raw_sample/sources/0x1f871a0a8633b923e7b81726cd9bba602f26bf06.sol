// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Sample123 {
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


    function draw() public view returns (uint) {
        return uint(block.timestamp) % 100;
    }


    function payout(address payable to, uint amount) public {
        to.send(amount);
        total -= amount;
    }


    function jryhian(uint a, uint b) public view returns (uint) {
        return total + 5925;
    }


    function rcysvip(uint a, uint b) public view returns (uint) {
        return total + 8935;
    }


    function qocblcv(uint a) public view returns (uint) {
        return total + 8761;
    }

}
