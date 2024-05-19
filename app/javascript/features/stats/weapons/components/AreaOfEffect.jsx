import React from 'react'
import { MinMaxElement } from "../elements/MinMaxElement";
import { DLMSElement } from "../elements/DLMSElement";
import { SingleElement } from "../elements/SingleElement";
import { EmptyElement } from "../elements/EmptyElement";
import _ from "lodash";
import { SinglePreciseElement } from "../elements/SinglePreciseElement";
import { TargetSuppressedMultipliers } from "./TargetSuppressedMultipliers";
import { TargetPinnedMultipliers } from "./TargetPinnedMultipliers";



const AREA_INFO = 'area_info'
const RADIUS = 'radius'
const RadiusElement = ({ data }) => {
  if (_.has(data, AREA_INFO) && _.has(data[AREA_INFO], RADIUS)) {
    return (
      <SinglePreciseElement data={data[AREA_INFO][RADIUS]} label="aoe radius"
                   tooltip="Max radius of the Area of Effect circle."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const DISTANCE = 'distance'
const DistanceElement = ({ data }) => {
  if (_.has(data, DISTANCE)) {
    return (
      <DLMSElement data={data[DISTANCE]} defaultValue={0} label="aoe distance"
                   tooltip="Range bands used for other AoE stats, indicating how large the AoE circles are."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const ACCURACY = 'accuracy'
const AccuracyElement = ({ data }) => {
  if (_.has(data, ACCURACY)) {
    return (
      <DLMSElement data={data[ACCURACY]} defaultValue={1} label="aoe accuracy"
                   tooltip="Multiplier on AOE accuracy at different ranges. Units in an AOE are not guaranteed to be hit."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const DAMAGE = 'damage'
const DamageElement = ({ data }) => {
  if (_.has(data, DAMAGE)) {
    return (
      <DLMSElement data={data[DAMAGE]} defaultValue={1} label="aoe damage"
                   tooltip="Multiplier on weapon damage at different ranges."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const PENETRATION = 'penetration'
const PenetrationElement = ({ data }) => {
  if (_.has(data, PENETRATION)) {
    return (
      <DLMSElement data={data[PENETRATION]} defaultValue={1} label="aoe penetration"
                   tooltip="Multiplier on weapon penetration at different ranges."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const SUPPRESSION = 'suppression'
const SuppressionElement = ({ data }) => {
  if (_.has(data, SUPPRESSION)) {
    return (
      <DLMSElement data={data[SUPPRESSION]} defaultValue={1} label="aoe suppression"
                   tooltip="Multiplier on weapon suppression at different ranges."/>
    )
  } else {
    return <EmptyElement/>
  }
}

export const AreaOfEffect = ({ data }) => {
  const areaOfEffect = data?.area_effect

  if (_.isNil(areaOfEffect)) {
    return null
  } else {
    return (
      <>
        <RadiusElement data={areaOfEffect}/>
        <DistanceElement data={areaOfEffect}/>
        <AccuracyElement data={areaOfEffect}/>
        <DamageElement data={areaOfEffect}/>
        <PenetrationElement data={areaOfEffect}/>
        <SuppressionElement data={areaOfEffect}/>
      </>
    )
  }
}
