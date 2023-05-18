const ethers = require('ethers');
require('dotenv').config();

const providerRPC = {
    development: {
        name: 'lem-development',
        rpc: process.env.RPC_HOST,
        chainId: Number(process.env.NETWORK_ID),
    }
};

const provider = new ethers.providers.StaticJsonRpcProvider(providerRPC.development.rpc, {
    chainId: providerRPC.development.chainId,
    name: providerRPC.development.name,
});

const wallet = new ethers.Wallet(process.env.WALLET_PR_KEY, provider);
console.log(`Loaded wallet ${wallet.address}`);

let compiled = require(`./build/${ process.argv[2] }.json`);

(async() => {
    console.log(`\nDeploying ${process.argv[2]} in LEM Network...`);
    let contract = new ethers.ContractFactory(compiled.abi, compiled.bytecode, wallet);

    const price = ethers.utils.formatUnits(await provider.getGasPrice(), 'gwei');
    const options = { gasPrice: ethers.utils.parseUnits(price, 'gwei') };

    let instance = await contract.deploy(options);
    console.log(`Address: ${ instance.address }`);
    await instance.deployed();
    console.log("Contract deployed successfully.");
})();