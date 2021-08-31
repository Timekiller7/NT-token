pragma solidity ^0.8.6;

//for meta transactions
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}
