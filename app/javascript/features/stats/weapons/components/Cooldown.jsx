import React from "react";
import { MinMaxElement } from "../elements/MinMaxElement";
import { DLMSElement } from "../elements/DLMSElement";
import { EmptyElement } from "../elements/EmptyElement";
import { SinglePreciseElement } from "../elements/SinglePreciseElement";
import _ from "lodash";

const DURATION = 'duration'
const DurationElement = ({ data }) => {
  if (_.has(data, DURATION)) {
    return (
      <MinMaxElement data={data[DURATION]} label="cooldown duration"
                     tooltip="Time between rounds or bursts."/>
    )
  } else {
    return null
  }
}

const DURATION_MULTIPLIER = 'duration_multiplier'
const DurationMultiplierElement = ({ data }) => {
  if (_.has(data, DURATION_MULTIPLIER)) {
    return (
      <DLMSElement data={data[DURATION_MULTIPLIER]} defaultValue={1} label="cooldown duration multiplier"
                   tooltip="Ranged-based multiplier on Cooldown Duration."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const WIND_UP = 'wind_up'
const WindUpElement = ({ data }) => {
  if (_.has(data, WIND_UP)) {
    return (
      <SinglePreciseElement data={data[WIND_UP]} label="wind up"
                     tooltip="Delay just before firing a shot or burst, usually associated with an animation. It is not affected by the Cooldown Duration Multiplier."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const WIND_DOWN = 'wind_down'
const WindDownElement = ({ data }) => {
  if (_.has(data, WIND_DOWN)) {
    return (
      <SinglePreciseElement data={data[WIND_DOWN]} label="wind down"
                     tooltip="Delay after firing a shot or burst, usually associated with an animation. It is not affected by the Cooldown Duration Multiplier."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const CooldownElement = ({ data }) => {
  if (_.has(data, "cooldown")) {
    const cooldown = data.cooldown

    return (
      <>
        <DurationElement data={cooldown}/>
        <DurationMultiplierElement data={cooldown}/>
      </>
    )
  } else {
    return <EmptyElement/>
  }
}

const FireElement = ({ data }) => {
  if (_.has(data, "fire")) {
    const fire = data.fire

    return (
      <>
        <WindUpElement data={fire}/>
        <WindDownElement data={fire}/>
      </>
    )
  } else {
    return <EmptyElement/>
  }
}

export const Cooldown = ({ data }) => {
  return (
    <>
      <CooldownElement data={data}/>
      <FireElement data={data}/>
    </>
  )
}