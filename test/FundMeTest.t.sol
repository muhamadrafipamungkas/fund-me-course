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

    modifier funded() {
        vm.prank(USER); // Prank the USER to be the sender
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testMinimumFiveDollars() public view {
        // Assert Equal is for testing the value
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        console.log(fundMe.getOwner());
        console.log(msg.sender);
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); // Expect next line to got revert
        fundMe.fund();
    }

    function testFundUpdatesDataStructure() public funded {
        uint256 amountFunded = fundMe.getAddressToAmountFunded(address(USER));
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddFunderToArrayOfFunders() public funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, address(USER));
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert(); // Expect next line to got revert
        vm.prank(USER); // Prank the USER to be the sender
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingContractBalance = address(fundMe).balance;
        
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingContractBalance = address(fundMe).balance;

        assertEq(endingOwnerBalance, startingOwnerBalance + startingContractBalance);
        assertEq(endingContractBalance, 0);
    }

    function testWithdrawWithMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startOfFunderIndex = 1;

        for (uint160 i = startOfFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE); 
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingContractBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingContractBalance = address(fundMe).balance;

        assertEq(endingOwnerBalance, startingOwnerBalance + startingContractBalance);
        assertEq(endingContractBalance, 0);
    }

}
