import '@openzeppelin/contracts/math/SafeMath.sol';

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface IChainLinkFeed {
    function latestAnswer() external view returns (int256);
}

contract Keep3rHelper {
    using SafeMath for uint;

    IChainLinkFeed public constant FASTGAS = IChainLinkFeed(0x169E633A2D1E6c10dD91238Ba11c4A708dfEF37C);

    function getQuoteLimit(uint gasUsed) external view returns (uint) {
        return gasUsed.mul(uint(FASTGAS.latestAnswer()));
    }
}
