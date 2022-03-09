//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

contract Chem is ERC1155 {

    //Bare Elements
    uint256 public constant Hydrogen = 1;
    uint256 public constant Helium = 2;
    uint256 public constant Lithium = 3;
    uint256 public constant Beryllium = 4;
    uint256 public constant Oxygen = 8;
    //Merged Elements
    uint256 public constant Water = 200;
    //Beakers
    uint256 public constant cheapBeaker = 1000;
    uint256 public constant regularBeaker = 1001;
    uint256 public constant epicBeaker = 1002;
    //seed
    uint256 private seed; //seed used to randomize

    string public Elements = 'ipfs://QmcJ1bQbBR3hUos1UaLm7v2mFxJ9ykHEV5zLLmYWpcp8BN/';  

    mapping(address => mapping (uint256 => uint256))  public supplyBalance;
    

    constructor() ERC1155(Elements) {

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
    function createWater()public {
        //inventory
        uint256 hydrogenSupply = supplyBalance[msg.sender][Hydrogen];
        uint256 oxygenSupply = supplyBalance[msg.sender][Oxygen];
        //requirements
        uint256 hydrogenRequired = 2;
        uint256 oxygenRequired = 1;
        //creations
        uint256 minimum = 1;
        uint256 bonus = 2;
        
        require(hydrogenSupply >= hydrogenRequired, 'Not Enough Hydrogen');
        require(oxygenSupply >= oxygenRequired, 'Not Enough Oxygen');

        //work on burn batch problem
        _burn(msg.sender, Hydrogen, hydrogenRequired) ; //from, ids [], amounts []
        supplyBalance[msg.sender][Hydrogen] = supplyBalance[msg.sender][Hydrogen] - hydrogenRequired;
        _burn(msg.sender, Oxygen, oxygenRequired);
        supplyBalance[msg.sender][Oxygen] = supplyBalance[msg.sender][Oxygen] - oxygenRequired;

        uint256 random = randomize();
        console.log("random number is:", random);

        if(random > 50){
        _mint(msg.sender, Water, minimum, '');
        supplyBalance[msg.sender][Water] = supplyBalance[msg.sender][Water] + minimum;
        } else {
        console.log("bonus hit");
        _mint(msg.sender, Water, 2, '');
        supplyBalance[msg.sender][Water] =  supplyBalance[msg.sender][Water] + bonus;
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
