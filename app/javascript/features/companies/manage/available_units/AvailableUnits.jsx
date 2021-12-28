import React from 'react'
import { useSelector } from "react-redux";

import { selectCompanyById } from "../../companiesSlice";
import { selectAllAvailableUnits } from "../../../units/availableUnitsSlice";
import { AvailableUnitDroppable } from "../AvailableUnitDroppable";
import { unitImageMapping } from "../../../../constants/units/all_factions";

/**
 * Show all available units for the given company. Take into account availability
 * @param companyId: company id for which we should display available units
 * @param onUnitSelect
 */
export const AvailableUnits = ({ companyId, onUnitSelect }) => {
  const company = useSelector(state => selectCompanyById(state, companyId))
  const availableUnits = useSelector(selectAllAvailableUnits)

  return (
    <>
      {
        availableUnits.map(au => (
          <AvailableUnitDroppable
            key={au.unitId}
            unitId={au.unitId}
            unitName={au.unitName}
            availableUnit={au}
            label={au.unitDisplayName}
            image={unitImageMapping[au.unitName]}
            available={au.available}
            resupply={au.resupply}
            companyMax={au.companyMax}
            onUnitClick={onUnitSelect}
          />
        ))
      }
    </>
  )
}
