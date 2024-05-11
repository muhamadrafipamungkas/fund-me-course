// 1. Deploy mock when we are on a local anvil chain
// 2. Keep track of the contract address on different chains
// Sepolia
// Mainnet

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";


contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;
    
    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainEthConfig();
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

    function getMainEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });

        return sepoliaConfig;
    }

    function getAnvilEthConfig() public returns (NetworkConfig memory) {
        // price feed address

        // 1. Deploy mock when we are on a local anvil chain
        // 2. Return the mock address

        vm.startBroadcast();
        MockV3Aggregator mockFeedPrice = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();

        NetworkConfig memory mockConfig = NetworkConfig({
            priceFeed: address(mockFeedPrice)
        });

        return mockConfig;
    }
}