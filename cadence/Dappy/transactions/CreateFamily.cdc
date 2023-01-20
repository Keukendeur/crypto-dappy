import DappyContract from "../contracts/DappyContract.cdc"

transaction(name: String, price: UFix64) {

  var adminRef: &DappyContract.Admin

  prepare(acct: AuthAccount) {
    self.adminRef = acct.borrow<&DappyContract.Admin>(from: DappyContract.AdminStoragePath) ?? panic("Cannot borrow admin ref")
  }

  execute {
    self.adminRef.createFamily(name: name, price: price)
  }
}
 

//flow transactions send --signer=testnet-account cadence/Dappy/transactions/CreateFamily.cdc 'Yellow Dappies' '140.00000000' -n=testnet