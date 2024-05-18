import React from 'react'
import { Tooltip, Typography } from "@mui/material";
import { precise } from "../../../../utils/numbers";
import { StatsLabelTypography } from "./StatsLabelTypography";

export const SingleElement = ({ data, key, label, tooltip }) => {

  if (_.has(data, key)) {
    return (
      <tr>
        <td>
          <Tooltip title={tooltip} placement="bottom-start" followCursor={true} arrow>
            <StatsLabelTypography>{label}</StatsLabelTypography>
          </Tooltip>
        </td>
        <td>
          <Typography>{precise(data[key])}</Typography>
        </td>
      </tr>
    )
  } else {
    return null
  }
}
