import React from 'react'
import { MinMaxElement } from "../elements/MinMaxElement";
import { DLMSElement } from "../elements/DLMSElement";
import { SingleElement } from "../elements/SingleElement";
import { EmptyElement } from "../elements/EmptyElement";


const READY_AIM_TIME = 'ready_aim_time'
const ReadyAimTimeElement = ({ data }) => {
  if (_.has(data, READY_AIM_TIME)) {
    return (
      <MinMaxElement data={data[READY_AIM_TIME]} label="ready aim time"
                     tooltip="Delay before the first shot at a new target. Applied every time the weapon changes targets."/>
    )
  } else {
    return <EmptyElement />
  }
}

const FIRE_AIM_TIME = 'fire_aim_time'
const FireAimTimeElement = ({ data }) => {
  if (_.has(data, FIRE_AIM_TIME)) {
    return (
      <MinMaxElement data={data[FIRE_AIM_TIME]} label="fire aim time"
                     tooltip="Delay before each shot, excluding the first shot."/>
    )
  } else {
    return <EmptyElement />
  }
}

const FIRE_AIM_TIME_MULTIPLIER = 'fire_aim_time_multiplier'
const FireAimTimeMultiplierElement = ({ data }) => {
  if (_.has(data, FIRE_AIM_TIME_MULTIPLIER)) {
    return (
      <DLMSElement data={data[FIRE_AIM_TIME_MULTIPLIER]} defaultValue={1} label="fire aim time multiplier"
                   tooltip="Delay before each shot, excluding the first shot."/>
    )
  } else {
    return <EmptyElement />
  }
}

const POST_FIRING_AIM_TIME = 'post_firing_aim_time'
const PostFiringAimTimeElement = ({ data }) => {
  if (_.has(data, POST_FIRING_AIM_TIME)) {
    return (
      <SinglePreciseElement data={data[POST_FIRING_AIM_TIME]} label="post firing aim time"
                     tooltip="Duration that the weapon remains aimed after firing."/>
    )
  } else {
    return <EmptyElement />
  }
}

const POST_FIRING_COOLDOWN = 'post_firing_cooldown'
const PostFiringCooldownTimeElement = ({ data }) => {
  if (_.has(data, POST_FIRING_COOLDOWN)) {
    return (
      <SingleElement data={data[POST_FIRING_COOLDOWN]} label="post firing cooldown"
                     tooltip="Delay after firing before the weapon can be aimed again."/>
    )
  } else {
    return null
  }
}

export const Aim = ({ data }) => {
  const aim = data.aim

  return (
    <>
      <ReadyAimTimeElement data={aim}/>
      <FireAimTimeElement data={aim}/>
      <FireAimTimeMultiplierElement data={aim}/>
      <PostFiringAimTimeElement data={aim}/>
      <PostFiringCooldownTimeElement data={aim}/>
    </>
  )
}
