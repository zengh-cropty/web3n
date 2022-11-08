// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./ERC20.sol";

contract Web3Nav is ERC20 {

    uint8 internal constant DECIMAL_PLACES = 18;

    string constant TOKEN_NAME = "Web3Nav";
    string constant TOKEN_SYMBOL = "nav";

    constructor() ERC20(TOKEN_NAME, TOKEN_SYMBOL) {
        
    }

}