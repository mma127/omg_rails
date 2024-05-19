import React from 'react'
import { MinMaxElement } from "../elements/MinMaxElement";
import { DLMSElement } from "../elements/DLMSElement";
import { SingleElement } from "../elements/SingleElement";
import { EmptyElement } from "../elements/EmptyElement";
import _ from "lodash";
import { SinglePreciseElement } from "../elements/SinglePreciseElement";
import { TargetSuppressedMultipliers } from "./TargetSuppressedMultipliers";
import { TargetPinnedMultipliers } from "./TargetPinnedMultipliers";

const SUPPRESSED_BURST_MULTIPLIER = 'suppressed_burst_multiplier'
const SuppressedBurstMultiplierElement = ({ data }) => {
  if (_.has(data, SUPPRESSED_BURST_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[SUPPRESSED_BURST_MULTIPLIER]} label="suppressed burst multiplier"
                            tooltip="Burst duration multiplier when the wielder is suppressed."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const SUPPRESSED_COOLDOWN_MULTIPLIER = 'suppressed_cooldown_multiplier'
const SuppressedCooldownMultiplierElement = ({ data }) => {
  if (_.has(data, SUPPRESSED_COOLDOWN_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[SUPPRESSED_COOLDOWN_MULTIPLIER]} label="suppressed cooldown multiplier"
                            tooltip="Cooldown duration multiplier when the wielder is suppressed."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const SUPPRESSED_RELOAD_MULTIPLIER = 'suppressed_reload_multiplier'
const SuppressedReloadMultiplierElement = ({ data }) => {
  if (_.has(data, SUPPRESSED_RELOAD_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[SUPPRESSED_RELOAD_MULTIPLIER]} label="suppressed reload multiplier"
                            tooltip="Reload duration multiplier when the wielder is suppressed."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const PINNED_BURST_MULTIPLIER = 'pinned_burst_multiplier'
const PinnedBurstMultiplierElement = ({ data }) => {
  if (_.has(data, PINNED_BURST_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[PINNED_BURST_MULTIPLIER]} label="pinned burst multiplier"
                            tooltip="Burst duration multiplier when the wielder is pinned."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const PINNED_COOLDOWN_MULTIPLIER = 'pinned_cooldown_multiplier'
const PinnedCooldownMultiplierElement = ({ data }) => {
  if (_.has(data, PINNED_COOLDOWN_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[PINNED_COOLDOWN_MULTIPLIER]} label="pinned cooldown multiplier"
                            tooltip="Cooldown duration multiplier when the wielder is pinned."/>
    )
  } else {
    return <EmptyElement/>
  }
}

const PINNED_RELOAD_MULTIPLIER = 'pinned_reload_multiplier'
const PinnedReloadMultiplierElement = ({ data }) => {
  if (_.has(data, PINNED_RELOAD_MULTIPLIER)) {
    return (
      <SinglePreciseElement data={data[PINNED_RELOAD_MULTIPLIER]} label="pinned reload multiplier"
                            tooltip="Reload duration multiplier when the wielder is pinned."/>
    )
  } else {
    return <EmptyElement/>
  }
}

export const Suppressed = ({ data }) => {
  const suppressed = data?.suppressed

  if (_.isNil(suppressed)) {
    return null
  } else {
    return (
      <>
        <SuppressedBurstMultiplierElement data={suppressed}/>
        <SuppressedCooldownMultiplierElement data={suppressed}/>
        <SuppressedReloadMultiplierElement data={suppressed}/>
        <PinnedBurstMultiplierElement data={suppressed}/>
        <PinnedCooldownMultiplierElement data={suppressed}/>
        <PinnedReloadMultiplierElement data={suppressed}/>
      </>
    )
  }
}
