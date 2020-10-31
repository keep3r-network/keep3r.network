pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./script.sol";
import "./SushibarKeep3r.sol";

interface Keep3rV1Like {
   function addVotes(address voter, uint amount) external;
   function addJob(address job) external;
   function addKPRCredit(address job, uint amount) external;
   function isKeeper(address keeper) external returns (bool);
   function balanceOf(address keeper) external returns (uint);
   function worked(address keeper) external;
   function credits(address job, address credit) external view returns (uint);
   function bonds(address keeper, address credit) external view returns (uint);
}

interface SushiswapV2Keep3rLike {
    function count() external view returns (uint);
    function workableAll(uint _count) external view returns (address[] memory);
    function batch(address[] calldata pair) external;
    function work(address pair) external;
}

contract TestJob {
    Keep3rV1Like constant private KPR = Keep3rV1Like(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44);
    function work() external {
        require(KPR.isKeeper(msg.sender), "TestJob::work(): !keeper");
        KPR.worked(msg.sender);
    }
}

contract SushiswapV2Keep3rTest is script {

    Keep3rV1Like constant private KPR = Keep3rV1Like(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44);
    SushiswapV2Keep3rLike private SV2K;

	function run() public {
	    run(this.init).withCaller(0x2D407dDb06311396fE14D4b49da5F0471447d45C);
	    run(this.pair).withCaller(0x9f6FdC2565CfC9ab8E184753bafc8e94C0F985a0);
	    run(this.work).withCaller(0x9f6FdC2565CfC9ab8E184753bafc8e94C0F985a0);
	}

    function init() external {
        SV2K = SushiswapV2Keep3rLike(address(new SushiswapV2Keep3r()));

        KPR.addJob(address(SV2K));
        KPR.addKPRCredit(address(SV2K),10e18);
    }

    function pair() external {
        SV2K.work(0xc4dE5Cc1232f6493Cc7BF7bcb12F905eb9742Bd7);
    }

    function work() external {
        uint _count = SV2K.count();
        fmt.printf("count()=%u\n",abi.encode(_count));
        address[] memory _jobs = SV2K.workableAll(_count);
        fmt.printf("_jobs.length()=%u\n",abi.encode(_jobs.length));
        SV2K.batch(_jobs);
    }
}
