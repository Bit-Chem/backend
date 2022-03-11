
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
 // let hydroBal = await chem.supplyBalance(owner.address, 1);
//  console.log("Hydrogen balance:", hydroBal)
//  let oxyBal = await chem.supplyBalance(owner.address, 8);
//  console.log("Oxygen balance:", oxyBal)

  let txnWBTC = await chem.mintBTC(50)
  await txnWBTC.wait()
  let wbtcBal = await wbtc.tokenBalance(owner.address);
  console.log("WBTC balance", wbtcBal)
  let wbtcBal2 = await chem.btcTokenBalance(owner.address);
  console.log("Local WBTC balance", wbtcBal2)

  let txnBeaker = await chem.mintEpicBeaker(50)
  await txnBeaker.wait()

  await wbtc.approve(chem.address, 50)
  await chem.stakeBTC(50)
  let wbtcBal3 = await chem.btcTokenBalance(owner.address);
  console.log("Local WBTC balance", wbtcBal3)
  let hydroBal = await chem.supplyBalance(owner.address, 1);
  let helBal = await chem.supplyBalance(owner.address, 2)
  let helLit = await chem.supplyBalance(owner.address, 3)
  let helBer = await chem.supplyBalance(owner.address, 4)
  let oxyBal = await chem.supplyBalance(owner.address, 8);
  //console.log("Hydrogen Balance", hydroBal)
  //console.log("Helium Balance", helBal)
  //console.log("Lithium Balance", helLit)
  //console.log("Beryllium Balance", helBer)
  //console.log("Oxygen Balance", oxyBal)


  for(let i = 0; i < 15; i++) {
  let watertxn = await chem.createWater(1000)
  await watertxn.wait()
  
  //let waterBal = await chem.supplyBalance(owner.address, 200)
  //console.log ("Water balance:", waterBal)
  //let hydroBalUp = await chem.supplyBalance(owner.address, 1);
  //console.log("Hydrogen balance:", hydroBalUp)
  //let oxyBalUp = await chem.supplyBalance(owner.address, 8);
  //console.log("Oxygen balance:", oxyBalUp)

  } 
  let waterBal = await chem.supplyBalance(owner.address, 200);
  console.log("Water balance:", waterBal)
  let pureWBal = await chem.supplyBalance(owner.address, 201);
  console.log("Pure Water balance:", pureWBal)

  let wbtcBal4 = await chem.btcTokenBalance(owner.address);
  console.log("Bitcoin Bal:", wbtcBal4)

  console.log("Sell NFT")
  let sellfNFT = await chem.sellNFT(200);
  await sellfNFT.wait()

  let waterBal2 = await chem.supplyBalance(owner.address, 200);
  console.log("Water balance:", waterBal2)

  let wbtcBal5 = await chem.btcTokenBalance(owner.address);
  console.log("Bitcoin Bal:", wbtcBal5)





  
  /*
  await chem.connect(addr1).mint(1, 
    {value: ethers.utils.parseEther('.001')})
    console.log("Minted NFT #2")
    console.log("contract Balance:", bal)
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
