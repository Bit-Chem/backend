//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./WBTC.sol";
//chainlink
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

//import "hardhat/console.sol";

/*
interface IWBTC {
    function mint(address _account, uint256 _amount) external;
} */

contract Chem is ERC1155, Ownable, VRFConsumerBase {

    WBTC public wbtcContract;

    //Bare Elements
    uint256 public constant Hydrogen = 1;
    uint256 public constant Helium = 2;
    uint256 public constant Lithium = 3;
    uint256 public constant Beryllium = 4;
    uint256 public constant Boron = 5;
    uint256 public constant Carbon = 6;
    uint256 public constant Nitrogen = 7;
    uint256 public constant Oxygen = 8;
    uint256 public constant Fluorine = 9;
    uint256 public constant Neon = 10;
    //Merged Elements
    uint256 public constant Water = 200;

    uint256 public constant LiOH = 201;  // 2 Li + 2 H20 Reaction set
    uint256 public constant H2 = 202;

    uint256 public constant H2O2 = 203;  // Hydrogen Per Oxide


    //Beakers
    //uint256 public constant cheapBeaker = 1000;
    //uint256 public constant regularBeaker = 1001;
    //uint256 public constant epicBeaker = 1002;
    //seed
    uint256 private seed; //seed used to randomize

    //chainlink
    uint256 internal fee;
    uint256 public randomResult;
    bytes32 internal keyHash;

    string public Elements =  'ipfs://QmSoGVnjD82B6TJWN459LuqiexAchsryeovzSARnV8TEvX/';  
                            //'ipfs://QmcJ1bQbBR3hUos1UaLm7v2mFxJ9ykHEV5zLLmYWpcp8BN/';  

    mapping(address => mapping (uint256 => uint256))  public supplyBalance;
    mapping(address =>uint256)  public btcTokenBalance; 
    

    constructor(address _address) 
        ERC1155(Elements) 
        VRFConsumerBase(
             0x8C7382F9D8f56b33781fE506E897a4F1e2d17255,
             0x326C977E6efc84E512bB9C30f76E30c160eD06FB 
              ) public {
        
        wbtcContract = WBTC(_address);
        //chainlink
        keyHash = 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4;
        fee = 0.0001 * 10 ** 18; // 0.0001 LINK
    }

    //Element Events
    event WaterCreated(uint256 tokenId, address receiver, uint256 mintedAmount);
    event WaterCreationFailed(string failure);
    event H2O2Created(uint256 H202, address recieverHO, uint256 mintedH202);
    event H2O2CreationFailed(string FailedH202);
    event LiOHCreated(uint256 LithWat, address recieverLit, uint256 mintedLiH202);
    event LiOHCreationFailed(string FailedLiH202);

    event RandomNumber(uint256 randomReturn);
    event WBTCMinted(string Minted);

    //set contract for WBTC - if need to change
    function setwbtcContract(address addr) public onlyOwner {
        wbtcContract = WBTC(addr);
    } 
 
    //Mint wBTC
    function mintBTC(uint256 _amount) public {
        wbtcContract.mint(msg.sender, _amount);
        btcTokenBalance[msg.sender] += _amount;
        emit WBTCMinted("wBTC Minted");
        getRandomNumber(); // start a random number flow going
    }  

    //Stake wBTC  -- this will be phased out.
    function stakeBTC(uint256 _amount) public payable {
        require(_amount > 0, "Amount must be greater than zer0");
        // Transfer wBtc to smart contract
        wbtcContract.transferFrom(msg.sender, address(this), _amount); 
        btcTokenBalance[msg.sender] -= _amount;
        //Mint Materials
        mintHydrogen(10);
        mintHelium(10);
        mintBeryllium(10);
        mintLithium(10);
        mintOxygen(10);
        //start a random number process
        getRandomNumber();
       // mintCheapBeaker(10);
       // mintEpicBeaker(10);
       // mintRegularBeaker(10);
    }

    //Sell Crafted Elements
    function sellNFT(uint256 _amount) public { // for now water 200 pureW 201
        require(_amount >= Water && _amount <= H2O2, "Not Valid Creation");
        //require(_amount >= supplyBalance[msg.sender][_amount], "No Element In Inventory");
       // do a requirement for contract balance
        uint256 reward = 1;  // need to multiply by 10 **18
        uint256 amountBurned = 1; 
        if(_amount == Water) {
            _burn(msg.sender, Water, amountBurned) ; //from, ids [], amounts []
            supplyBalance[msg.sender][Water] -= reward;
        //    wbtcContract.transfer(msg.sender, reward); // make sure enough in contract
        //    btcTokenBalance[msg.sender] += reward;
        } else if (_amount == LiOH){
            _burn(msg.sender, LiOH, amountBurned) ; //from, ids [], amounts []
            supplyBalance[msg.sender][LiOH] -= reward;
        //    wbtcContract.transfer(msg.sender, reward); // make sure enough in contract
        //    btcTokenBalance[msg.sender] += reward;
        } else if (_amount == H2) {
            _burn(msg.sender, H2, amountBurned) ; //from, ids [], amounts []
            supplyBalance[msg.sender][H2] -= reward;
        //    wbtcContract.transfer(msg.sender, reward); // make sure enough in contract
        //    btcTokenBalance[msg.sender] += reward;
        } else {
            _burn(msg.sender, H2O2, amountBurned) ; //from, ids [], amounts []
            supplyBalance[msg.sender][H2O2] -= reward;
        //    wbtcContract.transfer(msg.sender, reward); // make sure enough in contract
        //    btcTokenBalance[msg.sender] += reward;
        }
    }

    // Mint Elements
    function mintHydrogen(uint256 _amount) public {
     //   require(_amount > 0, "Amount must be greater than zer0");
        // Transfer wBtc to smart contract
    //    wbtcContract.transferFrom(msg.sender, address(this), _amount); 
     //   btcTokenBalance[msg.sender] -= _amount;
        _mint(msg.sender, Hydrogen, _amount, "");
        supplyBalance[msg.sender][Hydrogen] = supplyBalance[msg.sender][Hydrogen] + _amount;
    }

    function mintHelium(uint256 _amount) public {
     //   require(_amount > 0, "Amount must be greater than zer0");
        // Transfer wBtc to smart contract
     //   wbtcContract.transferFrom(msg.sender, address(this), _amount); 
     //   btcTokenBalance[msg.sender] -= _amount;
        _mint(msg.sender, Helium, _amount, "");
        supplyBalance[msg.sender][Helium] =supplyBalance[msg.sender][Helium] + _amount;
    }

    function mintLithium(uint256 _amount) public {
      //  require(_amount > 0, "Amount must be greater than zer0");
        // Transfer wBtc to smart contract
     //   wbtcContract.transferFrom(msg.sender, address(this), _amount); 
     //   btcTokenBalance[msg.sender] -= _amount;
        _mint(msg.sender, Lithium, _amount, "");
        supplyBalance[msg.sender][Lithium] = supplyBalance[msg.sender][Lithium] + _amount;
    }

    function mintBeryllium(uint256 _amount) public {
     //   require(_amount > 0, "Amount must be greater than zer0");
        // Transfer wBtc to smart contract
     //   wbtcContract.transferFrom(msg.sender, address(this), _amount); 
     //   btcTokenBalance[msg.sender] -= _amount;
        _mint(msg.sender, Beryllium, _amount, "");
        supplyBalance[msg.sender][Beryllium] = supplyBalance[msg.sender][Beryllium] + _amount;
    }

    function mintOxygen(uint256 _amount) public {
     //   require(_amount > 0, "Amount must be greater than zer0");
        // Transfer wBtc to smart contract
     //   wbtcContract.transferFrom(msg.sender, address(this), _amount); 
    //    btcTokenBalance[msg.sender] -= _amount;
        _mint(msg.sender, Oxygen, _amount, "");
        supplyBalance[msg.sender][Oxygen] = supplyBalance[msg.sender][Oxygen] + _amount;
    }
/*
    function mintCheapBeaker(uint256 _amount) public {
        _mint(msg.sender, cheapBeaker, _amount, "");
        supplyBalance[msg.sender][cheapBeaker] = supplyBalance[msg.sender][cheapBeaker] + _amount;
    }

    function mintRegularBeaker(uint256 _amount) public {
        _mint(msg.sender, regularBeaker, _amount, "");
        supplyBalance[msg.sender][regularBeaker] = supplyBalance[msg.sender][regularBeaker] + _amount;
    }

    function mintEpicBeaker(uint256 _amount) public {
        _mint(msg.sender, epicBeaker, _amount, "");
        supplyBalance[msg.sender][epicBeaker] = supplyBalance[msg.sender][epicBeaker] + _amount;
    }
    */

    function name() public pure returns (string memory) {
        return "Elements";
    }

    function symbol() public pure returns (string memory) {
        return "ELMT";
    }  

    // to move to 2nd contract
    /*  Creating seperate functions for now
    function mergeElements() public {
        getRandomNumber();
        createWater();
    } */

    //Elemental Merging
    function createWater(uint256 _amount) public { 
        require(_amount > 0, "Amount needs to be greater than 0");
        //inventory
        uint256 hydrogenSupply = supplyBalance[msg.sender][Hydrogen];
        uint256 oxygenSupply = supplyBalance[msg.sender][Oxygen];
        //requirements
        uint256 hydrogenRequired = 2;
        uint256 oxygenRequired = 1;
        //requirement amount check
        uint256 hydrogenRequiredAmount = 2 * _amount;
        uint256 oxygenRequiredAmount = 1 * _amount;
        //creations
        //uint256 minimum = 1 * _amount;
        //uint256 bonus = 2;
        
        uint256 random = randomResult;
        emit RandomNumber(random);

        require(hydrogenSupply >= hydrogenRequiredAmount, 'Not Enough Hydrogen');
        require(oxygenSupply >= oxygenRequiredAmount, 'Not Enough Oxygen');
        // require(_beaker >=cheapBeaker && _beaker <=epicBeaker, 'Not a valid Beaker');

        if(random < 10) {  // check this variable
            emit WaterCreationFailed("Failure");
             } else {
                
                    //work on burn batch problem
                    _burn(msg.sender, Hydrogen, hydrogenRequiredAmount) ; //from, ids [], amounts []
                    supplyBalance[msg.sender][Hydrogen] -= hydrogenRequiredAmount;
                    _burn(msg.sender, Oxygen, oxygenRequiredAmount);
                    supplyBalance[msg.sender][Oxygen] -= oxygenRequiredAmount;

                    _mint(msg.sender, Water, _amount, '');
                    supplyBalance[msg.sender][Water] += _amount;
                
                emit WaterCreated(Water, msg.sender, _amount);
            }
        
        //queu up a random number
        getRandomNumber();

          /* Kill beaker logic
        if(_beaker == cheapBeaker) {

            if(random > 50){
                console.log("failure");
            } else {
                 console.log("Water Created");
                _mint(msg.sender, Water, minimum, '');
                supplyBalance[msg.sender][Water] += minimum;
            }
        } else if(_beaker == regularBeaker){
            if(random > 70){
                console.log("failure");
            } else {
                 console.log("Water Created");
                _mint(msg.sender, Water, minimum, '');
                supplyBalance[msg.sender][Water] += minimum;
            }
        } else {
            if(random > 95){
                console.log("failure");
            } else {
                console.log("Water Created");
                _mint(msg.sender, Water, minimum, '');
                supplyBalance[msg.sender][Water] += minimum;
            }
        } */
    }  

    function createH2O2(uint256 _amount) public { 
        require(_amount > 0, "Amount needs to be greater than 0");
        //inventory
        uint256 hydrogenSupply = supplyBalance[msg.sender][Hydrogen];
        uint256 oxygenSupply = supplyBalance[msg.sender][Oxygen];
        //requirements
        uint256 hydrogenRequired = 2;
        uint256 oxygenRequired = 2;
        //requirement amount check
        uint256 hydrogenRequiredAmount = 2 * _amount;
        uint256 oxygenRequiredAmount = 2 * _amount;
        //creations
        uint256 minimum = 1;

        uint256 random = randomResult;
        emit RandomNumber(random);
        
        require(hydrogenSupply >= hydrogenRequiredAmount, 'Not Enough Hydrogen');
        require(oxygenSupply >= oxygenRequiredAmount, 'Not Enough Oxygen');


        if(random < 10){  // check this variable
            emit H2O2CreationFailed("Failure");
            } else {
                    _burn(msg.sender, Hydrogen, hydrogenRequiredAmount) ; //from, ids [], amounts []
                    supplyBalance[msg.sender][Hydrogen] -= hydrogenRequiredAmount;
                    _burn(msg.sender, Oxygen, oxygenRequiredAmount);
                    supplyBalance[msg.sender][Oxygen] -= oxygenRequiredAmount;

                    _mint(msg.sender, H2O2, _amount, '');
                    supplyBalance[msg.sender][H2O2] += _amount;
                    emit H2O2Created(H2O2, msg.sender, _amount);
        }
            
        
        //queu up a random number
        getRandomNumber();
    }

    function createLiH2O(uint256 _amount) public {
        require(_amount > 0, "Amount needs to be greater than 0"); 
        //inventory
        uint256 lithiumSupply = supplyBalance[msg.sender][Lithium];
        uint256 waterSupply = supplyBalance[msg.sender][Water];
        //requirements
        uint256 lithiumRequired = 2;
        uint256 waterRequired = 2;
        //requirement amount check
        uint256 lithiumRequiredAmount = 2 * _amount;
        uint256 waterRequiredAmount = 2 * _amount;
        //creations
        uint256 minimum = 2;
        uint256 H2min = _amount / 2;

        uint256 random = randomResult;
        emit RandomNumber(random);
        
        require(lithiumSupply >= lithiumRequiredAmount, 'Not Enough Lithium');
        require(waterSupply >= waterRequiredAmount, 'Not Enough Water');

        if(random < 10){  // check this variable
            emit LiOHCreationFailed("Failure");
            } else {
                
                    //work on burn batch problem
                    _burn(msg.sender, Lithium, lithiumRequiredAmount) ; //from, ids [], amounts []
                    supplyBalance[msg.sender][Lithium] -= lithiumRequiredAmount;
                    _burn(msg.sender, Water, waterRequiredAmount);
                    supplyBalance[msg.sender][Water] -= waterRequiredAmount;
                    _mint(msg.sender, LiOH, _amount, '');
                    supplyBalance[msg.sender][LiOH] += _amount;
                    _mint(msg.sender, H2, H2min, '');
                    supplyBalance[msg.sender][H2] += H2min;
                
                emit LiOHCreated(LiOH, msg.sender, _amount);
        }
        //queu up a random number
        getRandomNumber();
    }

    /* Using Chainlink Now
    // random section
    function randomize() private returns(uint256) {
        uint256 randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        seed = randomNumber;
        return seed;
    } */

    // chainlink
    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness % 100;
    }

    //function to pull out extra link
    function withdrawLink() public onlyOwner {
        require(LINK.transfer(msg.sender, LINK.balanceOf(address(this))), "Unable to transfer");
    }

    // URI overide for number schemes
    function uri(uint256 _tokenId) override public view returns (string memory) {
        return string(
            abi.encodePacked(
                Elements,
                Strings.toString(_tokenId),
                ".json"
            )
        );
    }

}
