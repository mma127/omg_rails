import React, { useState } from 'react'
import { UnitCard } from "./UnitCard";
import { Box, Card } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { nanoid } from "@reduxjs/toolkit";
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { DragDropContainer } from "react-drag-drop-container";

const useStyles = makeStyles(() => ({
  squadCard: {
    display: 'inline-flex',
    backgroundColor: "#303030",
    margin: '0.25rem'
  },
  squadCardItems: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center'
  },
  deleteIcon: {
    cursor: 'pointer'
  }
}))

/**
 *
 * @param id
 * @param squadId: non null if this represents an existing squad
 * @param unitId: unit id
 * @param unitName: unit name
 * @param unitPop
 * @param man
 * @param mun
 * @param fuel
 * @param image: unit image
 * @param onUnitClick: callback fired when the squad card is clicked anywhere except the destroy icon
 * @param onDrop
 * @param onDestroyClick: callback fired when the destroy icon is clicked
 * @constructor
 */
export const SquadCard = ({
                            id,
                            squadId,
                            unitId,
                            unitName,
                            unitPop,
                            man,
                            mun,
                            fuel,
                            image,
                            onUnitClick,
                            onDrop,
                            onDestroyClick
                          }) => {
  const classes = useStyles()

  // Total costs for this squad including upgrades
  const [manCost, setManCost] = useState(man)
  const [munCost, setMunCost] = useState(mun)
  const [fuelCost, setFuelCost] = useState(fuel)

  return (
    <Card className={classes.squadCard}>
      <DragDropContainer targetKey="unit" onDragStart={() => onUnitClick(unitId, unitName)} onDrop={onDrop}
                         dragData={{
                           id: id, unitId: unitId, squadId: squadId, unitName: unitName, image: image,
                           unitPop: unitPop, man: man, mun: mun, fuel: fuel
                         }}>
        <Box sx={{ p: 1 }} className={classes.squadCardItems}>
          <UnitCard unitId={unitId} label={unitName} image={image} onUnitClick={onUnitClick} />
          <DeleteOutlineIcon onClick={() => onDestroyClick(id, squadId, unitPop, manCost, munCost, fuelCost)}
                             className={classes.deleteIcon}
                             color="error" />
        </Box>
      </DragDropContainer>
    </Card>
  )
}