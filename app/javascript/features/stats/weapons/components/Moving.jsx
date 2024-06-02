import React from 'react'
import { SingleElement } from "../elements/SingleElement";
import { EmptyElement } from "../elements/EmptyElement";
import { SinglePreciseElement } from "../elements/SinglePreciseElement";
import _ from "lodash";

const DisabledFiringWhileMoving = () => {
  return (
    <SingleElement data="disabled" label="firing while moving"
                          tooltip="Can the weapon fire while moving?"/>
  )
}

const ACCURACY_MULTIPLIER = 'accuracy_multiplier'
const MovingAccuracyMultiplierElement = ({ data }) => {
  if (_.has(data, ACCURACY_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[ACCURACY_MULTIPLIER]} label="moving accuracy multiplier"
                     tooltip="Multiplier on Accuracy while moving. A value < 1 reduces accuracy while firing on the move."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const BURST_MULTIPLIER = 'burst_multiplier'
const MovingBurstMultiplierElement = ({ data }) => {
  if (_.has(data, BURST_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[BURST_MULTIPLIER]} label="moving burst multiplier"
                     tooltip="Multiplier on Burst Duration while moving. A value > 1 increases burst duration while firing on the move."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const COOLDOWN_MULTIPLIER = 'cooldown_multiplier'
const MovingCooldownMultiplierElement = ({ data }) => {
  if (_.has(data, COOLDOWN_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[COOLDOWN_MULTIPLIER]} label="moving cooldown multiplier"
                   tooltip="Multiplier on Cooldown Duration while moving. A value > 1 increases cooldown duration while firing on the move."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const MOVING_START_TIME = 'moving_start_time'
const MovingStartTimeDelayElement = ({ data }) => {
  if (_.has(data, MOVING_START_TIME)) {
    return (
      <SinglePreciseElement data={data[MOVING_START_TIME]} label="moving start time delay"
                     tooltip="How long the unit has to be moving before moving multipliers take effect."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const MOVING_END_TIME = 'moving_end_time'
const MovingEndTimeDelayElement = ({ data }) => {
  if (_.has(data, MOVING_END_TIME)) {
    return (
      <SinglePreciseElement data={data[MOVING_END_TIME]} label="moving end time delay"
                     tooltip="How long the unit has to be stationary before moving multipliers stop applying."/>
    )
  } else {
    return <EmptyElement/>
  }
}

export const Moving = ({ data }) => {
  const moving = data?.moving
  if (_.has(moving, "disable_moving_firing") && moving["disable_moving_firing"] === true) {
    return (
      <DisabledFiringWhileMoving />
    )
  } else {
    return (
      <>
        <MovingAccuracyMultiplierElement data={moving}/>
        <MovingBurstMultiplierElement data={moving}/>
        <MovingCooldownMultiplierElement data={moving}/>
        <MovingStartTimeDelayElement data={moving}/>
        <MovingEndTimeDelayElement data={moving}/>
      </>
    )
  }
}
