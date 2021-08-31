pragma solidity ^0.8.6;

import "./bep.sol";

contract NToken is ExtendedBEP20 {
    uint256 timeFromLastEmit;
    uint16 constant year = 365;
    
    constructor(address owner) ExtendedBEP20("NTtoken", "NT", owner) {
        timeFromLastEmit = block.timestamp;
        _mint(owner, 10 ** 20);
    }

    function mintAnually() external onlyOwner() {
        require(timeFromLastEmit + year * 1 days <= block.timestamp);
        _mint(owner(), 10 ** 2);
        timeFromLastEmit = block.timestamp;
    }

    function burn(uint256 amount) external {
        require(totalSupply() > 100, "Total supply is limited");
        _burn(_msgSender(), amount);
    }
}