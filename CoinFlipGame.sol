// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

contract CoinFlipGame {
    struct Bet {
        address user;
        uint256 betAmount;
        bool prediction;
    }
    mapping(address => bool) public isOldUser;
    mapping(address => uint256) public balance; // for balance of user
    Bet[] public ongoingBets; // will store the list of all pending bets.
    mapping(address => bool) public hasOngoingBet; //this will check if the user has any pending bet
    Bet[] public completedBets;
    event Win(address gambler, uint256 betAmount);

    function placeBet(uint256 _betAmount, bool _prediction) external {
        if (isOldUser[msg.sender] == false) {
            balance[msg.sender] = 100; //Give free 100 points to new user
            isOldUser[msg.sender] = true;
        }

        require(
            hasOngoingBet[msg.sender] == false,
            "User already has a pending bet. Cannot bet again."
        ); // checking if he has a pending bet
        require(balance[msg.sender] >= _betAmount, "Not enough balance");

        balance[msg.sender] -= _betAmount; // deducting bet amount from his acc
        Bet memory newbet; // creating a new bet for the user
        newbet.user = msg.sender;
        newbet.betAmount = _betAmount;
        newbet.prediction = _prediction;
        ongoingBets.push(newbet); // adding the user's bet to pending bets list
        hasOngoingBet[msg.sender] = true; // set hasPendingBet to true so that he cannot bet again before his bet is settled.
    }

    //Harmony's vrf function generate the result of bet
    function vrf() internal view returns (bytes32 result) {
        uint256[1] memory bn;
        bn[0] = block.number;
        assembly {
            let memPtr := mload(0x40)
            if iszero(staticcall(not(0), 0xff, bn, 0x20, memPtr, 0x20)) {
                invalid()
            }
            result := mload(memPtr)
        }
    }

    function rewardBets() external {
        bytes32 res = vrf(); //calling vrf function to generate random result of coinflip in bytes32 type
        bool betResult;
        if ((uint256(res)) % 2 == 0)
            betResult = false; //converting bytes32 to bool
        else betResult = true;

        for (uint256 i = 0; i < ongoingBets.length; i++) {
            //iterating over all the pending bets
            Bet memory currBet = ongoingBets[i];
            if (currBet.prediction == betResult) {
                // if user wins add 2x the bet amount to his balance
                balance[currBet.user] += 2 * currBet.betAmount;
                emit Win(currBet.user, currBet.betAmount);
            }
            // since his bet is resolved he has no pending bet and can bet again now
            hasOngoingBet[currBet.user] = false;

            completedBets.push(currBet);
        }
        delete ongoingBets;
    }
}
