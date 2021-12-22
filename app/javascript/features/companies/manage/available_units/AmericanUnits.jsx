import React from 'react'
import { useSelector } from "react-redux";

import { selectAvailableUnits, selectCompanyById } from "../../companiesSlice";
import { UnitCardDroppable } from "../UnitCardDroppable";
import * as americanUnits from "../../../../constants/units/americans";

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
          <UnitCardDroppable key={au.unitName}
                             label={au.unitName}
                             image={americanUnits.unitImageMapping[au.unitName]}
                             onDrop={onDrop}
                             onUnitClick={onUnitSelect}
          />
        ))
      }
    </>
  )
}
