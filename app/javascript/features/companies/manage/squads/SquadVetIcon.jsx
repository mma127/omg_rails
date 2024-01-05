import React from "react";
import { makeStyles } from "@mui/styles";
import { useSelector } from "react-redux";
import { selectCurrentCompany } from "../../companiesSlice";

import allied_vet1 from '../../../../../assets/images/vet/allied/vet1.png'
import allied_vet2 from '../../../../../assets/images/vet/allied/vet2.png'
import allied_vet3 from '../../../../../assets/images/vet/allied/vet3.png'
import allied_vet4 from '../../../../../assets/images/vet/allied/vet4.png'
import allied_vet5 from '../../../../../assets/images/vet/allied/vet5.png'

import axis_vet1 from '../../../../../assets/images/vet/axis/vet1.png'
import axis_vet2 from '../../../../../assets/images/vet/axis/vet2.png'
import axis_vet3 from '../../../../../assets/images/vet/axis/vet3.png'
import axis_vet4 from '../../../../../assets/images/vet/axis/vet4.png'
import axis_vet5 from '../../../../../assets/images/vet/axis/vet5.png'
import { ALLIED_SIDE, AXIS_SIDE } from "../../../../constants/doctrines";

const ALLIED_VET = {
  1: allied_vet1,
  2: allied_vet2,
  3: allied_vet3,
  4: allied_vet4,
  5: allied_vet5
}
const AXIS_VET = {
  1: axis_vet1,
  2: axis_vet2,
  3: axis_vet3,
  4: axis_vet4,
  5: axis_vet5
}

const getImgForVet = (side, level) => {
  if (level === 0) {
    return null
  } else if(side === ALLIED_SIDE) {
    return ALLIED_VET[level]
  } else if (side === AXIS_SIDE) {
    return AXIS_VET[level]
  } else {
    console.log(`Unknown side for company ${side}`)
    return null
  }
}

const useStyles = makeStyles(() => ({
  icon: {
    marginLeft: "0.25rem",
    marginRight: "0.25rem"
  }
}))

export const SquadVetIcon = ({ level }) => {
  const classes = useStyles()
  const company = useSelector(selectCurrentCompany)
  const img = getImgForVet(company.side, level)

  let result = null
  if (img) {
    result = <img src={img} className={classes.icon} alt={`Vet ${level}`} />
  }

  return result
}
