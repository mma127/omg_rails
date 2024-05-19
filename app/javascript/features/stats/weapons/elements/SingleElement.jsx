import React from 'react'
import { Tooltip, Typography } from "@mui/material";
import { StatsLabelTypography } from "./StatsLabelTypography";
import { EmptyElement } from "./EmptyElement";
import _ from "lodash";

export const SingleElement = ({ data, label, tooltip }) => {

  if (!_.isNil(data)) {
    return (
      <tr>
        <td>
          <Tooltip title={tooltip} placement="bottom-start" followCursor={true} arrow>
            <StatsLabelTypography>{label}</StatsLabelTypography>
          </Tooltip>
        </td>
        <td>
          <Typography>{data}</Typography>
        </td>
      </tr>
    )
  } else {
    return <EmptyElement />
  }
}
