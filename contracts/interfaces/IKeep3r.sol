// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

interface IKeep3r {
    function isKeeper(address) external view returns (bool);
    function workReceipt(address keeper, uint amount) external;
}