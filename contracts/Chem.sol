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

    string public Elements = 'ipfs://QmfLahwBhRCuMP29EqH5X1iNjgAXcwLgn3yGfQkqCL9aMi/';  
    

    constructor() ERC1155(Elements) {
        _mint(msg.sender, Hydrogen, 1,'');
    }

    // Mint Elements
    function mintHydrogen(uint256 _amount) public {
        _mint(msg.sender, Hydrogen, _amount, "");
    }

    function mintHelium(uint256 _amount) public {
        _mint(msg.sender, Helium, _amount, "");
    }

    function mintLithium(uint256 _amount) public {
        _mint(msg.sender, Lithium, _amount, "");
    }

    function mintBeryllium(uint256 _amount) public {
        _mint(msg.sender, Beryllium, _amount, "");
    }

    // to move to 2nd contract
    //Elemental Merging
    function createWater()public {
        //work on burn batch problem
        _burn(msg.sender, Hydrogen, 2) ; //from, ids [], amounts []
        _burn(msg.sender, Helium, 1);
        _mint(msg.sender, Water, 1, '');
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
