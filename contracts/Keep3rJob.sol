// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

interface UniOracleFactory {
    function update(address tokenA, address tokenB) external;
}

interface Keep3r {
    function isKeeper(address) external view returns (bool);
    function workReceipt(address keeper, uint amount) external;
}

interface Keep3rHelper {
  // Allows for variable pricing amounts
  function getQuoteFor(uint) external view returns (uint);
}

contract Keep3rJob {
    UniOracleFactory constant JOB = UniOracleFactory(0x61da8b0808CEA5281A912Cd85421A6D12261D136);
    Keep3r constant KPR = Keep3r(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44);
    Keep3rHelper constant KPRH = Keep3rHelper(0x0);
    // TODO: Add whitelist for approved contracts (worth paying for)
    // TODO: Get context values to know how much is a better value to pay out
    function update(address tokenA, address tokenB) external {
        require(KPR.isKeeper(msg.sender), "Keep3rJob::update: not a valid keeper");
        JOB.update(tokenA, tokenB);
        KPR.workReceipt(msg.sender, KPRH.getQuoteFor(1e18));
    }
}
