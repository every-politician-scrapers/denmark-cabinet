// wd create-entity create-office.js "Minister for X"
module.exports = (label) => {
  return {
    type: 'item',
    labels: {
      en: label,
    },
    descriptions: {
      en: 'Danish government position',
    },
    claims: {
      P31:   { value: 'Q294414' }, // instance of: public office
      P279:  { value: 'Q83307'  }, // subclas of: minister
      P17:   { value: 'Q35'     }, // country: Denmark
      P1001: { value: 'Q35'     }, // jurisdiction: Denmark
      P361: {
        value: 'Q1503072',         // part of: Cabinet of Denmark
        references: {
          P854: 'https://www.thedanishparliament.dk/en/members/the-government',
        },
      }
    }
  }
}
