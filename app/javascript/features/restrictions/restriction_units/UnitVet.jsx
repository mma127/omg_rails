import React from 'react'
import { Box, Tooltip } from "@mui/material";
import { SquadVetIcon } from "../../companies/manage/squads/SquadVetIcon";
import { UnitVetDescriptions } from "../../companies/manage/units/UnitVetDescriptions";

const MAX_LEVEL = 5

export const UnitVet = ({ vet, side }) => {
  return (
    <Tooltip
      title={<UnitVetDescriptions vet={vet} level={MAX_LEVEL} side={side} />}
      placement="top" followCursor={true} arrow>
      <Box>
        <SquadVetIcon side={side} level={MAX_LEVEL}/>
      </Box>
    </Tooltip>
  )
}
