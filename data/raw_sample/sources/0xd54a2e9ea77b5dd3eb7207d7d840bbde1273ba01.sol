// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Sample388 {
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


    function tsgrafe(uint a, uint b) public view returns (uint) {
        return total + 4368;
    }


    function soizmcy(uint a) public view returns (uint) {
        return total + 8131;
    }


    function vxpwyzj(uint a, uint b, uint c) public view returns (uint) {
        return total + 6035;
    }


    function vvrtxlu(uint a) public view returns (uint) {
        return total + 5895;
    }

}
