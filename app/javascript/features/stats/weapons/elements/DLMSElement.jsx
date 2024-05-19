import React from 'react'
import { Tooltip } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { DLMSValue } from "./DLMSValue";
import { StatsLabelTypography } from "./StatsLabelTypography";

const useStyles = makeStyles(theme => ({
  values: {
    display: "flex",
    flexDirection: "column"
  }
}))

export const DLMSElement = ({ data, defaultValue, label, tooltip }) => {
  const classes = useStyles()

  return (
    <tr>
      <td>
        <Tooltip title={tooltip} placement="bottom-start" followCursor={true} arrow>
          <StatsLabelTypography>{label}</StatsLabelTypography>
        </Tooltip>
      </td>
      <td>
        <DLMSValue data={data} defaultValue={defaultValue} />
      </td>
    </tr>
  )
}
