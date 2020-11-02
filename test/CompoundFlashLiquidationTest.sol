pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./script.sol";
import "./CompoundFlashLiquidation.sol";

contract CompoundFlashLiquidationTest is script {

    CompoundFlashLiquidate private CFL;
    ERC20Like private WETH9 = ERC20Like(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);


	function run() public {
	    run(this.work).withCaller(0x9f6FdC2565CfC9ab8E184753bafc8e94C0F985a0);
	}

    function work() external {
        CFL = new CompoundFlashLiquidate();

        address underlying = CFL.underlying(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
        address pair = CFL.underlyingPair(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
        uint liquidatable = CFL.liquidatable(0x6cE3DfE03066eC06658F6F9585C34C3f71C71fC4, 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);

        fmt.printf("underlying()=%a\n",abi.encode(underlying));
        fmt.printf("pair()=%a\n",abi.encode(pair));
        fmt.printf("liquidatable()=%u\n",abi.encode(liquidatable));

        CFL.liquidate(0x6cE3DfE03066eC06658F6F9585C34C3f71C71fC4, 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643, 0x6C8c6b02E7b2BE14d4fA6022Dfd6d75921D90E4E);
        //CFL.liquidateCalculated(address borrower, IUniswapV2Pair pair, address underlying, uint amount, address borrowed, address supplied)

        /*

        CFL.liquidateCalculated(0x012916eD48b20433B698CB32b488E52C639a2A66, 0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc, 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,72855155,0x39AA39c021dfbaE8faC545936693aC917d5E7563,0x6C8c6b02E7b2BE14d4fA6022Dfd6d75921D90E4E);
        */
    }
}
