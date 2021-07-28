module.exports = (id, position, personname, positionname, startdate) => {
  reference = {
    P854: 'https://www.thedanishparliament.dk/en/members/the-government',
    P1476: {
      text: 'The Government',
      language: 'en',
    },
    P813: new Date().toISOString().split('T')[0],
    P407: 'Q1860', // language: English
  }

  qualifier = {
    P580: '2019-06-27',
    P5054: 'Q64831553', // Frederiksen Cabinet
  }


  if(startdate)      qualifier['P580']  = startdate
  if(personname)     reference['P1810'] = personname
  if(positionname)   reference['P1932'] = positionname

  return {
    id,
    claims: {
      P39: {
        value: position,
        qualifiers: qualifier,
        references: reference,
      }
    }
  }
}
