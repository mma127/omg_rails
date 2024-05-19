import React from 'react'
import { useSelector } from "react-redux";
import { selectStatsUnitByConstName } from "../units/statsUnitsSlice";
import { selectStatsEntitiesByReference } from "./statsEntitiesSlice";
import { getLoadoutModelCounts, TOTAL_COUNT } from "../units/loadout_helper";
import { EntityStatsCard } from "./EntityStatsCard";

export const EntityStatsList = ({ constName }) => {
  const statsUnit = useSelector(state => selectStatsUnitByConstName(state, constName))
  const statsEntitiesByReference = useSelector((state) => selectStatsEntitiesByReference(state, statsUnit.data.entities))
  const loadoutModelCounts = getLoadoutModelCounts(statsUnit.data.loadout)

  const entityCards = []
  for (const [reference, count] of Object.entries(loadoutModelCounts)) {
    if (reference === TOTAL_COUNT) continue

    const statsEntity = statsEntitiesByReference[reference]
    entityCards.push(<EntityStatsCard statsEntity={statsEntity} count={count} key={`entity-card-${reference}`}/>)
  }

  return (
    <>
      {entityCards}
    </>
  )
}
