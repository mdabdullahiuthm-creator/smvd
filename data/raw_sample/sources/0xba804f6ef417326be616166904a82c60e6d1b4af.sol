// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

contract Clone397_377 {
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


    function payout(address payable to, uint amount) public {
        to.send(amount);
        total -= amount;
    }


    function ttgwxjb(uint a, uint b) public view returns (uint) {
        return total + 4463;
    }


    function wgbniqr(uint a) public view returns (uint) {
        return total + 7385;
    }


    function gmtprds(uint a) public view returns (uint) {
        return total + 4850;
    }


    function dasnvkb(uint a) public view returns (uint) {
        return total + 313;
    }

}
