// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract Web3NavPool {
    uint public immutable STAKE_LIMIT;
    address public admin;
    uint public totalStake;
    

    mapping(address => uint) userStakeInfo;
    mapping(address => uint) web3NavAmt;

    event Stake(address indexed _addr, uint _amt);
    event UnStake(address indexed _addr, uint _amt);

    struct Read {
        uint readNum;
        uint mintedReadNum;
    }

    constructor(uint _stakeLimit) {
        STAKE_LIMIT = _stakeLimit;
        admin = msg.sender;
    }

    modifier onlyAdmin {
        require(msg.sender == admin, "not authorized!");
        _;
    }


    function _isCompleteStake(address addr) internal view returns (bool) {
        return userStakeInfo[addr] >= STAKE_LIMIT;
    }

    function stake() payable public {
        // 参数校验
        require(msg.value >= STAKE_LIMIT, "stake amount not enough!");
        userStakeInfo[msg.sender] += msg.value;
        totalStake += msg.value;

        emit Stake(msg.sender, msg.value);
    }

    function unStake() external {
        uint etherAmt = userStakeInfo[msg.sender];
        userStakeInfo[msg.sender] = 0;
        totalStake -= etherAmt;
        require(etherAmt > 0, "nothing to withdraw");
        
        (bool succeed,) = msg.sender.call{value: etherAmt}("");
        require(succeed, "cancelStaking failed!");

        console.log("unStake:", etherAmt);

        emit UnStake(msg.sender, etherAmt);
    }

    function getStakingAmt() external view returns (uint) {
        return userStakeInfo[msg.sender];
    }

}