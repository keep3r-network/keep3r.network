// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

interface DelegateInterface {
    function getPriorVotes(address account, uint blockNumber) external view returns (uint);
    function totalBonded() external view returns (uint);
}