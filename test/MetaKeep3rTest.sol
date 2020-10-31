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

interface Keep3rV1Like {
   function addVotes(address voter, uint amount) external;
   function addJob(address job) external;
   function addKPRCredit(address job, uint amount) external;
   function isKeeper(address keeper) external returns (bool);
   function worked(address keeper) external;
}

interface MetaKeep3rLike {
    function work(address job) external;
}

contract TestJob {
    Keep3rV1Like constant private KPR = Keep3rV1Like(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44);
    function work() external {
        require(KPR.isKeeper(msg.sender), "TestJob::work(): !keeper");
        KPR.worked(msg.sender);
    }
}

contract MetaKeep3rTest is script {
    using SafeMath for uint;

    Keep3rV1Like constant private KPR = Keep3rV1Like(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44);
    MetaKeep3rLike constant private MK = MetaKeep3rLike(0xEE2330d77c7d920cC70F1d0fBE60eb125C4887ec);
    address private JOB;

	function run() public {
	    run(this.init).withCaller(0x2D407dDb06311396fE14D4b49da5F0471447d45C);
	    run(this.work).withCaller(0x9f6FdC2565CfC9ab8E184753bafc8e94C0F985a0);
	}

    function init() external {
        JOB = address(new TestJob());

        KPR.addVotes(address(MK), 0);

        KPR.addJob(address(MK));
        KPR.addKPRCredit(address(MK),10e18);

        KPR.addJob(JOB);
        KPR.addKPRCredit(JOB,10e18);
    }

    function work() external {
        fmt.printf("JOB=%a\n",abi.encode(JOB));
        MK.work(JOB);
    }
}
