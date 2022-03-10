
const hre = require("hardhat");

async function main() {

  const WBTC = await hre.ethers.getContractFactory("WBTC");
  const wbtc = await WBTC.deploy();

  await wbtc.deployed();

  console.log("WBTC Contract deployed to:", wbtc.address);

  
  const Chem = await hre.ethers.getContractFactory("Chem");
  const chem = await Chem.deploy(wbtc.address);

  await chem.deployed();

  console.log("Chem Contract deployed to:", chem.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
