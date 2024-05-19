import React from 'react'
import { Box, Tooltip } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { StatsLabelTypography } from "../elements/StatsLabelTypography";
import { DLMSValue } from "../elements/DLMSValue";

const useStyles = makeStyles(theme => ({
  subtext: {
    fontSize: "80%"
  }
}))

export const Range = ({ data }) => {
  const classes = useStyles()

  const range = data.range
  const max = range.max
  const min = range?.min || 0
  const mid = range.mid

  return (
    <tr>
      <td>
        <Tooltip title="Range band maximums used by all stats that vary by range" placement="bottom-start" followCursor={true} arrow>
          <Box>
            <StatsLabelTypography>range</StatsLabelTypography>
            <StatsLabelTypography className={classes.subtext}>max: {max}</StatsLabelTypography>
            <StatsLabelTypography className={classes.subtext}>min: {min}</StatsLabelTypography>
          </Box>
        </Tooltip>
      </td>
      <td>
        <DLMSValue data={mid} defaultValue={1} />
      </td>
    </tr>
  )
}
