var Tx = require('ethereumjs-tx').Transaction;
const Web3 = require('web3');
const provider = new Web3.providers.HttpProvider(<PROVIDER>);
const web3 = new Web3(provider);
const axios = require('axios').default;

const account = <ETH-ADDRESS>;
web3.eth.defaultAccount = account;

const privateKey = Buffer.from(<PRIVATEKEY>, 'hex');

const abi = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"BASE","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"KP3R","outputs":[{"internalType":"contract IKeep3rV1","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"THRESHOLD","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"contract IYERC20","name":"_token","type":"address"}],"name":"shouldRebalance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"tokens","outputs":[{"internalType":"contract IYERC20[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"work","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"workable","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"}];

const address = "0xe7F4ab593aeC81EcA754Da1B3B7cE0C42a13Ec0C";
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
      data: job.methods.work().encodeABI()
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
