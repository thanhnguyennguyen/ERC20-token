[![Build Status](https://travis-ci.com/thanhnguyennguyen/ERC20-token.svg?branch=master)](https://travis-ci.com/thanhnguyennguyen/ERC20-token)
# Why do we need ERC20 ?
![](https://i.imgur.com/GxKX5Fn.jpg)

# ERC20-token
![](https://i.imgur.com/8eMsHwg.jpg)
![](https://i.imgur.com/jkLhW5G.jpg)
![](https://i.imgur.com/IKnmPjT.jpg)
![](https://i.imgur.com/ZPgaJcO.jpg)
## Name: NguyenNguyen Token
## Symbol: NGUYEN
## Decimal: 0
## Etherscan: https://rinkeby.etherscan.io/token/0x3cba1b68282ee7706684aa11165543178b1d4e57
# Docker: nguyennguyen/erc20
# Testing: <code>truffle test</code>
Please never write code without tests

# ERC-20 withdrawal from smartcontract pattern
```
contract TokenInterface {
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function balanceOf(address _owner) public view returns (uint balance);
}
function claimTokens (address token) public onlyOwner returns (bool){
                TokenInterface _instance = TokenInterface(address);    
                uint amount = _instance.balanceOf(contractAddress)
                _instance.transfer(contractAddress, msg.sender, amount));
                return true;
            }
```


