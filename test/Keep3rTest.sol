pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./script.sol";

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface Keep3rLike {
   function setup() external payable;
   function balanceOf(address) external view returns (uint);
   function liquidity() external view returns (address);
}

contract Keep3rTest is script {
    using SafeMath for uint;

    Keep3rLike constant private KPR = Keep3rLike(0x885Db69d8087BC1C2D8Ca31Bdd8fD561D91e6fa7);

	function run() public {
	    run(this.init).withCaller(0x2D407dDb06311396fE14D4b49da5F0471447d45C);
	}

    function init() external {
        fmt.printf("balanceOf=%.18u\n",abi.encode(KPR.balanceOf(address(this))));
        KPR.setup.value(1e18)();
        fmt.printf("liquidity=%a\n",abi.encode(KPR.liquidity()));
    }
}
