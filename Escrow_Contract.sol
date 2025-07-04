// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
    address public buyer;
    address payable public seller;
    address public arbiter;
    bool public buyerApproved;
    bool public sellerApproved;
    uint public amount;

    constructor(address _buyer, address payable _seller, address _arbiter) payable {
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
        amount = msg.value;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer");
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller");
        _;
    }

    modifier onlyArbiter() {
        require(msg.sender == arbiter, "Only arbiter");
        _;
    }

    function approve() external {
        require(msg.sender == buyer || msg.sender == seller, "Only buyer or seller");
        if (msg.sender == buyer) buyerApproved = true;
        if (msg.sender == seller) sellerApproved = true;

        if (buyerApproved && sellerApproved) {
            seller.transfer(amount);
        }
    }

    function refundBuyer() external onlyArbiter {
        payable(buyer).transfer(amount);
    }
}
