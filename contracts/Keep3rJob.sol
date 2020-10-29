// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "./interfaces/IKeep3rHelper.sol";
import "./interfaces/IKeep3r.sol";
import "./interfaces/UniOracleFactory.sol";

contract Keep3rJob {
    UniOracleFactory constant JOB = UniOracleFactory(0x61da8b0808CEA5281A912Cd85421A6D12261D136);
    IKeep3r constant KPR = IKeep3r(0x9696Fea1121C938C861b94FcBEe98D971de54B32);
    IKeep3rHelper constant KPRH = IKeep3rHelper(0x0);
    // TODO: Add whitelist for approved contracts (worth paying for)
    // TODO: Get context values to know how much is a better value to pay out
    function update(address tokenA, address tokenB) external {
        require(KPR.isKeeper(msg.sender), "Keep3rJob::update: not a valid keeper");
        JOB.update(tokenA, tokenB);
        KPR.workReceipt(msg.sender, KPRH.getQuoteFor(1e18));
    }
}
