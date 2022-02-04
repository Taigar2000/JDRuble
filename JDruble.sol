// SPDX-License-Identifier: GPL-3.0
// import "github.com/Arachnid/solidity-stringutils/strings.sol";

pragma solidity >=0.7.0 <0.9.0;
// pragma strings;

contract JDR {
    address public owner;
    JDruble jdruble;
    BlockReason[] public blockReasons;


    struct JDruble {
        uint256 totalSupply;
        uint256 maxTransactionSize;
    }

    struct BlockedUser {
        uint256 reasonCode;
        bool isTotalBlocked;
        uint256 blockLimit;
    }

    struct BlockReason {
        uint256 reasonCode;
        string reason;
    }

    mapping (address => uint256) public balances;

    mapping (address => BlockedUser) public blockedUsers;


    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function concateBytesArrs(bytes memory s1, bytes memory s2) internal pure returns (bytes memory _resstr) {
        bytes memory bstr = new bytes(s1.length + s2.length);
        uint i = 0;
        while(i < s1.length){
            bstr[i] = s1[i];
            i++;
        }
        while(i - s1.length < s2.length){
            bstr[i] = s2[i - s1.length];
            i++;
        }
        return bstr;
    }

    function getReason(uint256 rid) internal view returns (string memory _reason) {
        uint256 i = 0;
        for(i = 0; i < blockReasons.length; ++i)
            if (blockReasons[i].reasonCode == rid)
                return blockReasons[i].reason;
        return "";
    }

    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    event Minted(address who, uint256 amount);
    event OwnerChanged(address from, address to);
    event Transfered(address from, address to, uint256 amount);

    constructor() {
        owner = msg.sender;
    }
    
    function mint(uint256 amount) public isOwner {
        jdruble.totalSupply += amount;
        balances[msg.sender] += amount;
        emit Minted(msg.sender, amount);
    }
    
    function change_owner(address receiver) public isOwner {
        owner = msg.sender;
        emit OwnerChanged(msg.sender, receiver);
    }

    function blockUserSomeSum(address user, uint256 reasonId, uint256 blockedLimit) public isOwner {
        blockedUsers[user] = BlockedUser(reasonId, false, blockedLimit);
    }

    function blockUserTotally(address user, uint256 reasonId) public isOwner {
        blockedUsers[user] = BlockedUser(reasonId, true, 0);
    }

    function unblockUser(address user) public isOwner {
        blockedUsers[user] = BlockedUser(0, false, 0);
    }

    function addBlockReason(uint256 reasonId, string reason) public isOwner {
        
    }
    
    function transfer(address receiver, uint256 amount) public {
        require(amount>0, "Amount of JDRubles must be greater than 0");
        require(!blockedUsers[msg.sender].isTotalBlocked, "Your account was totally blocked");
        // require(balances[msg.sender] >= amount, "You can't send more than you have JDRubles (");
        require(balances[msg.sender] >= amount, 
            string(concateBytesArrs(
                concateBytesArrs(
                    bytes("You can't send more than you have JDRubles ("),
                    bytes(uint2str(balances[msg.sender]))
                ),
                bytes(")")
            ))
        );
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[receiver] += amount;
        emit Transfered(msg.sender, receiver, amount);
    }



}