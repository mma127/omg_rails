export const getVetLevel = (exp, unitVet) => {
  if (exp < unitVet.vet1Exp) {
    return [0, unitVet.vet1Exp]
  } else if (exp < unitVet.vet2Exp) {
    return [1, unitVet.vet2Exp]
  } else if (exp < unitVet.vet3Exp) {
    return [2, unitVet.vet3Exp]
  } else if (exp < unitVet.vet4Exp) {
    return [3, unitVet.vet4Exp]
  } else if (exp < unitVet.vet5Exp) {
    return [4, unitVet.vet5Exp]
  } else {
    return [5, null]
  }
}

export const buildVetBonuses = (level, unitVet) => {
  let bonuses = []
  if (level === 0) {
    return bonuses
  }
  if (level >= 1) {
    bonuses.push({ level: 1, desc: unitVet.vet1Desc })
  }
  if (level >= 2) {
    bonuses.push({ level: 2, desc: unitVet.vet2Desc })
  }
  if (level >= 3) {
    bonuses.push({ level: 3, desc: unitVet.vet3Desc })
  }
  if (level >= 4) {
    bonuses.push({ level: 4, desc: unitVet.vet4Desc })
  }
  if (level === 5) {
    bonuses.push({ level: 5, desc: unitVet.vet5Desc })
  }
  return bonuses
}
