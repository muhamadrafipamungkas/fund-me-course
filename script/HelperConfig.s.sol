// 1. Deploy mock when we are on a local anvil chain
// 2. Keep track of the contract address on different chains
// Sepolia
// Mainnet

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";


contract HelperConfig {
    NetworkConfig public activeNetworkConfig;
    
    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }
    function getAnvilEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
    }
}