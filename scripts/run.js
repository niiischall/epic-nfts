const main = async () => {
  //Deploy the contract file.
  const contractFactory = await hre.ethers.getContractFactory("EpicNft");
  const contract = await contractFactory.deploy();
  await contract.deployed();
  console.log("Contract deployed: " + contract.address);

  //Mint an NFT and wait for it to be minted.
  let txn = await contract.makeAnEpicNFT();
  await txn.wait();

  //Mint another NFT just for fun.
  txn = await contract.makeAnEpicNFT();
  await txn.wait();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
};

runMain();
