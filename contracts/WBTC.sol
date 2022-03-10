//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";




contract WBTC is ERC20 {

    address public minter;   
    mapping(address =>uint256)  public tokenBalance; 

    //Emit the event that the minter change
    event MinterChange(address indexed from, address to);

    constructor() ERC20("Wrapped Bitcoin", "WBTC") {
        //Set owner address
        minter = msg.sender;
     //   console.log("Minter address set to:", minter);
    }

    function mint(address _account, uint256 _amount) public {
       // require(msg.sender == minter, 'Error, msg.sender does not have minter role');
        _mint(_account, _amount);
        tokenBalance[msg.sender] += _amount;
    }

    //Make this a global variable name instead of local
    function passMinterRole(address _newAddress) public returns(bool) {
        require(msg.sender == minter);
        minter = _newAddress;

        emit MinterChange(msg.sender, _newAddress);
        return true;
    }

}