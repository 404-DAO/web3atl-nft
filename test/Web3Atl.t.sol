// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Web3Atl.sol";
import "solmate/utils/MerkleProofLib.sol";

contract Web3AtlTest is Test {
    Web3Atl public web3atl;
    string public baseURI = "http://www.google.com";
    
    address someAddress = 0x0e77381EAeCd47696438EABaB9aF8859261837F3;

    function setUp() public {
        web3atl = new Web3Atl('Web3Atl Attendees','W3ATL', baseURI);
    }

    function testBaseURIAfterSetUp() public {
        assertEq(web3atl.baseURI(), baseURI);
    }

    function testSetBaseURI(string memory newBaseURI) public {
        web3atl.setBaseURI(newBaseURI);
        assertEq(web3atl.baseURI(), newBaseURI);
    }

    function testSetBaseURINotOwner(address addr, string memory newBaseURI) public {
        vm.prank(addr);
        vm.expectRevert();
        web3atl.setBaseURI(newBaseURI);
    }

    function testHackerMint() public {
        uint256 tokenID = web3atl.tokenID();
        
        vm.prank(someAddress);
        web3atl.hackerMint();
        
        assertEq(web3atl.tokenOwner(tokenID), someAddress);
        assert(web3atl.tokenType(tokenID) == Web3Atl.AttendeeTypes.HACKER);
        assert(web3atl.hackerClaimed(someAddress));
        
        uint256 newTokenID = web3atl.tokenID();
        assertEq(newTokenID - 1, tokenID);
    }

    function testHackerCannotMintTwice() public {
        vm.prank(someAddress);
        web3atl.hackerMint();
        
        vm.prank(someAddress);
        vm.expectRevert();
        web3atl.hackerMint();
    }

    function testGeneralMint() public {
        uint256 tokenID = web3atl.tokenID();

        vm.prank(someAddress);
        web3atl.generalMint();
        
        assertEq(web3atl.tokenOwner(tokenID), someAddress);
        assert(web3atl.tokenType(tokenID) == Web3Atl.AttendeeTypes.GENERAL);
        assert(web3atl.generalClaimed(someAddress));
        
        uint256 newTokenID = web3atl.tokenID();
        assertEq(newTokenID - 1, tokenID);
    }

    function testGeneralCannotMintTwice() public {
        vm.prank(someAddress);
        web3atl.generalMint();
        
        vm.prank(someAddress);
        vm.expectRevert();
        web3atl.generalMint();
    }
    
    function testTeamMint() public {
        uint256 tokenID = web3atl.tokenID();

        vm.prank(someAddress);
        web3atl.teamMint();
        
        assertEq(web3atl.tokenOwner(tokenID), someAddress);
        assert(web3atl.tokenType(tokenID) == Web3Atl.AttendeeTypes.TEAM);
        assert(web3atl.teamClaimed(someAddress));
        
        uint256 newTokenID = web3atl.tokenID();
        assertEq(newTokenID - 1, tokenID);
    }

    function testTeamCannotMintTwice() public {
        vm.prank(someAddress);
        web3atl.teamMint();
        
        vm.prank(someAddress);
        vm.expectRevert();
        web3atl.teamMint();
    }

    function testSpeakerMint() public {
        uint256 tokenID = web3atl.tokenID();

        vm.prank(someAddress);
        web3atl.speakerMint();
        
        assertEq(web3atl.tokenOwner(tokenID), someAddress);
        assert(web3atl.tokenType(tokenID) == Web3Atl.AttendeeTypes.SPEAKER);
        assert(web3atl.speakerClaimed(someAddress));
        
        uint256 newTokenID = web3atl.tokenID();
        assertEq(newTokenID - 1, tokenID);
    }

    function testSpeakerCannotMintTwice() public {
        vm.prank(someAddress);
        web3atl.speakerMint();
        
        vm.prank(someAddress);
        vm.expectRevert();
        web3atl.speakerMint();
    }

    function testTokenURI() public {
        uint256 tokenID = web3atl.tokenID();

        vm.prank(someAddress);
        web3atl.hackerMint();
        
        assertEq(web3atl.tokenURI(tokenID), string.concat(
                baseURI,
                "/",
                Strings.toString(uint256(web3atl.tokenType(tokenID))),
                ".json"
            ));
    }

    function testTransferFrom() public {
        uint256 tokenID = web3atl.tokenID();

        vm.prank(someAddress);
        web3atl.hackerMint();

        vm.expectRevert();
        web3atl.transferFrom(someAddress, 0xEBA5a8e3DcB4CFEFD3a3CBd420786eB6E6b1aDCf, tokenID);
    }

    function testSafeTransferFrom() public {
        uint256 tokenID = web3atl.tokenID();

        vm.prank(someAddress);
        web3atl.hackerMint();

        vm.expectRevert();
        web3atl.safeTransferFrom(someAddress, 0xEBA5a8e3DcB4CFEFD3a3CBd420786eB6E6b1aDCf, tokenID);
    }

    function testSafeTransferFromWithCallData(bytes calldata data) public {
        uint256 tokenID = web3atl.tokenID();

        vm.prank(someAddress);
        web3atl.hackerMint();

        vm.expectRevert();
        web3atl.safeTransferFrom(someAddress, 0xEBA5a8e3DcB4CFEFD3a3CBd420786eB6E6b1aDCf, tokenID, data);
    }
}
