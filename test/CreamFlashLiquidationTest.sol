pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./script.sol";
import "./CreamFlashLiquidation.sol";

contract CreamFlashLiquidationTest is script {

    CreamFlashLiquidate private CFL;
    ERC20Like private WETH9 = ERC20Like(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);


	function run() public {
	    run(this.work).withCaller(0x9f6FdC2565CfC9ab8E184753bafc8e94C0F985a0);
	}

    function work() external {
        CFL = new CreamFlashLiquidate();

        CFL.liquidate(0xe024A6d8B1A76C746F0E42546BBa6A52a74769Ec   , 0x797AAB1ce7c01eB727ab980762bA88e7133d2157, 0x797AAB1ce7c01eB727ab980762bA88e7133d2157);
    }
}
