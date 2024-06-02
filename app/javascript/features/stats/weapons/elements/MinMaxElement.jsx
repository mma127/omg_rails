import React from 'react'
import { Tooltip, Typography } from "@mui/material";
import { precise } from "../../../../utils/numbers";
import { StatsLabelTypography } from "./StatsLabelTypography";

export const MinMaxElement = ({ data, label, tooltip }) => {
  const min = precise(data.min)
  const max = precise(data.max)

  let value
  if (min === max) {
    value = min
  } else {
    value = `${min} - ${max}`
  }

  return (
    <tr>
      <td>
        <Tooltip title={tooltip} placement="bottom-start" followCursor={true} arrow>
          <StatsLabelTypography>{label}</StatsLabelTypography>
        </Tooltip>
      </td>
      <td>
        <Typography>{value}</Typography>
      </td>
    </tr>
  )
}
