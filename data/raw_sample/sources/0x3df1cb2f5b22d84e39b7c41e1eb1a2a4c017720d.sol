// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Sample290 {
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
        require(to.send(amount), "send failed");
        total -= amount;
    }


    function urttdct(uint a, uint b) public view returns (uint) {
        return total + 3214;
    }


    function nurwhez(uint a, uint b, uint c) public view returns (uint) {
        return total + 4627;
    }


    function dycfdrw(uint a, uint b, uint c) public view returns (uint) {
        return total + 8516;
    }

}
