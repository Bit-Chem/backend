//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

contract Chem is ERC1155 {

    uint256 public constant Hydrogen = 1;
    uint256 public constant Helium = 2;
    uint256 public constant Lithium = 3;
    uint256 public constant Beryllium = 4;

    string public Elements = 'ipfs://QmdNUgcnYQ7DWXXkdCZB2JTBXfhtPbUzBz9LjM4xLBJ2mv/';
    

    constructor() ERC1155(Elements) {

        _mint(msg.sender, Hydrogen, 2, "Hydro");
        _mint(msg.sender, Helium, 10, "");
        _mint(msg.sender, Beryllium, 11, "Beryllium");
      
    }

    function mintElements(uint256 _amount) public {
        _mint(msg.sender, Lithium, _amount, "Lithium");
    }

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
