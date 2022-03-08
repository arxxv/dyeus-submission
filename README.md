# dyeus-web3-submission

# Coin Betting Dapp

The code contains two contracts (Game and GameFactory). While Game handles the main logic of the game, GameFactory handles multiple games.

## Some of the features

1. Only the initiator can flip the coin, end the game, etc.
2. The game cannot end without coin being tossed.
3. Player cannot bet without joining the game.
4. A player cannot bet again if they have already place a bet in the same game.
5. Bet has to be a between 0 and the player's balance.
6. A player can bet only using 0 (tail) and 1 (head)
7. Players cannot join or bet once the game is over.

## Testnet deployment address: 0xfdd74899Eb5a01e9a8dc0eFfE752075838e077fE 

## Screenshots

Each player is given 100 Ether for better visiual response while testing. The code has the limit of 100 wei.

1. Deployed GameFactory
   <img src="https://github.com/arxxv/dyeus-submission/blob/main/images/1.jpg" alt="Deployed GameFactory" width="1200"/>

2. Created a game. The new game gets push to the liveGames array
   <img src="https://github.com/arxxv/dyeus-submission/blob/main/images/2.jpg" alt="Created a game. The new game gets push to the liveGames array" width="1200"/>

3. Changed the account and joined the game
   <img src="https://github.com/arxxv/dyeus-submission/blob/main/images/3.jpg" alt="Changed the account and joined the game" width="1200"/>

4. Going to bet on tail (0) with 10 ether
   <img src="https://github.com/arxxv/dyeus-submission/blob/main/images/4.jpg" alt="Deployed GameFactory" width="1200"/>

5. Bet successful
   <img src="https://github.com/arxxv/dyeus-submission/blob/main/images/5.jpg" alt="Bet successful" width="1200"/>

6. Joined and placed a bet on heads (1) of 5 ether with third account
   <img src="https://github.com/arxxv/dyeus-submission/blob/main/images/6.jpg" alt="Joined and placed a bet on heads (1) of 5 ether with third account" width="1200"/>

7. Trying to run flipCoin with the same account (Not the initiator of the game). Fails
   <img src="https://github.com/arxxv/dyeus-submission/blob/main/images/7.jpg" alt="Deployed GameFactory" width="1200"/>

8. Flipped the coin with the initiator account. tossValue shows that the toss resulted in head
   <img src="https://github.com/arxxv/dyeus-submission/blob/main/images/8.jpg" alt="Flipped the coin with the initiator account. tossValue shows that the toss resulted in head" width="1200"/>

9. Ending the game with endGame function
   <img src="https://github.com/arxxv/dyeus-submission/blob/main/images/9.jpg" alt="Ending the game with endGame function" width="1200"/>

10. The game is removed from liveGames and is pushed to staleGames array.
    <img src="https://github.com/arxxv/dyeus-submission/blob/main/images/10.jpg" alt="Final balances of every player" width="1200"/>
