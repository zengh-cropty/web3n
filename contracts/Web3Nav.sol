// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Web3Nav {
    uint public immutable STAKING_LIMIT;
    address public admin;

    uint public total


    constructor(uint _stakingLimit) {
        STAKING_LIMIT = _stakingLimit;
        admin = msg.sender;
    }

    modifier onlyAdmin {
        require(msg.sender == admin, "not authorized!");
        _;
    }
}