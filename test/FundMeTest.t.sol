// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {

    // Make it storage variable to make it accessible on all test function
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 SEND_VALUE = 0.1 ether;
    
    // This will be called before any test
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, 10 ether); // Give USER 10 ether
    }

    function testMinimumFiveDollars() public view {
        // Assert Equal is for testing the value
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); // Expect next line to got revert
        fundMe.fund();
    }

    function testFundUpdatesDataStructure() public {
        vm.prank(USER); // Prank the USER to be the sender
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(address(USER));
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddFunderToArrayOfFunders() public {
        vm.prank(USER); // Prank the USER to be the sender
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, address(USER));
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.prank(USER); // Prank the USER to be the sender
        fundMe.fund{value: SEND_VALUE}();

        vm.expectRevert(); // Expect next line to got revert
        vm.prank(USER); // Prank the USER to be the sender
        fundMe.withdraw();
    }
}
