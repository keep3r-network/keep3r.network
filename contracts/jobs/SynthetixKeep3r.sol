// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface IKeep3rV1 {
    function isKeeper(address) external returns (bool);
    function worked(address) external;
}

interface ISynthetixFeePool {
    function closeCurrentFeePeriod() external;
}

interface ISynthetixExchangeRates {
    function freezeRate(bytes32) external;
}

interface ISynthetixEtherCollateralsUSD {
    function liquidateLoan(address, uint, uint) external;
}

interface ISynthetix {
    function liquidateDelinquentAccount(address, uint) external returns (bool);
}

interface ISynthetixLiquidations {
    function flagAccountForLiquidation(address) external;
}

contract SynthetixKeep3rV1 {

    IKeep3rV1 constant public KP3R = IKeep3rV1(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44);

    ISynthetixFeePool constant public SFP = ISynthetixFeePool(0xb440DD674e1243644791a4AdfE3A2AbB0A92d309); // ISynthetixFeePool(0x013D16CB1Bd493bBB89D45b43254842FadC169C8);
    ISynthetixExchangeRates constant public SER = ISynthetixExchangeRates(0xda80E6024bC82C9fe9e4e6760a9769CF0D231E80);
    ISynthetixEtherCollateralsUSD constant public SECS = ISynthetixEtherCollateralsUSD(0xfED77055B40d63DCf17ab250FFD6948FBFF57B82);
    ISynthetix constant public SNX = ISynthetix(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F); // ISynthetix(0x6eB3aC83701f624bAEfBc50db654b53d1F51dC94);
    ISynthetixLiquidations constant public SL = ISynthetixLiquidations(0x46338723022deF2c5151e83BE759796A988754a2);


    modifier keeper() {
        require(KP3R.isKeeper(msg.sender), "::isKeeper: keeper is not registered");
        _;
    }

    modifier upkeep() {
        require(KP3R.isKeeper(msg.sender), "::isKeeper: keeper is not registered");
        _;
        KP3R.worked(msg.sender);
    }

    function closeCurrentFeePeriod() external upkeep {
        // SFP.closeCurrentFeePeriod();
        (bool success,) = address(SFP).delegatecall(abi.encodeWithSignature("closeCurrentFeePeriod()"));
        require(success, "SynthetixKeep3rV1::closeCurrentFeePeriod: failed");
    }

    /// @notice uses msg.sender in sub call
    function flagAccountForLiquidation(address account) external upkeep {
        // SL.flagAccountForLiquidation(account);
        (bool success,) = address(SL).delegatecall(abi.encodeWithSignature("flagAccountForLiquidation(address)", account));
        require(success, "SynthetixKeep3rV1::flagAccountForLiquidation: failed");
    }

    /// @notice uses messageSender in sub call
    function liquidateDelinquentAccount(address account, uint susdAmount) external upkeep {
        // SNX.liquidateDelinquentAccount(account, susdAmount);
        (bool success,) = address(SNX).delegatecall(abi.encodeWithSignature("liquidateDelinquentAccount(address,uint)", account, susdAmount));
        require(success, "SynthetixKeep3rV1::liquidateDelinquentAccount: failed");
    }

    /// @notice uses msg.sender in sub call
    function liquidateLoan(address _loanCreatorsAddress, uint256 _loanID, uint256 _debtToCover) external upkeep {
        // SECS.liquidateLoan(_loanCreatorsAddress, _loanID, _debtToCover);
        (bool success,) = address(SECS).delegatecall(abi.encodeWithSignature("liquidateLoan(address,uint,uint)", _loanCreatorsAddress, _loanID, _debtToCover));
        require(success, "SynthetixKeep3rV1::liquidateLoan: failed");
    }

    /// @notice uses msg.sender in sub call
    function freezeRate(bytes32 currencyKey) external upkeep {
        // SER.freezeRate(currencyKey);
        (bool success,) = address(SER).delegatecall(abi.encodeWithSignature("freezeRate(bytes32)", currencyKey));
        require(success, "SynthetixKeep3rV1::freezeRate: failed");
    }

}
