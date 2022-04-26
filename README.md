# CoinFlipGame
Web3 Solidity Challenge: Coin Flip Task assignment 

    Deployed Contract Address:0x8123977D51A4710c3142705D1548cD516B062942
             Harmony Address: one1sy3ewl2353cscv2zwpw32jxd294sv22zz9007p


    IMPORTANT NOTES:
       1) VERY IMP: I was not able to enter false boolean value in the Harmony Blockchain Explorer whereas it was working fine when I interacted through Remix.I'm guessing it is a bug/issue in the Harmony explorer bool type input box. So use Remix or some other way instead of Harmony to interact with the the contract.
       2)My transactions for testing are available on earlier contracts not this one as I deployed a fresh contract while uploading to github.
       

    TESTING:

        1) Placed a bet using one account and ensured I am unable to bet again while my bet is ongoing and checked the balances and ongoingBet list.
        2) Placed bets from three more accounts with diffrent predictions and betvalues. Noted their balances and checked ongoinbet list.
        3) Called RewardBet function to ensure everyone got the correct balance updates after bet settlement.
        4) Checked ongoingBet list is empty and completeBet list contains the settle bets.
        5) Repeated the process to ensure one can bet again after his bet is settled.
        6) Kept checking read values at every stage and confirmed only new users get 100 free points.
