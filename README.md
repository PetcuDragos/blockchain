# Crypto-Market  -  A smart-contract
We tried to make an application that will use the blockchain in order to learn more about solidity, web3, and smart contracts.
<br>Members:
<br>Nenisca Maria
<br>Paun Tudor
<br>Petcu Dragos
<br>Ninicu Radu

# Overview

This is cryptomarket. Here you can buy assets like skins/loot/consumables that are unique from any game that posts here the item.
Games like CS:GO, League of Legends, or many more can sell on this blockchain their unique assets.
The cool part is that you can buy these assets, use them, and even resell them.
Another cool feature that we implemented is a bidding process for these items.
If you think you should let others decide the price of your asset you can let them bid for it and when the time is up the winner takes it all, at a fair price of course.

# Pre-requisites
We have used Remix IDE in order to make the contract and we have developed it with the power of Solidity, but also error and trial power.


# Setup and Build Plan

1) Well first thing you would need to add all the files from contracts with the extension .sol to the Remix IDE or any other IDE. 
2) Compile them firstly so that the artifacts will be generated along with the ABI.
3) Make sure you have Metamask installed for your browser. 
4) You might want to use a test network and add some eth in your account.
5) Deploy the Service.sol contract with InjectedWeb3.( you might have to set the gas up to 400000)
6) Copy the adress of the contract and type it into the file WebApp/utility.js in the first line at contractAdress. 
7) Make sure that you have npm installed firstly and then install http-server through npm.
8) Go into the WebApp folder and start an http server. 
9) In browser connect to localhost:8080 and all things should work. 

# Demo - WebApp 

![alt text](https://github.com/PetqDrekoj/blockchain/blob/master/img1.PNG)
![alt text](https://github.com/PetqDrekoj/blockchain/blob/master/img2.PNG)
![alt text](https://github.com/PetqDrekoj/blockchain/blob/master/img3.PNG)
![alt text](https://github.com/PetqDrekoj/blockchain/blob/master/img4.PNG)

# Conclusions
We can easily say that this experience came with great results. We were able to understand the smart contracts and the way blockchains work. We understood also how hard it is to implement something safe from your first trial, as in, if we didn't have the test networks we would have payed loads of money for our mistakes. These smart contracts must be implemented by an experienced programmer.
Maybe we didn't quite manage to do everything we wanted, but as our first smart contract I see it as a win and a nice experience.


