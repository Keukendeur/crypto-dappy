import "DappyContract"

pub fun main (familyID: UInt32, templateID: UInt32): Bool {
  return DappyContract.familyContainsTemplate(familyID: familyID, templateID: templateID)
}

// flow scripts execute -n=testnet Dappy/scripts/FamilyContainsTemplate.cdc '1' '1'