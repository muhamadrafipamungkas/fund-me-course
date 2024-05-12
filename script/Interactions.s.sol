// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;
    function fundFundMe(address mostRecentDeployment) public {
        vm.startBroadcast();  
        FundMe(payable(mostRecentDeployment)).fund{value: SEND_VALUE}(); 
        vm.stopBroadcast();    
        console.log("FundMe funded with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecentDeployment);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentDeployment) public {
        vm.startBroadcast();  
        FundMe(payable(mostRecentDeployment)).withdraw(); 
        vm.stopBroadcast();    
    }

    function run() external {
        vm.startBroadcast();  
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentDeployment);
        vm.stopBroadcast();    
    }
}