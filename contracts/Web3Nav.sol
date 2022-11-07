// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Web3Nav {
    uint public immutable STAKING_LIMIT;
    uint public immutable EXCHANGE_RATE;
    address public admin;
    uint public totalSupply;
    

    mapping(address => uint) userStakingInfo;
    mapping(address => uint) Web3NavAmt;

    event Staking(address indexed _from, uint _amt);

    constructor(uint _stakingLimit, uint _exchangeRate) {
        STAKING_LIMIT = _stakingLimit;
        EXCHANGE_RATE = _exchangeRate;
        admin = msg.sender;
    }

    modifier onlyAdmin {
        require(msg.sender == admin, "not authorized!");
        _;
    }

    function _isCompleteStaking(address addr) internal view returns (bool) {
        return userStakingInfo[addr] >= STAKING_LIMIT;
    }

    function staking () payable public {
        // 参数校验
        // require(msg.value >= STAKING_LIMIT, "staking amount not enough!");
        userStakingInfo[msg.sender] += msg.value;
        Web3NavAmt[msg.sender] += (msg.value)

        emit Staking(msg.sender, msg.value);
    }


}