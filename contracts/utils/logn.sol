pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./script.sol";

contract REPL is script {

    uint private constant FIXED_1 = 0x080000000000000000000000000000000;
    uint private constant FIXED_2 = 0x100000000000000000000000000000000;
    uint private constant SQRT_1 = 13043817825332782212;
    uint private constant LOG_10_2 = 3010299957;
    uint private constant BASE = 1e10;

    function floorLog2(uint256 _n) internal pure returns (uint8) {
        uint8 res = 0;

        if (_n < 256) {
            // At most 8 iterations
            while (_n > 1) {
                _n >>= 1;
                res += 1;
            }
        } else {
            // Exactly 8 iterations
            for (uint8 s = 128; s > 0; s >>= 1) {
                if (_n >= (uint(1) << s)) {
                    _n >>= s;
                    res |= s;
                }
            }
        }

        return res;
    }

    function generalLog(uint256 x) internal pure returns (uint) {
        uint res = 0;

        // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
        if (x >= FIXED_2) {
            uint8 count = floorLog2(x / FIXED_1);
            x >>= count; // now x < 2
            res = count * FIXED_1;
        }

        // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
        if (x > FIXED_1) {
            for (uint8 i = 127; i > 0; --i) {
                x = (x * x) / FIXED_1; // now 1 < x < 4
                if (x >= FIXED_2) {
                    x >>= 1; // now 1 < x < 2
                    res += uint(1) << (i - 1);
                }
            }
        }

        return res * LOG_10_2 / BASE;
    }

    function sqrt(uint x) internal pure returns (uint y) {
        uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

    function vol(uint[] memory p) internal pure returns (uint x) {
        for (uint8 i = 1; i <= (p.length-1); i++) {
            x += ((generalLog(p[i] * FIXED_1) - generalLog(p[i-1] * FIXED_1)))**2;
            //denom += FIXED_1**2;
        }
        //return (sum, denom);
        x = sqrt(uint(252) * sqrt(x / (p.length-2)));
        return uint(1e18) * x / SQRT_1;
    }

	function run() public {
	    run(this.repl).withCaller(0x9f6FdC2565CfC9ab8E184753bafc8e94C0F985a0);
	}

    function repl() external {

        uint[] memory points = new uint[](12);
        points[0] = 3365048423556510000;
        points[1] = 3366516801778030000;
        points[2] = 3373817387435220000;
        points[3] = 3379320958608430000;
        points[4] = 3382987161136880000;
        points[5] = 3405998172003360000;
        points[6] = 3406484665993710000;
        points[7] = 3408043106034020000;
        points[8] = 3408287499677610000;
        points[9] = 3409044636451580000;
        points[10] = 3412400414311440000;
        points[11] = 3413808337176390000;
        /*

        (uint res1) = generalLog(3365048423556510000 * FIXED_1);
        (uint res2) = generalLog(3366516801778030000 * FIXED_1);

        res1 = res1 * LOG_10_2 / BASE;
        res2 = res2 * LOG_10_2 / BASE;

        uint rt = uint((res2 - res1)**2);

        uint sqrtRT = sqrt(rt);
        uint retVol = uint(252) * sqrtRT;
        uint sqrtRV = sqrt(retVol);
        uint sqrtFIXED_1 = sqrt(FIXED_1);


        uint vol = uint(1e18) * sqrtRV / SQRT_1;
        */
        uint x = vol(points);
        fmt.printf("x=%u\n",abi.encode(x));
    }
}
