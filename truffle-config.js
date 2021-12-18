const HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config()
//
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();

module.exports = {
  contracts_build_directory: "./src/contracts",

  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
    },
    maticMumbai: {
      networkCheckTimeout: 100000,
      provider: () => new HDWalletProvider(mnemonic, `https://rpc-mumbai.maticvigil.com/`),
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    bscTestnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://data-seed-prebsc-1-s1.binance.org:8545`),
      network_id: 97,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true,
      from: process.env.ACCOUNT_ADDRESS,
      networkCheckTimeout: 1000000,
    },    
  },

  plugins: [
    'truffle-plugin-verify'
  ],
  api_keys: {
    etherscan: process.env.BSCSCAN_API_KEY
  },

  mocha: {
  },

  compilers: {
    solc: {
      version: "0.8.10",    // Fetch exact version from solc-bin (default: truffle's version)
      optimizer: {
        enabled: true,
        runs: 1
      },
    }
  },

  db: {
    enabled: false,
  }
};
