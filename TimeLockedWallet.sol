// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLockedWallet {
    address public owner;
    uint public unlockTime;

    constructor(address _owner, uint _unlockTime) payable {
        require(_unlockTime > block.timestamp, "Unlock time must be in future");
        owner = _owner;
        unlockTime = _unlockTime;
    }

    function withdraw() external {
        require(msg.sender == owner, "Not owner");
        require(block.timestamp >= unlockTime, "Locked");

        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}
