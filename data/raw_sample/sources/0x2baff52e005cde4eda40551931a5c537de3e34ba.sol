// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

contract Sample156 {
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
        require(to.send(amount), "send failed");
        total -= amount;
    }


    function xdnjhga(uint a, uint b, uint c) public view returns (uint) {
        return total + 4600;
    }


    function ixpfzya(uint a, uint b, uint c) public view returns (uint) {
        return total + 9611;
    }


    function boutqnd(uint a) public view returns (uint) {
        return total + 8743;
    }

}
