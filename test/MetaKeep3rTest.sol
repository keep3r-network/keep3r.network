pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./script.sol";
import "./MetaKeep3r.sol";

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

interface MetaKeep3rLike {
    function work(address job) external;
    function unbond() external;
    function withdraw() external;
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
    MetaKeep3rLike private MK;
    address private JOB;

	function run() public {
	    run(this.init).withCaller(0x2D407dDb06311396fE14D4b49da5F0471447d45C);
	    run(this.work).withCaller(0x9f6FdC2565CfC9ab8E184753bafc8e94C0F985a0);
	    run(this.unbond).withCaller(0x9f6FdC2565CfC9ab8E184753bafc8e94C0F985a0);
	    advanceBlocks(100000);
	    run(this.withdraw).withCaller(0x9f6FdC2565CfC9ab8E184753bafc8e94C0F985a0);
	}

    function init() external {
        JOB = address(new TestJob());
        MK = MetaKeep3rLike(address(new MetaKeep3r()));

        KPR.addVotes(address(MK), 0);

        KPR.addJob(address(MK));
        KPR.addKPRCredit(address(MK),10e18);

        KPR.addJob(JOB);
        KPR.addKPRCredit(JOB,10e18);
    }

    function work() external {
        fmt.printf("JOB=%a\n",abi.encode(JOB));
        fmt.printf("ETH=%.18u\n",abi.encode(address(this).balance));
        MK.work(JOB);
        fmt.printf("ETH=%.18u\n",abi.encode(address(this).balance));


        fmt.printf("credits(JOB)=%.18u\n",abi.encode(KPR.credits(JOB, address(KPR))));
        fmt.printf("bonds(MK)=%.18u\n",abi.encode(KPR.bonds(address(MK), address(KPR))));
        fmt.printf("credits(MK)=%.18u\n",abi.encode(KPR.credits(address(MK), address(KPR))));
    }

    function unbond() external {
        fmt.printf("bonds(MK)=%.18u\n",abi.encode(KPR.bonds(address(MK), address(KPR))));
        MK.unbond();
        fmt.printf("bonds(MK)=%.18u\n",abi.encode(KPR.bonds(address(MK), address(KPR))));
    }

    function withdraw() external {
        fmt.printf("balanceOf(MK)=%.18u\n",abi.encode(KPR.balanceOf(address(MK))));
        fmt.printf("bonds(MK)=%.18u\n",abi.encode(KPR.bonds(address(MK), address(KPR))));
        MK.withdraw();
        fmt.printf("balanceOf(MK)=%.18u\n",abi.encode(KPR.balanceOf(address(MK))));
        fmt.printf("bonds(MK)=%.18u\n",abi.encode(KPR.bonds(address(MK), address(KPR))));
    }
}
