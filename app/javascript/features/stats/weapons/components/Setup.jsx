import React from 'react'
import { MinMaxElement } from "../elements/MinMaxElement";
import { DLMSElement } from "../elements/DLMSElement";
import { SingleElement } from "../elements/SingleElement";
import { EmptyElement } from "../elements/EmptyElement";
import _ from "lodash";
import { SinglePreciseElement } from "../elements/SinglePreciseElement";

const SetupDurationElement = ({ data }) => {
  if (!_.isNil(data)) {
    return (
      <SinglePreciseElement data={data} label="setup duration"
                     tooltip="Time required to set up the weapon before it can be aimed and fired."/>
    )
  } else {
    return <EmptyElement />
  }
}

export const Setup = ({ data }) => {
  const setupDuration = data?.setup_duration
  if (_.isNil(setupDuration)) {
    return null
  } else {
    return (
      <>
        <SetupDurationElement data={setupDuration}/>
      </>
    )
  }
}
