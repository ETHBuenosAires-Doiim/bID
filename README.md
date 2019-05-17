# bID - Legally Binding Blockchain Identity

![UI](https://raw.githubusercontent.com/ETHBuenosAires-Doiim/bID/master/docs/block-id-git.png) 

### Link a blockchain private key to a CA key issued by the root key of the Brasil government’s PKI tree and to any institution authorised to make claims on behalf of individuals such as issuers of driver’s licences, voter’s tittle, passport, social security, health insurance and so on. Using ENS and [EIP 1078](https://eips.ethereum.org/EIPS/eip-1078) for universal login with, [EIP 1077](https://eips.ethereum.org/EIPS/eip-1077) gas relayer, [ERC 725](https://eips.ethereum.org/EIPS/eip-725) proxy identity, and [ERC 735](https://github.com/ethereum/EIPs/issues/735) claim holder to create a fail-safe key management solution and empower noobs with a terrific user experience.

* Create a dynamic digital identity that’s issued by a certificate authority or an instituion and link it to an Ethereum/RSK private key so it can be used to provide a simple and secure way to login and interact with the financial system, judicial system, unions, issue invoices, access public services, interact with the government service’s online systems, pay taxes, claim rights and sign contracts that are legally binding and equivalent to handwritten signatures. All in a much simpler manner and closely resembling some current two factor login implementations. The user just need to provide it’s ENS username and authorise it through an app in any device.

![Diagram Block ID Structure](https://raw.githubusercontent.com/ETHBuenosAires-Doiim/bID/master/docs/Structure.png) 

* With this implementation the user doesn’t even have to know what blockchain, Ethereum, or gas means. They will simply purchase an electronic identity from a certificate authority, do the standard process of document validation and KYC procedures along with biometric  verification. After that they will download an app, where they can do the traditional signing method recognised  and standardised by ICANN and also sign transactions, messages and contracts with their own disposable Ethereum/RSK private key, all within the same app. All without any cryptocurrencies because the CA in charge of issuing the identities will act as gas relayer and pay for all the transactions cost which were already charged during the creation of the key. And they will also be able to issue as many identities as are necessary and revoke them as needed because they will be in charge of the key management and authorisation procedures.

* Using claims the environment dosen't need a central registry of them, all claims that a individual has is stored on his own identity. Also it is possible that a user requests Certifier Validator's signed claims off-chain and add the certifier claim to his identity by himself.

![Diagram Certifier Validator](https://raw.githubusercontent.com/ETHBuenosAires-Doiim/bID/master/docs/CertificateValidator.png) 

### Claim verification

* Claims could be verified using both on-chain or off-chain solutions. Basically our idea is to have some fields on "data" contained on claims to store a hash of personal informations. This personal information isn't stored on contract or claims, it should be send to some "Inspector" (in the case below, the lender), so he could verify the autenticity of the claim made by the issuer checking its signature and checking the personal identity data with hash contained on claim.

* In case of governamental institutions that hold a lot of users informations, they could store all users hashes on a IPFS uri. In this case, when someone request a loan, the user could send to the lender contract his personal data encrypted with the lender public key. So it's possible to access different institutions contracts to get their IPFS data and check if user hash match with some entry.

![Claims Verification](https://raw.githubusercontent.com/ETHBuenosAires-Doiim/bID/master/docs/ClaimsVerification.png) 

* As this signatures are legally binding, people can get into loan agreements with another party such as on the Ripio Credit Network where the lender, the borrower, the cosigner, the credit scoring agent and the ID verifier are all attesting their real world identity through blockchain signatures using claims. They can also attests that they are entitled to participate in an ICO and are accredited to trade restricted tokens through the TPL protocol

* With a dynamic identity documents can be revoked and replaced, reducing troubles for the user. They are quiet common in Brasil. Digital certificates are issued representing a digital identity to verify a citizen, company or institution. The governments holds the root key  through [ICP (PKI) - Brasil](http://www.iti.gov.br/icp-brasil), does the issuance of the certificates and partners with the private sector to enable the access to the system.

* ICP (PKI) - Brasil was appointed several times as a reference model on 8/11/17 in a public hearing in the US senate. Paulino de Rego Barros, and Richard smith, respectively previous and current interim CEO of Equifax were present along with Marisa Mayer. Where they discussed consumer protection in the information age in the face of several hacks and data breaches, such as Equifax’s which affected 145 million people and Yahoo’s 3 billion users.
