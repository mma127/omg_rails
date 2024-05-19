import React from 'react'
import { MinMaxElement } from "../elements/MinMaxElement";
import { DLMSElement } from "../elements/DLMSElement";
import { SingleElement } from "../elements/SingleElement";
import { EmptyElement } from "../elements/EmptyElement";
import _ from "lodash";
import { SinglePreciseElement } from "../elements/SinglePreciseElement";
import { precise } from "../../../../utils/numbers";

const MAX_LEFT = 'max_left'
const MAX_RIGHT = 'max_right'
const HorizontalTraverseElement = ({ data }) => {
  if (_.has(data, MAX_LEFT) && _.has(data, MAX_RIGHT)) {
    const formattedString = `${precise(data[MAX_LEFT])} - ${precise(data[MAX_RIGHT])}`
    return (
      <SingleElement data={formattedString} label="horizontal traverse"
                     tooltip="Maximum arc the weapon can traverse horizontally."/>
    )
  } else {
    return <EmptyElement />
  }
}

const SPEED_HORIZONTAL = 'speed_horizontal'
const HorizontalSpeedElement = ({ data }) => {
  if (_.has(data, SPEED_HORIZONTAL)) {
    return (
      <SingleElement data={data[SPEED_HORIZONTAL]} label="horizontal traverse speed"
                     tooltip="Speed at which the weapon traverses horizontally."/>
    )
  } else {
    return <EmptyElement />
  }
}

const MAX_UP = 'max_up'
const MAX_DOWN = 'max_down'
const VerticalTraverseElement = ({ data }) => {
  if (_.has(data, MAX_UP) && _.has(data, MAX_DOWN)) {
    const formattedString = `${precise(data[MAX_DOWN])} - ${precise(data[MAX_UP])}`
    return (
      <SingleElement data={formattedString} label="vertical traverse"
                     tooltip="Maximum arc the weapon can traverse vertically."/>
    )
  } else {
    return <EmptyElement />
  }
}

const SPEED_VERTICAL = 'speed_vertical'
const VerticalSpeedElement = ({ data }) => {
  if (_.has(data, SPEED_VERTICAL)) {
    return (
      <SingleElement data={data[SPEED_VERTICAL]} label="vertical traverse speed"
                     tooltip="Speed at which the weapon traverses vertically."/>
    )
  } else {
    return <EmptyElement />
  }
}

export const Tracking = ({ data }) => {
  const tracking = data?.tracking
  if (_.isNil(tracking)) {
    return null
  } else {
    return (
      <>
        <HorizontalTraverseElement data={tracking}/>
        <HorizontalSpeedElement data={tracking}/>
        <VerticalTraverseElement data={tracking}/>
        <VerticalSpeedElement data={tracking}/>
      </>
    )
  }
}
