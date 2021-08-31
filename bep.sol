pragma solidity ^0.8.6;

import "./ownable.sol";
import "./ibep.sol";

contract ExtendedBEP20 is IBEP20, Ownable {      
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_, address owner_) Ownable (owner_) {
        _name = name_;
        _symbol = symbol_;
    }
    
    receive() external payable {    
        payable(owner()).call{value: msg.value}; 
    }

    function name() external virtual view returns (string memory) {
        return _name;
    }
    
    //required method
    function symbol() external virtual override view  returns (string memory) {
        return _symbol;
    }
    
    //required method
    function decimals() public virtual override pure returns (uint8) {
        return 10;
    }

    function totalSupply() public virtual override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external virtual view returns (uint256 balance) {
        return _balances[account];
    }
    
    //required method
    function getOwner() external virtual view override returns (address){
        return owner();
    }

    function transfer(address to, uint256 amount) external virtual override returns (bool) {
        _transfer(_msgSender(), to, amount);     
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external virtual override returns (bool) {
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount);
        _transfer(sender, recipient, amount);
        _allowances[sender][_msgSender()] -= amount;
        return true;
    }

    function approve(address spender, uint256 amount) external virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
 
    function allowance(address tokenOwner, address spender) external virtual override view returns (uint256) {
        return _allowances[tokenOwner][spender];
    }
    
    //increase... & decrease... called by the asset owner
    //in order to avoid the attack if allowances[owner][spender]!=0
    function increaseAllowance(address spender, uint256 addValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subValue, "BEP20: decreased allowance below zero");
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subValue);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");
        require(_balances[sender] >= amount, "Unappropriate amount for transfer");

        _balances[sender] -= amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _approve(
        address tokenOwner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(amount <= _totalSupply, "Unappropriate amount for transfer"); 
        require(tokenOwner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[tokenOwner][spender] = amount;
        emit Approval(tokenOwner, spender, amount);
    }

    function _mint(address account, uint amount) internal virtual {
        require(account != address(0), "Mint to the zero address");

        _balances[account] += amount;
        _totalSupply += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint amount) internal virtual {
        require(account != address(0), "Burn from the zero address");
        require(amount <= _balances[account], "Amount for burning larger than balance"); 

        _balances[account] -= amount;
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }
}