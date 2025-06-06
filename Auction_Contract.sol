// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SimpleAuction {
    address public owner;
    uint public highestBid;
    address public highestBidder;
    bool public ended;

    mapping(address => uint) public pendingReturns;

    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    constructor() {
        owner = msg.sender;
    }

    function bid() public payable {
        require(!ended, "Auction already ended");
        require(msg.value > highestBid, "There already is a higher bid");

        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid; // Refund previous highest bidder
        }
        highestBid = msg.value;
        highestBidder = msg.sender;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        require(amount > 0, "No funds to withdraw");
        pendingReturns[msg.sender] = 0;

        if (!payable(msg.sender).send(amount)) {
            pendingReturns[msg.sender] = amount; // Reset on failure
            return false;
        }
        return true;
    }

    function endAuction() public {
        require(msg.sender == owner, "Only owner can end auction");
        require(!ended, "Auction already ended");

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        payable(owner).transfer(highestBid);
    }
}
