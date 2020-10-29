// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

interface IKeep3rV1Helper {
    function getQuoteLimit(uint gasUsed) external view returns (uint);
}
