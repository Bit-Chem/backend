
const hre = require("hardhat");

async function main() {
  
  const Chem = await hre.ethers.getContractFactory("Chem");
  const chem = await Chem.deploy();

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
