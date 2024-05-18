import React from 'react'
import { LabelTypography } from "../../../../components/LabelTypography";
import { Box, Grid, Tooltip, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { precise } from "../../../../utils/numbers";
import { DLMSElement } from "../elements/DLMSElement";
import { MinMaxElement } from "../elements/MinMaxElement";

export const Damage = ({ data }) => {
  const damage = data.damage

  return (
    <MinMaxElement data={damage} label="damage" tooltip="Damage per round or discrete tick"/>
  )
}
