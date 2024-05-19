import React from 'react'
import { MinMaxElement } from "../elements/MinMaxElement";
import { DLMSElement } from "../elements/DLMSElement";
import { SingleElement } from "../elements/SingleElement";
import { EmptyElement } from "../elements/EmptyElement";
import { SinglePreciseElement } from "../elements/SinglePreciseElement";
import _ from "lodash";


const DisabledBurst = () => {
  return (
    <SingleElement data="disabled" label="burst firing"
                          tooltip="If burst firing is disabled, the weapon only fires single shots."/>
  )
}

const DURATION = 'duration'
const DurationElement = ({ data }) => {
  if (_.has(data, DURATION)) {
    return (
      <MinMaxElement data={data[DURATION]} label="burst duration"
                     tooltip="How long a weapon can shoot during a burst. Can be a range of values."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const RATE_OF_FIRE = 'rate_of_fire'
const RateOfFireElement = ({ data }) => {
  if (_.has(data, RATE_OF_FIRE)) {
    return (
      <MinMaxElement data={data[RATE_OF_FIRE]} label="rate of fire"
                     tooltip="Bullets fired per second in a burst. Multiply by Burst Duration for the number of bullets fired per burst."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const INCREMENTAL_ACCURACY_MULTIPLIER = 'incremental_accuracy_multiplier'
const IncrementalAccuracyMultiplierElement = ({ data }) => {
  if (_.has(data, INCREMENTAL_ACCURACY_MULTIPLIER)) {
    return (
      <DLMSElement data={data[INCREMENTAL_ACCURACY_MULTIPLIER]} defaultValue={1} label="incremental accuracy multiplier"
                   tooltip="Multiplier on weapon accuracy for every model (not squad) the weapon is shooting at. A value > 1 means the weapon is more accurate the more models it shoots at in its burst."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const INCREMENTAL_SEARCH_RADIUS = 'incremental_search_radius'
const IncrementalSearchRadiusElement = ({ data }) => {
  if (_.has(data, INCREMENTAL_SEARCH_RADIUS)) {
    return (
      <SinglePreciseElement data={data[INCREMENTAL_SEARCH_RADIUS]} label="incremental search radius"
                     tooltip="The radius around the target of the weapon where other models will apply the Incremental Accuracy Multiplier. A larger radius is better."/>
    )
  } else {
    return <EmptyElement/>
  }
}

export const Burst = ({ data }) => {
  const burst = data?.burst
  if (_.has(burst, "can_burst") && burst["can_burst"] === false) {
    return (
      <DisabledBurst />
    )
  } else {
    return (
      <>
        <DurationElement data={burst}/>
        <RateOfFireElement data={burst}/>
        <IncrementalAccuracyMultiplierElement data={burst}/>
        <IncrementalSearchRadiusElement data={burst}/>
      </>
    )
  }
}
