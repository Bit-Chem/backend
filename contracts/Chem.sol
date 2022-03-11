//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./WBTC.sol";

import "hardhat/console.sol";

/*
interface IWBTC {
    function mint(address _account, uint256 _amount) external;
} */

contract Chem is ERC1155, Ownable {

    WBTC public wbtcContract;

    //Bare Elements
    uint256 public constant Hydrogen = 1;
    uint256 public constant Helium = 2;
    uint256 public constant Lithium = 3;
    uint256 public constant Beryllium = 4;
    uint256 public constant Oxygen = 8;
    //Merged Elements
    uint256 public constant Water = 200;
    uint256 public constant PureWater = 201;

    //Beakers
    uint256 public constant cheapBeaker = 1000;
    uint256 public constant regularBeaker = 1001;
    uint256 public constant epicBeaker = 1002;
    //seed
    uint256 private seed; //seed used to randomize

    string public Elements = 'ipfs://QmcJ1bQbBR3hUos1UaLm7v2mFxJ9ykHEV5zLLmYWpcp8BN/';  

    mapping(address => mapping (uint256 => uint256))  public supplyBalance;
    mapping(address =>uint256)  public btcTokenBalance; 
    

    constructor(address _address) ERC1155(Elements) {
        
        wbtcContract = WBTC(_address);
    }


    //set contract for WBTC - if need to change
    function setwbtcContract(address addr) public onlyOwner {
        wbtcContract = WBTC(addr);
    } 
 
    //Mint wBTC
    function mintBTC(uint256 _amount) public {
        wbtcContract.mint(msg.sender, _amount);
        btcTokenBalance[msg.sender] += _amount;
    }  

    //Stake wBTC
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
        mintCheapBeaker(10);
        mintEpicBeaker(10);
        mintRegularBeaker(10);
    }

    //Sell Crafted Elements
    function sellNFT(uint256 _amount) public { // for now water 200 pureW 201
        require(_amount >= Water && _amount <= PureWater, "Not Valid Creation");
        console.log("passed the requirement");
        uint256 reward = 2;
        if(_amount == Water) {
            uint256 newReward = 2;
            reward = reward / newReward;
            console.log("reward value", reward);
            _burn(msg.sender, Water, 1) ; //from, ids [], amounts []
            supplyBalance[msg.sender][Water] -= reward;
            wbtcContract.transfer(msg.sender, reward); // make sure enough in contract
            btcTokenBalance[msg.sender] += reward;
        } else if(_amount == PureWater){
            _burn(msg.sender, Water, 1) ; //from, ids [], amounts []
            supplyBalance[msg.sender][Water] -= reward;
            wbtcContract.transfer(msg.sender, reward); // make sure enough in contract
            btcTokenBalance[msg.sender] += reward;
        }
    }

    // Mint Elements
    function mintHydrogen(uint256 _amount) public {
        _mint(msg.sender, Hydrogen, _amount, "");
        supplyBalance[msg.sender][Hydrogen] = supplyBalance[msg.sender][Hydrogen] + _amount;
    }

    function mintHelium(uint256 _amount) public {
        _mint(msg.sender, Helium, _amount, "");
        supplyBalance[msg.sender][Helium] =supplyBalance[msg.sender][Helium] + _amount;
    }

    function mintLithium(uint256 _amount) public {
        _mint(msg.sender, Lithium, _amount, "");
        supplyBalance[msg.sender][Lithium] = supplyBalance[msg.sender][Lithium] + _amount;
    }

    function mintBeryllium(uint256 _amount) public {
        _mint(msg.sender, Beryllium, _amount, "");
        supplyBalance[msg.sender][Beryllium] = supplyBalance[msg.sender][Beryllium] + _amount;
    }

    function mintOxygen(uint256 _amount) public {
        _mint(msg.sender, Oxygen, _amount, "");
        supplyBalance[msg.sender][Oxygen] = supplyBalance[msg.sender][Oxygen] + _amount;
    }

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

    function name() public pure returns (string memory) {
        return "Elements";
    }

    function symbol() public pure returns (string memory) {
        return "ELMT";
    }  

    // to move to 2nd contract
    //Elemental Merging
    function createWater(uint256 _beaker)public {
        //inventory
        uint256 hydrogenSupply = supplyBalance[msg.sender][Hydrogen];
        uint256 oxygenSupply = supplyBalance[msg.sender][Oxygen];
        //requirements
        uint256 hydrogenRequired = 2;
        uint256 oxygenRequired = 1;
        //creations
        uint256 minimum = 1;
        //uint256 bonus = 2;
        
        require(hydrogenSupply >= hydrogenRequired, 'Not Enough Hydrogen');
        require(oxygenSupply >= oxygenRequired, 'Not Enough Oxygen');
        require(_beaker >=cheapBeaker && _beaker <=epicBeaker, 'Not a valid Beaker');

        //work on burn batch problem
        _burn(msg.sender, Hydrogen, hydrogenRequired) ; //from, ids [], amounts []
        supplyBalance[msg.sender][Hydrogen] -= hydrogenRequired;
        _burn(msg.sender, Oxygen, oxygenRequired);
        supplyBalance[msg.sender][Oxygen] -= oxygenRequired;

        uint256 random = randomize();
        console.log("random number is:", random);

        if(_beaker == cheapBeaker) {

            if(random > 50){
                _mint(msg.sender, Water, minimum, '');
                supplyBalance[msg.sender][Water] +=  minimum;
            } else {
                 console.log("bonus hit");
                _mint(msg.sender, PureWater, minimum, '');
                supplyBalance[msg.sender][PureWater] += minimum;
            }
        } else if(_beaker == regularBeaker){
            if(random > 70){
                _mint(msg.sender, Water, minimum, '');
                supplyBalance[msg.sender][Water] +=  minimum;
            } else {
                 console.log("bonus hit");
                _mint(msg.sender, Water, minimum, '');
                supplyBalance[msg.sender][PureWater] += minimum;
            }
        } else {
            if(random > 95){
                _mint(msg.sender, Water, minimum, '');
                supplyBalance[msg.sender][Water] +=  minimum;
            } else {
                 console.log("bonus hit");
                _mint(msg.sender, Water, minimum, '');
                supplyBalance[msg.sender][PureWater] += minimum;
            }
        }
    }  

    function randomize() private returns(uint256) {
        uint256 randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        seed = randomNumber;
        return seed;
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
