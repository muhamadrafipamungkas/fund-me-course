// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol"; 
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {

    function run() public returns (FundMe) {
        // Before vm.startBoadcast() is not real transaction / don't spend gas
        HelperConfig helperConfig = new HelperConfig();
        address priceFeed = helperConfig.activeNetworkConfig();

        // After vm.startBoadcast() is real transaction / spend gas
        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}