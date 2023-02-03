import "DappyContract"

transaction(familyID: UInt32, templateIDs: [UInt32]) {

  var adminRef: &DappyContract.Admin

  prepare(acct: AuthAccount) {
    self.adminRef = acct.borrow<&DappyContract.Admin>(from: /storage/DappyAdmin) ?? panic("Cannot borrow admin ref")
  }

  execute {
    let familyRef = self.adminRef.borrowFamily(familyID: familyID)
    let templateIdsLength = templateID.length
    for id in templateIdsLength {
      familyRef.addTemplate(templateID: id)
    }
  }
  
}