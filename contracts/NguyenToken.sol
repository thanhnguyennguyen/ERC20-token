pragma solidity ^0.4.22;
import "./ERC20Token.sol";

contract NguyenToken is ERC20Token {
    address private manager;

  // Maintain the balance in a mapping
    mapping(address => uint256)  balances;

  // Allowances
  // Two dimensional associative array
  // index-1 = Owner account   index-2 = spender account
    mapping(address => mapping (address => uint256)) allowances;

  /// emit from Burning event
    event Burn(address indexed _burnerm, uint256 indexed _value);

  /// emit from issue event
    event Issue(address indexed _burnerm, uint256 indexed _value);

    constructor(uint _totalSupply) public {
        name = "NguyenNguyen Token";
        symbol = "NGUYEN";
        totalSupply = _totalSupply;
        decimals = 0;

        // Set the sender as the owner of all the initial set of tokens
        // Declare the balances mapping
        balances[msg.sender] = totalSupply;
        manager = msg.sender;
    }

    // Anyone can call this constant function to check the balance of tokens for an address
    function balanceOf(address _someone) public view returns (uint256 balance){
        return balances[_someone];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
          // Return false if specified value is less than the balance available
        if(balances[msg.sender] < _value) {
            return false;
        }
        if (_to == 0x0) revert("avoid burning"); // avoid burning
        // Reduce the balance by _value
        balances[msg.sender] -= _value;

        // Increase the balance of the receiever that is account with address _to
        balances[_to] += _value;

        // Declare & Emit the transfer event
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    // How many tokens can spender spend from owner's account
    function allowance(address _owner, address _spender) public view returns (uint remaining){
        //1. Declare a mapping to manage allowances
        //2. Return the allowance for _spender approved by _owner
        return allowances[_owner][_spender];
    }

    // Approval - sets the allowance
    function approve(address _spender, uint256 _value) public returns (bool success) {
        if(_value <= 0) return false;

        // 3. Simply add/change the amount in allowances
        allowances[msg.sender][_spender] = _value;

        // 4. Declare the Approval event and emit it
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    // Transfer from
    // B transfer _value from A's account to C' account
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
      // Multiple if statements to make it easy to understand
      // a) b) c) below may be combined with && in one statememnt

        // a) Specified _value must be > 0
        if(_value <= 0) return false;

        if (_to == 0x0) revert("avoid burning"); // avoid burning
        // b) Check if _spender allowed to spend the specified _value from _from account
        // Spender's address = msg.sender
        if(allowances[_from][msg.sender] < _value) return false;

        // c) Check if the _from has enough tokens
        if(balances[_from] < _value) return false;

        // Reduce the balance _from
        balances[_from] -= _value;
        // Increase the balance _to
        balances[_to] += _value;

        // Reduce the allowance for spender
        allowances[_from][msg.sender] -= _value;

        // Emit a transfer event
        emit Transfer(_from, _to, _value);

        return true;
    }

    // burn tokens
    function burn(uint _number) public {
        require(_number > 0 && balances[msg.sender] > _number, "number of tokens is invalid");
        // Reduce the balance by _value
        balances[msg.sender] -= _number;
        // Reduce total supply
        totalSupply -= _number;
        // Declare & Emit the transfer event
        emit Burn(msg.sender, _number);
    }

    modifier onlyManager() {
        require(msg.sender == manager, "not contract creator");
        _;
    }

    // issue more tokens
    function increaseTotalSupply(uint _number) public onlyManager {
        require(_number > 0, "number token is invalid");
        // Increase the balance by _value
        balances[msg.sender] += _number;
        // Increase total supply
        totalSupply += _number;
        // Declare & Emit the transfer event
        emit Issue(msg.sender, _number);
    }

    // withdraw ether from contract
    // accept integer only
    function withdrawEther(address _to, uint _amount) public onlyManager {
        uint amountInWei = uint(_amount * (1 ether));
        require(address(this).balance >= amountInWei);
        _to.transfer(amountInWei);
    }

    // withdraw all ether
    function withdrawAllEther(address _to) public onlyManager {
        _to.transfer(address(this).balance);
    }

    // get contract balance in ether
    function getBalance() public view returns (uint) {
        return address(this).balance;    
    }

    // self destruction
    function killContract() public onlyManager {
        selfdestruct(manager);
    }

    // Fallback function
    // accept purchasing by ethers
    function() public payable {
        require(msg.value >= 1 ether, "at least 1 ether");
        uint num = uint(msg.value / (1 ether));
        require(balances[manager] >= num, "run out of tokens to sell");
        // Reduce the balance by _value
        balances[manager] -= num;

        // Increase the balance of the receiever that is account with address _to
        balances[msg.sender] += num;
        // Declare & Emit the transfer event
        emit Transfer(manager, msg.sender, num);
    }
}
