# SafeTransactions

This project consists of a smart contract that ensures safe transaction between a seller and a buyer.  
The seller needs to transfer a deposit to the contract upon creation.  
The buyer needs to transfer a deposit to the contract when purchasing.  
In order for the buyer to receive back his deposit, he needs to invoke the "confirmPurchase()" function.  
The seller can then receive their deposit + the sale value.  

The idea is to create an incentive for both parties to act honestly to avoid scams.

--------------------------------------------------------------

## How to run the code  

The code can be run and tested on the online Remix IDE found at remix.ethereum.org  <br/>

1. Go into the file PurchaseAgreement.sol  
2. Copy the code either by highlighting it all and copying or clicking the "Copy raw contents" button  
3. Go to remix.ethereum.org  <br/>

Note: The compiler on the Remix IDE is by default set to 0.8.7, set it to 0.8.11 and save the code
