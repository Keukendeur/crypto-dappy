import Dappy from "../../contracts/Dappy.cdc"

pub fun main (familyID: UInt32, templateID: UInt32): Bool {
  return Dappy.familyContainsTemplate(familyID: familyID, templateID: templateID)
}