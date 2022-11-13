// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./ERC20.sol";

contract Web3Nav is ERC20 {

    // string constant TOKEN_NAME = "Web3Nav";
    // string constant TOKEN_SYMBOL = "nav";

    constructor(
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) {
    }

} 