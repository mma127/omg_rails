import React from 'react'
import { Tooltip, Typography } from "@mui/material";
import { precise } from "../../../../utils/numbers";
import { StatsLabelTypography } from "./StatsLabelTypography";
import { EmptyElement } from "./EmptyElement";
import _ from "lodash";

export const SinglePreciseElement = ({ data, label, tooltip }) => {
  if (!_.isNil(data)) {
    return (
      <tr>
        <td>
          <Tooltip title={tooltip} placement="bottom-start" followCursor={true} arrow>
            <StatsLabelTypography>{label}</StatsLabelTypography>
          </Tooltip>
        </td>
        <td>
          <Typography>{precise(data)}</Typography>
        </td>
      </tr>
    )
  } else {
    return <EmptyElement />
  }
}
