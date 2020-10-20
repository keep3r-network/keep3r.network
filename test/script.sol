pragma solidity ^0.5.0;


contract ERC20Like {
    function decimals() public returns (uint8);
    function name() public returns (string memory);
    function symbol() public returns (string memory);
    function approve(address,uint) public;

    function approveAndCall(address, uint, bytes memory) public;

    function balanceOf(address) public view returns (uint);
    function transfer(address, uint) public;
    function transferFrom(address, address, uint) public;
    function totalSupply() public returns (uint);

    function mint(address, uint) public;
}


library impl {
    function setScriptName(string memory name) public;

    function setBlockNumber(uint number) public;

    function addWatchedBalance(ERC20Like addr) public;

    function advanceBlocks(uint number) public;

    function advanceTime(uint secs) public;
}

library fmt {
    function sprintf(string memory format, bytes memory args) public returns (string memory);

    function printf(string memory format, bytes memory args) public;

    function print(string memory message) public;

    function println(string memory message) public;

    function println() public;
}

library sys {
    function setName(string memory name) public;
}

library step {
    function run(string memory name, address who, bytes4 sel) public returns (uint);

    function withCaller(uint, address caller) public returns (uint);

    function withBalance(uint, uint balance) public returns (uint);
}

contract script {
    using step for uint;

    function name(string memory n) internal {
        impl.setScriptName(n);
    }

    function blockNumber(uint blockNr) internal {
        impl.setBlockNumber(blockNr);
    }

    function watchBalance(ERC20Like addr) internal {
        impl.addWatchedBalance(addr);
    }

    function advanceBlocks(uint blocks) internal {
        impl.advanceBlocks(blocks);
    }

    function advanceTime(uint secs) internal {
        impl.advanceTime(secs);
    }

    function run(function() external func) internal returns (uint) {
        return run("", func);
    }

    function run(string memory desc, function() external func) internal returns (uint) {
        return step.run(desc, address(func), func.selector);
    }

    // @notice configure script parameters
    function setup() public {}

    // @notice the entry point, to be implemented by you
    function run() public;

    function() external payable {}
}
