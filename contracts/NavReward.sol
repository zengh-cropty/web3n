
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';

interface ICounter {
    function mint(address, uint256) external;
}

contract GenericLargeResponse is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    bytes32 private immutable jobId;
    uint256 private constant fee = (1 * LINK_DIVISIBILITY) / 10;
    address public contractAdd;
    
    mapping(bytes32 => address) private recipient;
    mapping(address => uint) private hasMintRedNum;

    event RequestVolume(bytes32 indexed requestId, uint256 volume);

    constructor(address _coin) ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        setChainlinkOracle(0x40193c8518BB267228Fc409a613bDbD8eC5a97b3);
        jobId = 'ca98366cc7314957b8c012c72f05aeeb';
    
        contractAdd = _coin;
    }

    
    function requestVolumeData() public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        req.add('get', 'http://43.154.22.73:8080/user/sumClickCount?userWalletAddress=' + msg.sender);
        req.add('path', 'data');
        req.addInt('times', 1);

        bytes32 _requestIds = sendChainlinkRequest(req, fee);
        recipient[_requestIds] = msg.sender;
        return _requestIds;
    }

    function fulfill(bytes32 _requestId, uint256 _volume) public recordChainlinkFulfillment(_requestId) {
        emit RequestVolume(_requestId, _volume);

        require(_volume >= 0, "readNum not >= 0");
        uint availableMintReadNum = _volume - hasMintRedNum[msg.sender];
        require(availableMintReadNum >= 10, "availableMintReadNum not >= 10");
        uint mintCoinNum = availableMintReadNum / 10;
        hasMintRedNum[msg.sender] += mintCoinNum * 10;

        ICounter(contractAdd).mint(recipient[_requestId], mintCoinNum * LINK_DIVISIBILITY);
    }
}

