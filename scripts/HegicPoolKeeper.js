var Tx = require('ethereumjs-tx').Transaction;
const Web3 = require('web3');
const provider = new Web3.providers.HttpProvider(<PROVIDER>);
const web3 = new Web3(provider);
const axios = require('axios').default;

const account = <ETH-ADDRESS>;
web3.eth.defaultAccount = account;

const privateKey = Buffer.from(<PRIVATEKEY>, 'hex');

const abi = [{"inputs":[{"internalType":"address","name":"_keep3r","type":"address"},{"internalType":"address","name":"_hegicPool","type":"address"},{"internalType":"uint256","name":"_minETHRewards","type":"uint256"},{"internalType":"uint256","name":"_minWBTCRewards","type":"uint256"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"_to","type":"address"},{"indexed":false,"internalType":"address","name":"token","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"DustSent","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"rewards","type":"uint256"}],"name":"ForcedClaimedRewards","type":"event"},{"anonymous":false,"inputs":[],"name":"GovernorAccepted","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"hegicPool","type":"address"}],"name":"HegicPoolSet","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"keep3r","type":"address"}],"name":"Keep3rSet","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"eth","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"wbtc","type":"uint256"}],"name":"LotsBought","type":"event"},{"anonymous":false,"inputs":[],"name":"ManagerAccepted","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"_minETHRewards","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_minWBTCRewards","type":"uint256"}],"name":"MinRewardsSet","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"pendingGovernor","type":"address"}],"name":"PendingGovernorSet","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"pendingManager","type":"address"}],"name":"PendingManagerSet","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"rewards","type":"uint256"}],"name":"RewardsClaimedByKeeper","type":"event"},{"inputs":[],"name":"ETH_ADDRESS","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"HegicPool","outputs":[{"internalType":"contract IHegicPoolV2","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"acceptGovernor","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"acceptManager","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_eth","type":"uint256"},{"internalType":"uint256","name":"_wbtc","type":"uint256"}],"name":"buyLots","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"claimRewards","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"forceClaimRewards","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"governor","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"keep3r","outputs":[{"internalType":"contract IKeep3rV1","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"minETHRewards","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"minWBTCRewards","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"pendingGovernor","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_to","type":"address"},{"internalType":"address","name":"_token","type":"address"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"sendDust","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_hegicPool","type":"address"}],"name":"setHegicPool","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_keep3r","type":"address"}],"name":"setKeep3r","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_minETHRewards","type":"uint256"},{"internalType":"uint256","name":"_minWBTCRewards","type":"uint256"}],"name":"setMinRewards","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_pendingGovernor","type":"address"}],"name":"setPendingGovernor","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_pendingManager","type":"address"}],"name":"setPendingManager","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"workable","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"}];

const address = "0x5DDe926b0A31346f2485900C5e64c2577F43F774";
const job = new web3.eth.Contract(abi, address)

_getGasPrice()

function _getGasPrice() {
  axios.get('https://gasprice.poa.network/')
  .then((resp) => {
    job.methods.workable().call({from: account}, function(error, result) {
        if (result) {
          work(resp.data.instant);
        } else {
          setTimeout(_getGasPrice, 300000);
        }
    });
  })
  .catch((err) => {
    console.log(err);
    setTimeout(_getGasPrice, 300000);
  })
}

function work(gwei) {
  web3.eth.getTransactionCount(account, (err, txCount) => {
  // Build the transaction
    const txObject = {
      nonce:    web3.utils.toHex(txCount),
      to:       address,
      value:    web3.utils.toHex(web3.utils.toWei('0', 'ether')),
      gasLimit: web3.utils.toHex(1000000),
      gasPrice: web3.utils.toHex(web3.utils.toWei(''+gwei, 'gwei')),
      data: job.methods.claimRewards().encodeABI()
    }
      // Sign the transaction
      const tx = new Tx(txObject);
      tx.sign(privateKey);

      const serializedTx = tx.serialize();
      const raw = '0x' + serializedTx.toString('hex');

      // Broadcast the transaction
      const transaction = web3.eth.sendSignedTransaction(raw, (err, tx) => {
          console.log(tx)
      });
  });
  setTimeout(_getGasPrice, 300000);
}
