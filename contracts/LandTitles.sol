pragma solidity ^0.5.0;

import "./ERC721.sol";
import "./ERC721Enumerable.sol";
import "./ERC721Metadata.sol";
import "./ERC721Mintable.sol";
import "./ERC721Metadata.sol";



// interface ERC721 /* is ERC165 */ {
//     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
//     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
//     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

//     function balanceOf(address _owner) external view returns (uint256);
//     function ownerOf(uint256 _tokenId) external view returns (address);
//     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
//     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
//     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
//     function approve(address _approved, uint256 _tokenId) external payable;
//     function setApprovalForAll(address _operator, bool _approved) external;
//     function getApproved(uint256 _tokenId) external view returns (address);
//     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
// }

// interface ERC165 {
//     function supportsInterface(bytes4 interfaceID) external view returns (bool);
// }

// interface ERC721TokenReceiver {
//     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
// }

/**
 * @title Full ERC721 Token
 * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
 * Moreover, it includes approve all functionality using operator terminology.
 *
 * See https://eips.ethereum.org/EIPS/eip-721
 */
contract cLand is ERC721, ERC721Enumerable, ERC721Metadata, ERC721Mintable {
    address public admin;

    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
        // solhint-disable-previous-line no-empty-blocks
        admin = msg.sender;
    }

    struct proposal{
        address proposer;
        string content;
        uint titleId;
    }

    proposal[] public proposals;
    mapping(uint => string) contents;

    function propose(string memory content,uint titleId) public {
        proposal memory p = proposal(msg.sender,content,titleId);
        proposals.push(p);
    }

    function approveProposal(uint proposalId) public {
        require(admin==msg.sender);
        transferFrom(address(this),proposals[proposalId].proposer,proposals[proposalId].titleId);
    }

    function issueTitle(string memory content) public{
        require(msg.sender==admin);
        mint(address(this),totalSupply());
        approve(address(this),totalSupply()-1);
    }

}
