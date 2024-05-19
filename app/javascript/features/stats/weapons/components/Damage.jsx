import React from 'react'
import { MinMaxElement } from "../elements/MinMaxElement";

export const Damage = ({ data }) => {
  const damage = data.damage

  return (
    <MinMaxElement data={damage} label="damage" tooltip="Damage per round or discrete tick"/>
  )
}
