import React from 'react'
import _ from "lodash";
import { DLMSElement } from "../elements/DLMSElement";
import { EmptyElement } from "../elements/EmptyElement";
import { SinglePreciseElement } from "../elements/SinglePreciseElement";
import { TargetSuppressedMultipliers } from "./TargetSuppressedMultipliers";
import { TargetPinnedMultipliers } from "./TargetPinnedMultipliers";


const SUPPRESSION = 'suppression'
const SuppressionElement = ({ data }) => {
  if (_.has(data, SUPPRESSION)) {
    return (
      <DLMSElement data={data[SUPPRESSION]} defaultValue={0} label="suppression"
                   tooltip="Range-based raw suppression values the weapon inflicts. This is always applied to the target squad per bullet. Can be reduced by cover, veterancy, or abilities."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const NEARBY_SUPPRESSION_MULTIPLIER = 'nearby_suppression_multiplier'
const NearbySuppressionMultiplierElement = ({ data }) => {
  if (_.has(data, NEARBY_SUPPRESSION_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[NEARBY_SUPPRESSION_MULTIPLIER]} label="nearby suppression multiplier"
                            tooltip="Multiplier on Suppression dealt to units around the targeted unit. Surrounding units typically receive a lesser amount of suppression."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const NEARBY_SUPPRESSION_RADIUS = 'nearby_suppression_radius'
const NearbySuppressionRadiusElement = ({ data }) => {
  if (_.has(data, NEARBY_SUPPRESSION_RADIUS)) {
    return (
      <SinglePreciseElement data={data[NEARBY_SUPPRESSION_RADIUS]} defaultValue={1} label="nearby suppression radius"
                   tooltip="Radius around the targeted unit in which non-targeted units are affected by Nearby Suppression."/>
    )
  } else {
    return <EmptyElement/>
  }
}

export const Suppression = ({ data }) => {
  const suppression = data?.suppression

  if (_.isNil(suppression)) {
    return null
  } else {
    return (
      <>
        <SuppressionElement data={suppression}/>
        <NearbySuppressionMultiplierElement data={suppression}/>
        <NearbySuppressionRadiusElement data={suppression}/>
        <TargetSuppressedMultipliers data={suppression} />
        <TargetPinnedMultipliers data={suppression} />
      </>
    )
  }
}
