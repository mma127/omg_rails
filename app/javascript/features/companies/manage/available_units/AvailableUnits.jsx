import React from 'react'
import { useSelector } from "react-redux";

import { selectCompanyById } from "../../companiesSlice";
import { selectAllAvailableUnits } from "../../../units/availableUnitsSlice";
import { UnitCardDroppable } from "../UnitCardDroppable";
import { unitImageMapping } from "../../../../constants/units/all_factions";


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
 * Show all available units for the given company. Take into account availability
 * @param companyId: company id for which we should display available units
 * @param onDrop
 * @param onUnitSelect
 */
export const AvailableUnits = ({ companyId, onDrop, onUnitSelect }) => {
  const company = useSelector(state => selectCompanyById(state, companyId))
  const availableUnits = useSelector(selectAllAvailableUnits)

  return (
    <>
      {
        availableUnits.map(au => (
          <UnitCardDroppable
            key={au.unitId}
            unitId={au.unitId}
            unitName={au.unitName}
            availableUnit={au}
            label={au.unitDisplayName}
            image={unitImageMapping[au.unitName]}
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
