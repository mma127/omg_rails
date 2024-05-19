import React from 'react'
import _ from "lodash";
import { SinglePreciseElement } from "../elements/SinglePreciseElement";
import { EmptyElement } from "../elements/EmptyElement";

const ACCURACY_MULTIPLIER = 'accuracy_multiplier'
const AccuracyMultiplierElement = ({ data }) => {
  if (_.has(data, ACCURACY_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[ACCURACY_MULTIPLIER]} defaultValue={1} label="target suppressed accuracy multiplier"
                            tooltip="Multiplier on Accuracy when attacking a suppressed target."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const DAMAGE_MULTIPLIER = 'damage_multiplier'
const DamageMultiplierElement = ({ data }) => {
  if (_.has(data, DAMAGE_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[DAMAGE_MULTIPLIER]} defaultValue={1} label="target suppressed damage multiplier"
                            tooltip="Multiplier on Damage when attacking a suppressed target."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const SUPPRESSION_MULTIPLIER = 'suppression_multiplier'
const SuppressionMultiplierElement = ({ data }) => {
  if (_.has(data, SUPPRESSION_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[SUPPRESSION_MULTIPLIER]} defaultValue={1} label="target suppressed suppression multiplier"
                            tooltip="Multiplier on Suppression when attacking a suppressed target."/>
    )
  } else {
    return <EmptyElement/>
  }
}

export const TargetSuppressedMultipliers = ({ data }) => {
  const targetSuppressedMultipliers = data?.target_suppressed_multipliers
  if (_.isNil(targetSuppressedMultipliers)) {
    return null
  } else {
    return (
      <>
        <AccuracyMultiplierElement data={targetSuppressedMultipliers} />
        <DamageMultiplierElement data={targetSuppressedMultipliers} />
        <SuppressionMultiplierElement data={targetSuppressedMultipliers} />
      </>
    )
  }
}
