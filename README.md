[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



# Mintable ERC20 token with proportional dividends


Smart contract solutions for [Nayms Smart Contract Tech Interview Coding Problem](https://github.com/nayms/smart-contracts-tech-interview)

'Token.sol' contains a rudimentary solution for paying token dividends to token holders and passes all unit tests laid out in 'test/token.test.js'.

A more robust solution can be found in 'Token2.sol', where dividend balances are updated whenever a transaction event (transfer, transferFrom, mint, burn) takes place. This avoids the potential complications and high gas fees that may be incurred by looping through a large number of token holder address' to pay dividends in 'token.sol'.

(SafeMath is yet to be implimented on contract operations)
  

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

LinkedIn - [https://www.linkedin.com/in/RAMWatson/](https://www.linkedin.com/in/RAMWatson/)


## Built With

* [Solidity](https://docs.soliditylang.org/en/v0.8.6/)
* [Truffle](https://www.trufflesuite.com/)
* [Open Zeppelin](https://openzeppelin.com/)
* [Chai](https://www.chaijs.com/)
* [Web3js](https://web3js.readthedocs.io/en/v1.3.4/)
* [Node.js](https://nodejs.org/en/)


<!-- CONTACT -->
## Contact

Twitter - [@0xTDF](https://twitter.com/0xTDF)

LinkedIn - [https://www.linkedin.com/in/RAMWatson/](https://www.linkedin.com/in/RAMWatson/)






<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/RAMWatson/
[product-screenshot]: screenshot.jpg
