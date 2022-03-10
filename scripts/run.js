
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


  [owner, addr1, addr2, _] = await ethers.getSigners();
  let addy = await chem.address
  let bal = await chem.supplyBalance(owner.address, 1);
  //console.log("address", addy);
  console.log("begin balance:", bal.toString())
  
  let txn = await chem.mintHydrogen(100)
  await txn.wait()
  let txnO = await chem.mintOxygen(50)
  await txnO.wait()
  let hydroBal = await chem.supplyBalance(owner.address, 1);
//  console.log("Hydrogen balance:", hydroBal)
  let oxyBal = await chem.supplyBalance(owner.address, 8);
//  console.log("Oxygen balance:", oxyBal)

  let txnWBTC = await chem.mintBTC(50)
  await txnWBTC.wait()
  let wbtcBal = await wbtc.tokenBalance(owner.address);
  console.log("WBTC balance", wbtcBal)
  let wbtcBal2 = await chem.btcTokenBalance(owner.address);
  console.log("Local WBTC balance", wbtcBal2)

/*
  for(let i = 0; i < 50; i++) {
  let watertxn = await chem.createWater()
  await watertxn.wait()
  let waterBal = await chem.supplyBalance(owner.address, 200)
//  console.log ("Water balance:", waterBal)
  let hydroBalUp = await chem.supplyBalance(owner.address, 1);
//  console.log("Hydrogen balance:", hydroBalUp)
  let oxyBalUp = await chem.supplyBalance(owner.address, 8);
//  console.log("Oxygen balance:", oxyBalUp)
  } */



  
  /*
  await chem.connect(addr1).mint(1, 
    {value: ethers.utils.parseEther('.001')})
    console.log("Minted NFT #2")
    console.log("contract Balance:", bal)
  
  // Call the function.
 //let txn = await chem.mint(1)
  // Wait for it to be mined.
 // await txn.wait()
 // console.log("Minted NFT #1")
  //await chem.reveal();
 
  /*
  for(let i = 0; i < 149; i++ ) {
    txn = await chem.connect(addr1).mint(1, 
      {value: ethers.utils.parseEther('.001')})
    // Wait for it to be mined.
    await txn.wait()
    console.log("Minted NFT #", i)
    console.log("contract Balance:", bal)
  }
  */
  

  /*
  let info = await chem.baseURI();
  console.log(info)
  let token = await chem.tokenURI(1);
  console.log(token)
  let rev = await chem.reveal();
  await rev.wait()
  token = await chem.tokenURI(1);
  console.log(token)
*/
/*
  txn = await chem.makeAnEpicNFT()
  // Wait for it to be mined.
  await txn.wait()
  console.log("Minted NFT #2")
  */




}






// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
