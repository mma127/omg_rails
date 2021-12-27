import React, { useState } from 'react'
import { DropTarget } from 'react-drag-drop-container';
import { nanoid } from "@reduxjs/toolkit";
import { Box, Paper } from "@mui/material";
import { makeStyles } from "@mui/styles";

import { UnitCard } from "./UnitCard";
import './CompanyGridDropTarget.css'
import { SquadCard } from "./SquadCard";

const useStyles = makeStyles(() => ({
  placementBox: {
    minHeight: '20rem',
    minWidth: '4rem'
  }
}))

/**
 * Represents a single drop target grid box in the Company builder.
 * Must know its position index and the current selected category of the company
 * builder. With this, is able to get the corresponding squads for the company for
 * this category and index, if any exist.
 *
 * When a change involving this grid box is saved, the squads of this grid box are
 * assigned the category tab and tab position index so they appear correctly in the
 * future and ingame.
 *
 * @param index: position of the box within the Company builder grid of drop targets
 * @param onHitCallback: Callback fired when this company grid drop target receives a hit and has an unit dropped in
 * @param onUnitClick: Callback fired when the unit icon is clicked. Expect to pass squad identifier
 * @param onSquadDestroy
 */
export const CompanyGridDropTarget = ({ index, onHitCallback, onUnitClick, onSquadDestroy }) => {
  const classes = useStyles()

  const [squads, setSquads] = useState([])
  const [pop, setPop] = useState(0.0)

  // Is it necessary to maintain total cost of the drop target/platoon?
  // const [man, setMan] = useState(0)
  // const [mun, setMun] = useState(0)
  // const [fuel, setFuel] = useState(0)

  const addSquad = (key, dragData) => {
    const newSquad = {
      id: key,
      unitId: dragData.unitId,
      unitName: dragData.unitName,
      unitPop: dragData.unitPop,
      man: dragData.man,
      mun: dragData.mun,
      fuel: dragData.fuel,
      image: dragData.image
    }
    const existingSquads = squads.slice()
    existingSquads.push(newSquad)
    setSquads(existingSquads)
  }

  const onHit = (e) => {
    const dragData = e.dragData
    console.log(`${dragData.unitName} dropped into target ${index}`)
    const key = nanoid()
    addSquad(key, dragData)

    setPop(pop + parseFloat(dragData.unitPop))
    // setMan(dragData.man)
    // setMun(dragData.mun)
    // setFuel(dragData.fuel)

    onHitCallback(dragData.unitName, dragData.unitPop, dragData.man, dragData.mun, dragData.fuel, index)
  }

  const onDestroyClick = (uuid, squadId, unitPop, manCost, munCost, fuelCost) => {
    console.log(`Destroy squad: ${uuid}, ${squadId}, ${unitPop} with costs ${manCost}, ${munCost}, ${fuelCost}`)
    setPop(pop - parseFloat(unitPop))
    const filteredSquads = squads.filter(item => item.id !== uuid)
    setSquads(filteredSquads)
    onSquadDestroy(squadId, unitPop, manCost, munCost, fuelCost)
  }

  return (
    <DropTarget targetKey="unit" onHit={onHit}>
      <Paper key={index} className={classes.placementBox}>
        <Box sx={{ position: 'relative', p: 1 }}>
          {squads.map(({ id, unitId, unitName, unitPop, man, mun, fuel, image }) => (
            <SquadCard key={id} id={id} unitId={unitId} unitName={unitName}
                       unitPop={unitPop} man={man} mun={mun} fuel={fuel} image={image}
                       onUnitClick={onUnitClick} onDestroyClick={onDestroyClick} />))}
          <Box component="span" sx={{ position: 'absolute', right: '2px', top: '-1px' }}>{pop}</Box>
        </Box>
      </Paper>
    </DropTarget>
  )
}