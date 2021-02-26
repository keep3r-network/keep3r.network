//
// Sample keeper script for running MMStrategyKeeperV2 jobs in Keep3r network
// please resort to https://docs.ethers.io/v5/ for more details on the library usage
//
const {
    ethers
} = require("ethers");

const provider = new ethers.providers.JsonRpcProvider("<Ethereum mainnet node rpc like infura>");
w = new ethers.Wallet("<please insert your keep3r private key>", provider);

const mm_kp3rv2_abi = '[{"inputs":[{"internalType":"address","name":"_keep3r","type":"address"},{"internalType":"address","name":"_keep3rHelper","type":"address"},{"internalType":"address","name":"_slidingOracle","type":"address"},{"internalType":"address","name":"_sushiSlidingOracle","type":"address"},{"internalType":"address","name":"_mmController","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_vault","type":"address"},{"indexed":false,"internalType":"uint256","name":"_requiredEarnBalance","type":"uint256"}],"name":"EarnVaultAdded","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_vault","type":"address"},{"indexed":false,"internalType":"uint256","name":"_requiredEarnBalance","type":"uint256"}],"name":"EarnVaultModified","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_vault","type":"address"}],"name":"EarnVaultRemoved","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_vault","type":"address"},{"indexed":false,"internalType":"address","name":"_strategy","type":"address"},{"indexed":false,"internalType":"uint256","name":"_requiredHarvest","type":"uint256"},{"indexed":false,"internalType":"bool","name":"_requiredKeepMinRatio","type":"bool"},{"indexed":false,"internalType":"bool","name":"_requiredLeverageToMax","type":"bool"},{"indexed":false,"internalType":"address","name":"yieldToken","type":"address"},{"indexed":false,"internalType":"uint256","name":"yieldTokenOracle","type":"uint256"}],"name":"HarvestStrategyAdded","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_strategy","type":"address"},{"indexed":false,"internalType":"uint256","name":"_requiredHarvest","type":"uint256"}],"name":"HarvestStrategyModified","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_strategy","type":"address"}],"name":"HarvestStrategyRemoved","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_strategy","type":"address"},{"indexed":false,"internalType":"uint256","name":"profitTokenAmount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"profitFactor","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"profitInEther","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"ethCallCost","type":"uint256"}],"name":"HarvestableCheck","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_strategy","type":"address"}],"name":"HarvestedByKeeper","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"keep3rHelper","type":"address"}],"name":"Keep3rHelperSet","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"keep3r","type":"address"}],"name":"Keep3rSet","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"slidingOracle","type":"address"}],"name":"SlidingOracleSet","type":"event"},{"inputs":[],"name":"COMP","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"CRV","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"CRVRENWBTC","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"DAI","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"KP3R","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"LINK","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"MIR","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"MIRUSTLP","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"SUSHISWAP_ORACLE","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"THREECRV","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"UNISWAP_ORACLE","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"USDC","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"WBTC","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"WETH","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"ZRX","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_governor","type":"address"}],"name":"_setGovernor","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_vault","type":"address"},{"internalType":"address","name":"_strategy","type":"address"},{"internalType":"uint256","name":"_requiredHarvest","type":"uint256"},{"internalType":"bool","name":"_requiredKeepMinRatio","type":"bool"},{"internalType":"bool","name":"_requiredLeverageToMax","type":"bool"},{"internalType":"address","name":"yieldToken","type":"address"},{"internalType":"uint256","name":"yieldTokenOracle","type":"uint256"}],"name":"addStrategy","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_vault","type":"address"},{"internalType":"uint256","name":"_requiredEarnBalance","type":"uint256"}],"name":"addVault","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_vault","type":"address"}],"name":"earn","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_vault","type":"address"}],"name":"earnable","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getCollateralizedStrategies","outputs":[{"internalType":"address[]","name":"_strategies","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getStrategies","outputs":[{"internalType":"address[]","name":"_strategies","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getVaults","outputs":[{"internalType":"address[]","name":"_vaults","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"governor","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_strategy","type":"address"}],"name":"harvest","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_strategy","type":"address"}],"name":"harvestable","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"keep3r","outputs":[{"internalType":"contract IKeep3rV1","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"keep3rHelper","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_strategy","type":"address"}],"name":"keepMinRatio","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_strategy","type":"address"}],"name":"keepMinRatioMayday","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"minHarvestInterval","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"mmController","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[],"name":"profitFactor","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_vault","type":"address"}],"name":"removeEarnVault","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_strategy","type":"address"}],"name":"removeHarvestStrategy","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"requiredEarnBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"requiredHarvest","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_keep3r","type":"address"}],"name":"setKeep3r","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_keep3rHelper","type":"address"}],"name":"setKeep3rHelper","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_interval","type":"uint256"}],"name":"setMinHarvestInterval","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_profitFactor","type":"uint256"}],"name":"setProfitFactor","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_slidingOracle","type":"address"}],"name":"setSlidingOracle","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sushiSlidingOracle","type":"address"}],"name":"setSushiSlidingOracle","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"slidingOracle","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"stratagyYieldTokenOracles","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"stratagyYieldTokens","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"strategyLastHarvest","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"sushiSlidingOracle","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_vault","type":"address"},{"internalType":"uint256","name":"_requiredEarnBalance","type":"uint256"}],"name":"updateRequiredEarn","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_strategy","type":"address"},{"internalType":"uint256","name":"_requiredHarvest","type":"uint256"}],"name":"updateRequiredHarvestAmount","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_strategy","type":"address"},{"internalType":"uint256","name":"_yieldTokenOracle","type":"uint256"}],"name":"updateYieldTokenOracle","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"vaultStrategies","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"}]';

const mm_kp3r_v2 = "0x0bD1d668d8E83d14252F2e01D5873df77A6511f0";
const mmKp3rV2 = new ethers.Contract(mm_kp3r_v2, mm_kp3rv2_abi, w);

async function kp3r() {

    await kp3rWorkEarn();
    await kp3rWorkHarvest();
    await kp3rWorkKeepMinRatio();

}

/////////////////////////////////////////////////////////////////////////////
//  Mushrooms KP3R V2 Job
/////////////////////////////////////////////////////////////////////////////

async function kp3rv2Earnable(_contract, _vault) {
    let result = await _contract.earnable(_vault)
    console.log('earnable() check for ' + _vault + '=' + result);
    if (result == 'true') {
        kp3rv2Earn(_contract, _vault);
    }
}

async function kp3rv2Earn(_contract, _vault) {
    let result = await _contract.earn(_vault);
    console.log('submitted earn() for ' + result);
}

async function kp3rWorkEarn() {
    console.log("--------Mushrooms KP3R V2 Job: earn()--------");
    mmKp3rV2.getVaults().then((result) => {
        for (i = 0; i < result.length; i++) {
            kp3rv2Earnable(mmKp3rV2, result[i]);
        }
    }).catch(console.error);
}

async function kp3rv2Harvestable(_contract, _strategy) {
    let result = await _contract.callStatic.harvestable(_strategy);
    console.log('harvestable() check for ' + _strategy + '=' + result);
    if (result == 'true') {
        kp3rv2Harvest(_contract, _strategy);
    }
}

async function kp3rv2Harvest(_contract, _strategy) {
    let result = await _contract.harvest(_strategy);
    console.log('submitted harvest() for ' + result);
}

async function kp3rWorkHarvest() {
    console.log("--------Mushrooms KP3R V2 Job: harvest()--------");
    mmKp3rV2.getStrategies().then((result) => {
        for (i = 0; i < result.length; i++) {
            kp3rv2Harvestable(mmKp3rV2, result[i]);
        }
    }).catch(console.error);
}

async function kp3rv2KeepMinRatioMayday(_contract, _strategy) {
    let result = await _contract.keepMinRatioMayday(_strategy);
    console.log('keepMinRatioMayday() check for ' + _strategy + '=' + result);
    if (result == 'true') {
        kp3rv2KeepMinRatio(_contract, _strategy);
    }
}

async function kp3rv2KeepMinRatio(_contract, _strategy) {
    let result = await _contract.keepMinRatio(_strategy);
    console.log('submitted keepMinRatioMayday() for ' + result);
}

async function kp3rWorkKeepMinRatio() {
    console.log("--------Mushrooms KP3R V2 Job: keepMinRatio()--------");
    mmKp3rV2.getCollateralizedStrategies().then((result) => {
        for (i = 0; i < result.length; i++) {
            kp3rv2KeepMinRatioMayday(mmKp3rV2, result[i]);
        }
    }).catch(console.error);
}

kp3r();