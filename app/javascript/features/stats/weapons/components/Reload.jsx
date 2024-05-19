import React from "react";
import { MinMaxElement } from "../elements/MinMaxElement";
import { DLMSElement } from "../elements/DLMSElement";
import { EmptyElement } from "../elements/EmptyElement";
import _ from "lodash";


// if (isset($reload['duration'])) {
//   $reloadElement. = buildMinMaxElement($reload, 'duration', 'Reload Duration',
//     'Reload duration at the end of a firing cycle. Can be a range of values.');
const DURATION = 'duration'
const DurationElement = ({ data }) => {
  if (_.has(data, DURATION)) {
    return (
      <MinMaxElement data={data[DURATION]} label="reload duration"
                     tooltip="Reload duration at the end of a firing cycle. Can be a range of values."/>
    )
  } else {
    return null
  }
}

// if (isset($reload['duration_multiplier'])) {
//   $reloadElement. = buildDLMSElement($reload, 'duration_multiplier', 'Reload Duration Multiplier', 1,
//     'Range-based multiplier on Reload Duration. Defaults to 1 if not provided.');
// }
const DURATION_MULTIPLIER = 'duration_multiplier'
const DurationMultiplierElement = ({ data }) => {
  if (_.has(data, DURATION_MULTIPLIER)) {
    return (
      <DLMSElement data={data[DURATION_MULTIPLIER]} defaultValue={1} label="reload duration multiplier"
                   tooltip="Range-based multiplier on Reload Duration. Defaults to 1 if not provided."/>
    )
  } else {
    return <EmptyElement />
  }
}


// if (isset($reload['frequency'])) {
//   $reloadElement. = buildMinMaxElement($reload, 'frequency', 'Reload Frequency',
//     'How many rounds or bursts can be fired before starting a reload cycle. Weapons fire one burst more than their reload frequency.');
// }
const FREQUENCY = 'frequency'
const FrequencyElement = ({ data }) => {
  if (_.has(data, FREQUENCY)) {
    return (
      <MinMaxElement data={data[FREQUENCY]} label="reload frequency"
                     tooltip="How many rounds or bursts can be fired before starting a reload cycle. Weapons fire one burst more than their reload frequency."/>
    )
  } else {
    return <EmptyElement />
  }
}

export const Reload = ({ data }) => {
  if (_.has(data, "reload")) {
    const reload = data.reload

    return (
      <>
        <DurationElement data={reload}/>
        <DurationMultiplierElement data={reload}/>
        <FrequencyElement data={reload}/>
      </>
    )
  } else {
    return <EmptyElement />
  }
}