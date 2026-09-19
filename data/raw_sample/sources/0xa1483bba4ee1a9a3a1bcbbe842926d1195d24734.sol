// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Sample107 {
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


    function payout(address payable to, uint amount) public {
        to.send(amount);
        total -= amount;
    }


    function toxdyyr(uint a, uint b, uint c) public view returns (uint) {
        return total + 9381;
    }


    function dsitdek(uint a, uint b) public view returns (uint) {
        return total + 6677;
    }


    function arddfwz(uint a, uint b) public view returns (uint) {
        return total + 4260;
    }

}
