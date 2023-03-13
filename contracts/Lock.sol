// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract RandomWinnerGame is VRFConsumerBase, Ownable {
    //Chainlink variables
    // The amount of LINK to send with the request
    uint256 public fee;

    // ID of public key against which randomness is generated
    bytes32 public keyHash;

    // Address of the players
    address[] public players;

    //Max number of players in one game
    uint8 maxPlayers;

    // Variable to indicate if the game has started or not
    bool public gameStarted;

    // the fees for entering the game
    uint256 entryFee;

    // current game id
    uint256 public gameId;

    // emitted when the game starts
    event GameStarted(uint256 gameId, uint8 maxPlayers, uint256 entryFee);
    // emitted when someone joins a game
    event PlayerJoined(uint256 gameId, address player);
    // emitted when the game ends
    event GameEnded(uint256 gameId, address winner, bytes32 requestId);

    /**
     * constructor inherits a VRFConsumerBase and initiates the values for keyHash, fee and gameStarted
     * @param vrfCoordinator address of VRFCoordinator contract
     * @param linkToken address of LINK token contract
     * @param vrfFee the amount of LINK to send with the request
     * @param vrfKeyHash ID of public key against which randomness is generated
     */
    constructor(
        address vrfCoordinator,
        address linkToken,
        bytes32 vrfKeyHash,
        uint256 vrfFee
    ) VRFConsumerBase(vrfCoordinator, linkToken) {
        keyHash = vrfKeyHash;
        fee = vrfFee;
        gameStarted = false;
    }

    /**
     * startGame starts the game by setting appropriate values for all the variables
     */
    function startGame(uint8 _maxPlayers, uint256 _entryFee) public onlyOwner {
        // Check if there is a game already running
        require(!gameStarted, "Game is currently running");
        // empty the players array
        delete players;
        // set the max players for this game
        maxPlayers = _maxPlayers;
        // set the game started to true
        gameStarted = true;
        // setup the entryFee for the game
        entryFee = _entryFee;
        gameId += 1;
        emit GameStarted(gameId, maxPlayers, entryFee);
    }

    
}
