require('dotenv').config();

module.exports = {
  rpc: {
    host: process.env.RPC_IP,
    port: process.env.RPC_PORT
  },
  networks: {
    development: {
      host: process.env.RPC_IP,
      port: process.env.RPC_PORT,
      network_id: process.env.NETWORK_ID,
      /* here i could place a from variable that will be specified in the transaction obj */
      from: process.env.PUBLIC_ADDRESS,
      gas: process.env.GAS
    },
  },
  compilers: {
    solc: {
      version: "0.8.12"
    }
  }
}