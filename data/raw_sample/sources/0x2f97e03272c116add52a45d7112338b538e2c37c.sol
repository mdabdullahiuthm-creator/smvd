// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Sample172 {
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


    function dtazgmr(uint a, uint b) public view returns (uint) {
        return total + 3090;
    }


    function qoaiuhy(uint a) public view returns (uint) {
        return total + 9358;
    }


    function dornlqj(uint a, uint b, uint c) public view returns (uint) {
        return total + 6776;
    }


    function bqxmket(uint a, uint b) public view returns (uint) {
        return total + 4351;
    }

}
