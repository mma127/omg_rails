import React from "react";
import { DLMSElement } from "../elements/DLMSElement";
import { EmptyElement } from "../elements/EmptyElement";
import { SinglePreciseElement } from "../elements/SinglePreciseElement";
import _ from "lodash";

const DEFLECTION_DAMAGE_MULTIPLIER = 'deflection_damage_multiplier'
const DeflectionDamageMultiplier = ({ data }) => {
  if (_.has(data, DEFLECTION_DAMAGE_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[DEFLECTION_DAMAGE_MULTIPLIER]} label="deflection damage multiplier"
                     tooltip="Multiplier for how much of the weapon's damage is applied on non-penetrating hits."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const PenetrationElement = ({ data }) => {
  if (_.has(data, "penetration")) {
    const penetration = data.penetration

    return (
      <DLMSElement data={penetration} defaultValue={1} label="penetration" tooltip="The base chance to penetrate and do full damage, before modification by target type. A value of 1 means 100% chance of penetrating." />
    )
  } else {
    return <EmptyElement/>
  }
}

const DeflectionElement = ({ data }) => {
  if (_.has(data, "deflection")) {
    const deflection = data.deflection

    return (
      <>
        <DeflectionDamageMultiplier data={deflection}/>
      </>
    )
  } else {
    return <EmptyElement/>
  }
}

export const Penetration = ({ data }) => {
  return (
    <>
      <PenetrationElement data={data}/>
      <DeflectionElement data={data}/>
    </>
  )
}