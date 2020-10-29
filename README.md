# Introduction to Keep3r Network

{% hint style="info" %}
These docs are in active development by the Keep3r community.
{% endhint %}

Keep3r Network is a decentralized keeper network for projects that need external devops and for external teams to find keeper jobs

## Keepers

A Keeper is the term used to refer to an external person and/or team that executes a job. This can be as simplistic as calling a transaction, or as complex as requiring extensive off-chain logic. The scope of Keep3r network is not to manage these jobs themselves, but to allow contracts to register as jobs for keepers, and keepers to register themselves as available to perform jobs. It is up to the individual keeper to set up their devops and infrastructure and create their own rules based on what transactions they deem profitable.

## Jobs

A Job is the term used to refer to a smart contract that wishes an external entity to perform an action. They would like the action to be performed in "good will" and not have a malicious result. For this reason they register as a job, and keepers can then execute on their contract.

### Becoming a Keeper

To join as a Keeper you call ```bond(uint)``` on the Keep3r contract. You do not need to have KPR tokens to join as a Keeper, so you can join with ```bond(0)```. There is a 3 day bonding delay before you can activate as a Keeper. Once the 3 days have passed, you can call ```activate()```. Once activated you ```lastJob``` timestamp will be set to the current block timestamp.

### Registering a Job

A job can be any system that requires external execution, the scope of Keep3r is not to define or restrict the action taken, but to create an incentive mechanism for all parties involved. There are two cores ways to create a Job;

#### Registering a Job via Governance

If you prefer, you can register as a job by simply submitting a proposal via Governance, to include the contract as a job. If governance approves, no further steps are required.

#### Registering a Job via Contract Interface

You can register as a job by calling ```addLiquidityToJob(address,uint)``` on the Keep3r contract. You must not have any current active jobs associated with this account. Calling ```addLiquidityToJob(address,uint)``` will create a pending Governance vote for the job specified by address in the function arguments. You are limited to submit a new job request via this address every ```14 days```.

## Job Interface

Some contracts require external event execution, an example for this is the ```harvest()``` function in the yearn ecosystem, or the ```update(address,address)``` function in the uniquote ecosystem. These normally require a restricted access control list, however these can be difficult for fully decentralized projects to manage, as they lack devops infrastructure.

These interfaces can be broken down into two types, no risk delta (something like ```update(address,address)``` in uniquote, which needs to be executed, but not risk to execution), and ```harvest()``` in yearn, which can be exploited by malicious actors by front-running deposits.

For no, or low risk executions, you can simply call ```Keep3r.isKeeper(msg.sender)``` which will let you know if the given actor is a keeper in the network.

For high, sensitive, or critical risk executions, you can specify a minimum bond, minimum jobs completed, and minimum Keeper age required to execute this function. Based on these 3 limits you can define your own trust ratio on these keepers.

So a function definition would look as follows;
```
function execute() external {
  requires(Keep3r.isKeeper(msg.sender), "Keep3r not allowed");
}
```

At the end of the call, you simply need to call ```workReceipt(address,uint)``` to finalize the execution for the keeper network. In the call you specify the keeper being rewarded, and the amount of KPR you would like to award them with. This is variable based on what you deem is a fair reward for the work executed.

Example Keep3rJob

```
interface UniOracleFactory {
    function update(address tokenA, address tokenB) external;
}

interface Keep3r {
    function isKeeper(address) external view returns (bool);
    function workReceipt(address keeper, uint amount) external;
}

contract Keep3rJob {
    UniOracleFactory constant JOB = UniOracleFactory(0x61da8b0808CEA5281A912Cd85421A6D12261D136);
    Keep3r constant KPR = Keep3r(0x9696Fea1121C938C861b94FcBEe98D971de54B32);

    function update(address tokenA, address tokenB) external {
        require(KPR.isKeeper(msg.sender), "Keep3rJob::update: not a valid keeper");
        JOB.update(tokenA, tokenB);
        KPR.workReceipt(msg.sender, 1e18);
    }
}
```

### Job Credits

As mentioned in Job Interface, a job has a set amount of ```credits``` that they can award keepers with. To receive ```credits``` you do not need to purchase KPR tokens, instead you need to provide KPR-WETH liquidity in Uniswap. This will give you an amount of credits equal to the amount of KPR tokens in the liquidity you provide.

You can remove your liquidity at any time, so you do not have to keep buying new credits. Your liquidity provided is never reduced and as such you can remove it whenever you no longer would like a job to be executed.

To add credits, you simply need to have KPR-WETH LP tokens, you then call ```addLiquidityToJob(address,uint)``` specifying the job in the address and the amount in the uint. This will then transfer your LP tokens to the contract and keep them in escrow. You can remove your liquidity at any time by calling ```unbondLiquidityFromJob()```, this will allow you to remove the liquidity after 14 days by calling ```removeLiquidityFromJob()```

## Github

[Keep3r](https://github.com/keep3r-network/keep3r.network)

## Beta Addresses
Description | Address
--- | ---
Keep3rV1 | [0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44](https://etherscan.io/address/0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44) (rc.1.2-a)  
Keep3rV1Library | [0xfc38B6eBA9d47CBFc8C7B4FFfFd142B78996B6f1](https://etherscan.io/address/0xfc38B6eBA9d47CBFc8C7B4FFfFd142B78996B6f1)
Keep3rV1Helper | [0xb41772890c8B1564c5015A12c0dC6f18B0aF955e](https://etherscan.io/address/0xb41772890c8b1564c5015a12c0dc6f18b0af955e)
Keep3rV1JobRegistry | [0x7396899638410094B3690F8bd2b56f07fdAb620c](https://etherscan.io/address/0x7396899638410094b3690f8bd2b56f07fdab620c)  

## Jobs

Job | Address
--- | ---
UniQuote | [0x127a2975c4E1c75f1ed4757a861bbd42523DB035](https://etherscan.io/address/0x127a2975c4E1c75f1ed4757a861bbd42523DB035)  

Deprecated  

Job | Address
--- | ---
AaveLiquidate | [0x5D18A46371e313fdC3BB66E77b10405087536e75](https://etherscan.io/address/0x5d18a46371e313fdc3bb66e77b10405087536e75) (Deprecated)  
Keep3rOracle | [0x2ec4901ebBCE581bBAE029BA6405fcA5ab3B3d23](https://etherscan.io/address/0x2ec4901ebBCE581bBAE029BA6405fcA5ab3B3d23#code) (Deprecated)

## Pairs  

Pair | Address
--- | ---
WETH | 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2  
WBTC | 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599  
USDC | 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48  
USDT | 0xdAC17F958D2ee523a2206206994597C13D831ec7  
DAI | 0x6B175474E89094C44Da98b954EedeAC495271d0F  
UNI | 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984  
LINK | 0x514910771AF9Ca656af840dff83E8264EcF986CA  
YFI | 0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e  
MKR | 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2  
AAVE | 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9  
SNX | 0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F  
COMP | 0xc00e94Cb662C3520282E6f5717214004A7f26888  
CRV | 0xD533a949740bb3306d119CC777fa900bA034cd52  
KPR | 0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44  
