import React from 'react'
import { MinMaxElement } from "../elements/MinMaxElement";
import { DLMSElement } from "../elements/DLMSElement";
import { SingleElement } from "../elements/SingleElement";
import { EmptyElement } from "../elements/EmptyElement";
import _ from "lodash";
import { SinglePreciseElement } from "../elements/SinglePreciseElement";

const ANGLE_SCATTER = 'angle_scatter'
const AngleScatterElement = ({ data }) => {
  if (_.has(data, ANGLE_SCATTER)) {
    return (
      <SinglePreciseElement data={data[ANGLE_SCATTER]} label="scatter angle"
                     tooltip="Degree of possible scatter when a projectile weapon misses its target."/>
    )
  } else {
    return <EmptyElement />
  }
}

const MAX_SCATTER_DISTANCE = 'distance_scatter_max'
const MaxScatterDistanceElement = ({ data }) => {
  if (_.has(data, MAX_SCATTER_DISTANCE)) {
    return (
      <SinglePreciseElement data={data[MAX_SCATTER_DISTANCE]} label="max scatter distance"
                     tooltip="Max scatter distance around the intended target."/>
    )
  } else {
    return <EmptyElement />
  }
}

const SCATTER_DISTANCE_OFFSET = 'distance_scatter_offset'
const ScatterDistanceOffsetElement = ({ data }) => {
  if (_.has(data, SCATTER_DISTANCE_OFFSET)) {
    return (
      <SinglePreciseElement data={data[SCATTER_DISTANCE_OFFSET]} label="scatter offset"
                            tooltip="Determines whether the scatter will tend to land on the near or far side of the intended target.
  Between -1 and 1, values < 0 will tend to scatter closer to the firer, while values > 0 will tend to scatter
  on the far side of the target. Most weapons have offsets > 0."/>
    )
  } else {
    return <EmptyElement />
  }
}

const SCATTER_DISTANCE_RATIO = 'distance_scatter_ratio'
const ScatterDistanceRatioElement = ({ data }) => {
  if (_.has(data, SCATTER_DISTANCE_RATIO)) {
    return (
      <SinglePreciseElement data={data[SCATTER_DISTANCE_RATIO]} label="scatter ratio"
                            tooltip="How often the weapon will scatter away from the intended target. A value of 0 means it will never scatter
  away from the intended target, while a value of 1 means it will always scatter."/>
    )
  } else {
    return <EmptyElement />
  }
}

const FOW_ANGLE_MULTIPLIER = 'fow_angle_multiplier'
const FowAngleMultiplierElement = ({ data }) => {
  if (_.has(data, FOW_ANGLE_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[FOW_ANGLE_MULTIPLIER]} label="fow scatter angle multiplier"
                            tooltip="Multiplier on scatter angle when firing into the fog of war."/>
    )
  } else {
    return <EmptyElement />
  }
}

const FOW_DISTANCE_MULTIPLIER = 'fow_distance_multiplier'
const FowDistanceMultiplierElement = ({ data }) => {
  if (_.has(data, FOW_DISTANCE_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[FOW_DISTANCE_MULTIPLIER]} label="fow scatter distance multiplier"
                            tooltip="Multiplier on scatter distance when firing into the fog of war."/>
    )
  } else {
    return <EmptyElement />
  }
}

export const Scatter = ({ data }) => {
  const scatter = data?.scatter
  if (_.isNil(scatter)) {
    return null
  } else {
    return (
      <>
        <AngleScatterElement data={scatter}/>
        <MaxScatterDistanceElement data={scatter}/>
        <ScatterDistanceOffsetElement data={scatter}/>
        <ScatterDistanceRatioElement data={scatter}/>
        <FowAngleMultiplierElement data={scatter}/>
        <FowDistanceMultiplierElement data={scatter}/>
      </>
    )
  }
}
