var Tx = require('ethereumjs-tx');
const Web3 = require('web3');
const provider = new Web3.providers.HttpProvider(<PROVIDER>);
const web3 = new Web3(provider);
const axios = require('axios').default;

const account = <ETH-ADDRESS>;
web3.eth.defaultAccount = account;

const privateKey = Buffer.from(<PRIVATEKEY>, 'hex');

const abi = [{"inputs":[{"internalType":"address","name":"_keep3r","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"KP3R","outputs":[{"internalType":"contract IKeep3rV1","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"acceptGovernance","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"tokenA","type":"address"},{"internalType":"address","name":"tokenB","type":"address"}],"name":"add","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"tokenIn","type":"address"},{"internalType":"uint256","name":"amountIn","type":"uint256"},{"internalType":"address","name":"tokenOut","type":"address"}],"name":"consult","outputs":[{"internalType":"uint256","name":"amountOut","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"factory","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"governance","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"granularity","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"lastUpdated","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"observationIndexOf","outputs":[{"internalType":"uint8","name":"index","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"}],"name":"pairObservations","outputs":[{"internalType":"uint256","name":"timestamp","type":"uint256"},{"internalType":"uint256","name":"price0Cumulative","type":"uint256"},{"internalType":"uint256","name":"price1Cumulative","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"pairs","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"pendingGovernance","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"periodSize","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_governance","type":"address"}],"name":"setGovernance","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_keep3r","type":"address"}],"name":"setKeep3r","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"tokenA","type":"address"},{"internalType":"address","name":"tokenB","type":"address"}],"name":"update","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"i","type":"uint256"},{"internalType":"uint256","name":"length","type":"uint256"}],"name":"updateFor","outputs":[{"internalType":"bool","name":"updated","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"pair","type":"address"}],"name":"updatePair","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"updateable","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"i","type":"uint256"},{"internalType":"uint256","name":"length","type":"uint256"}],"name":"updateableFor","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"updateableList","outputs":[{"internalType":"address[]","name":"list","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"windowSize","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"work","outputs":[],"stateMutability":"nonpayable","type":"function"}];

const address = "0x127a2975c4E1c75f1ed4757a861bbd42523DB035";
const oracle = new web3.eth.Contract(abi, address)

_getGasPrice()

function _getGasPrice() {
  axios.get('https://gasprice.poa.network/')
  .then((resp) => {
    oracle.methods.updateable().call({from: account}, function(error, result) {
        if (result) {
          update(resp.data.instant);
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

function update(gwei) {
  web3.eth.getTransactionCount(account, (err, txCount) => {
  // Build the transaction
    const txObject = {
      nonce:    web3.utils.toHex(txCount),
      to:       address,
      value:    web3.utils.toHex(web3.utils.toWei('0', 'ether')),
      gasLimit: web3.utils.toHex(1000000),
      gasPrice: web3.utils.toHex(web3.utils.toWei(''+gwei, 'gwei')),
      data: oracle.methods.work().encodeABI()
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
