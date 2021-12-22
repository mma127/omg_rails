import React from 'react'
import { useSelector } from "react-redux";

import { selectAvailableUnits, selectCompanyById } from "../../companiesSlice";
import { UnitCardDroppable } from "../UnitCardDroppable";
import * as americanUnits from "../../../../constants/units/americans";
import { Tooltip, tooltipClasses, Typography } from "@mui/material";
import { styled } from "@mui/styles";


// const HtmlTooltip = styled(({ className, ...props }) => (
//   <Tooltip {...props} classes={{ popper: className }} />
// ))(({ theme }) => ({
//   [`& .${tooltipClasses.tooltip}`]: {
//     backgroundColor: '#f5f5f9',
//     color: 'rgba(0, 0, 0, 0.87)',
//     maxWidth: 220,
//     fontSize: theme.typography.pxToRem(12),
//     border: '1px solid #dadde9',
//   },
// }));


/**
 * Show all available American units for the given company. Take into account availability
 * @param companyId: company id for which we should display available units
 * @param onDrop
 * @param onUnitSelect
 */
export const AmericanUnits = ({ companyId, onDrop, onUnitSelect }) => {
  const company = useSelector(state => selectCompanyById(state, companyId))
  const availableUnits = useSelector(selectAvailableUnits)

  return (
    <>
      {
        availableUnits.map(au => (
          <UnitCardDroppable
            key={au.unitName}
            label={au.unitName}
            image={americanUnits.unitImageMapping[au.unitName]}
            available={au.available}
            resupply={au.resupply}
            companyMax={au.companyMax}
            onDrop={onDrop}
            onUnitClick={onUnitSelect}
          />
        ))
      }
    </>
  )
}