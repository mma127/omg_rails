import React from 'react'
import { LabelTypography } from "../../../../components/LabelTypography";
import { Box, Grid, Tooltip, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { precise } from "../../../../utils/numbers";
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
