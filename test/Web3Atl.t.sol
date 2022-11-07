// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Web3Atl.sol";

contract Web3AtlTest is Test {
    Web3Atl public web3atl;

    function setUp() public {
        web3atl = new Web3Atl('Web3Atl Attendees','W3ATL');
    }

}
