// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

interface UniOracleFactory {
    function update(address tokenA, address tokenB) external;
}