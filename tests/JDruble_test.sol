// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../contracts/JDruble.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {

    JDR jdr;
    address owner;


    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    /// #sender: account-1
    /// #value: 10
    function beforeAll() public payable {
        // <instantiate contract>
        jdr = new JDR();
        owner = jdr.owner();
        // Assert.equal(msg.sender, TestsAccounts.getAccount(1), "Account"); // true
        // Assert.equal(owner, TestsAccounts.getAccount(1), "Account"); // false ??!!!
    }

    function checkGetAllReasons() public {
        Assert.equal(jdr.getAllReasons(), "0:\tNot blocked\n", "Reason must be default");
    }

    // function checkIsOwner() public {
    //     Assert.equal(jdr.owner(), owner, "Creator must be owner");
    //     Assert.equal(jdr.owner(), TestsAccounts.getAccount(2), "Not creator must be not owner");
    // }

    function checkgetReason() public {
        Assert.equal(jdr.getReason(0), "Not blocked", "Reason must be default");
    }

    // /// #sender: account-1
    // /// #value: 10
    // function checkMint() public payable {
    //     jdr.mint(100);
    //     Assert.equal(jdr.balances(msg.sender), 100, "Balance not emmited");
    // }

    /// #sender: account-1
    /// #value: 10
    function checkNotTransfer() public payable {
        jdr.transfer(TestsAccounts.getAccount(2), 10);
        Assert.equal(jdr.balances(msg.sender), 0, "Transfer correct but must be not");
    }


}
    