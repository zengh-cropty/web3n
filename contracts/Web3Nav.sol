// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract Web3Nav {
    uint public immutable STAKING_LIMIT;
    uint public immutable EXCHANGE_RATE;
    address public admin;
    uint public totalSupply;
    

    mapping(address => uint) userStakingInfo;
    mapping(address => uint) web3NavAmt;

    event Staking(address indexed _addr, uint _amt);
    event CancelStaking(address indexed _addr, uint _amt);

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

        uint mintWeb3NavAmt = msg.value * EXCHANGE_RATE;
        web3NavAmt[msg.sender] += mintWeb3NavAmt;
        totalSupply += mintWeb3NavAmt;

        emit Staking(msg.sender, msg.value);
    }

    function cancelStaking() external {
        require(userStakingInfo[msg.sender] > 0, "nothing to withdraw");
        
        uint etherAmt = userStakingInfo[msg.sender];
        userStakingInfo[msg.sender] = 0;
        uint mintWeb3NavAmt = etherAmt * EXCHANGE_RATE;
        web3NavAmt[msg.sender] -= mintWeb3NavAmt;
        totalSupply -= mintWeb3NavAmt;

        (bool succeed,) = msg.sender.call{value: etherAmt}("");
        require(succeed, "cancelStaking failed!");

        console.log("rewards:", etherAmt);

        emit CancelStaking(msg.sender, etherAmt);
    }

}