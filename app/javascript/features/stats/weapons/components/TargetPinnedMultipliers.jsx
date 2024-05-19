import React from 'react'
import _ from "lodash";
import { SinglePreciseElement } from "../elements/SinglePreciseElement";
import { EmptyElement } from "../elements/EmptyElement";

const ACCURACY_MULTIPLIER = 'accuracy_multiplier'
const AccuracyMultiplierElement = ({ data }) => {
  if (_.has(data, ACCURACY_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[ACCURACY_MULTIPLIER]} defaultValue={1} label="target pinned accuracy multiplier"
                            tooltip="Multiplier on Accuracy when attacking a pinned target."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const DAMAGE_MULTIPLIER = 'damage_multiplier'
const DamageMultiplierElement = ({ data }) => {
  if (_.has(data, DAMAGE_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[DAMAGE_MULTIPLIER]} defaultValue={1} label="target pinned damage multiplier"
                            tooltip="Multiplier on Damage when attacking a pinned target."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const SUPPRESSION_MULTIPLIER = 'suppression_multiplier'
const SuppressionMultiplierElement = ({ data }) => {
  if (_.has(data, SUPPRESSION_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[SUPPRESSION_MULTIPLIER]} defaultValue={1} label="target pinned suppression multiplier"
                            tooltip="Multiplier on Suppression when attacking a pinned target."/>
    )
  } else {
    return <EmptyElement/>
  }
}

export const TargetPinnedMultipliers = ({ data }) => {
  const targetPinnedMultipliers = data?.target_pinned_multipliers
  if (_.isNil(targetPinnedMultipliers)) {
    return null
  } else {
    return (
      <>
        <AccuracyMultiplierElement data={targetPinnedMultipliers} />
        <DamageMultiplierElement data={targetPinnedMultipliers} />
        <SuppressionMultiplierElement data={targetPinnedMultipliers} />
      </>
    )
  }
}
