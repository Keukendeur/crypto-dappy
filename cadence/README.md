## In order for our application to display the available Dappies and enable the purchase of Dappies and packs, it is necessary:

- You must have Flow CLI installed on your computer

Open a terminal in the cadence folder where the flow.json file is located

You must create an account/address in the Flow Testnet and deploy the DappyContract contract to this account!

To do this, you can execute the command in your terminal:

`flow keys generate`

### This command generates two keys:

- publicKey 
- privateKey

Open the following link in your browser:
https://testnet-faucet.onflow.org/

- Add your public key, you can leave the fields Signature & Hash Algorithms as default.
Then click on Create account.

The result is the address of your Testnet account.

#### Open the file flow.json and replace the following values with your address generated in the Faucet and your private key in your terminal:

"testnet-account": {
"Address": "YOUR-ADDRESS",
"key": "YOUR-PRIVATE-KEY"
}

##### Done Your account is set up and you can execute the following command to transfer the DappyContract to your new testnet account:

`flow project deploy -n=testnet`

With the contract in your testnet account, you can now perform the necessary transactions to create templates and families

The steps will be:

# Create family

There are 3 different families
Family 1:
-- Name: Pride Dappies
-- Price: 50.00

Family 2:
-- Name: Green Dappies
-- Price: 30.00

Family 3:
-- Name: Yellow Dappies
-- Price: 140.00

We will create these three in the order listed below. This way we can guarantee that each family has the correct ID:

`flow transactions send --signer=testnet-account Dappy/transactions/CreateFamily.cdc 'Pride Dappies' '50.000000' -n=testnet`

`flow transactions send --signer=testnet-account Dappy/transactions/CreateFamily.cdc 'Green Dappies' '30.00000000' -n=testnet`

`flow transactions send --signer=testnet-account Dappy/transactions/CreateFamily.cdc 'Yellow Dappies' '140.00000000' -n=testnet`

#### Done! The 3 families are created!

# Create template
Now we will create the templates!
There will be 15 different templates available!

Perform the following transactions in the following order:

`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet 'FF5A9D.FFE922.60C5E5.0' 'Panda Dappy'`
`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet '94DFF6.F6ABBA.94DFF6.1' 'Tranzi Dappy'`
`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet '74ee15.cae36f.6b6b49.7fc48f.0' 'Queen Dappy'`
`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet 'D61774.9D5098.1F429C.1' 'Bibi Dappy'`
`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet 'FF5A9D.FFAA47.FFE922.B6E927.60C5E5.7320D3' 'Queery Dappy'`
`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet 'F8EF38.8D5FA8.211F20.2' 'Nobi Dappy'`
`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet '55fb59.b931ed.be7e39.519494.3' 'Adonis Dappy'`
`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet 'F571A4.972E90.18469E.211F20' 'Fludi Dappy'`
`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet 'BF1E6C.DA4A97.EA5CA3.FBE1E4.E84B56.4' 'Lesli Dappy'`
`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet 'A3A5A4.8D5FA8.211F20.2' 'Asel Dappy'`
`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet 'A3A5A4.BCDA84.211F20.2' 'Agent Dappy'`
`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet '001DED.E84B56.211F20.2' 'Polly Dappy'`
`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet 'D50E8D.5BBD70.068DCF.0' 'Poldi Dappy'`
`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet 'df1f4f.ac069b.25443c.1922ff.1' 'Lucienne Dappy'`
`flow transactions send --signer=testnet-account Dappy/transactions/CreateTemplate.cdc -n=testnet 'ad634b.798f9d.6c2af1.19a9f7.3' 'Mohammad Dappy'`

# Adding templates to a family
After you have created the families and the templates, the last step has come: adding templates to a family

Perform the following transactions in your terminal:

`flow transactions send --signer=testnet-account Dappy/transactions/AddTemplateToFamily.cdc -n=testnet '1' '[1, 2, 3, 4]'`

`flow transactions send --signer=testnet-account Dappy/transactions/AddTemplateToFamily.cdc -n=testnet '2' '[5, 6, 7, 8]'`

`flow transactions send --signer=testnet-account Dappy/transactions/AddTemplateToFamily.cdc -n=testnet '3' '[9, 10, 11, 12]'`

Done!