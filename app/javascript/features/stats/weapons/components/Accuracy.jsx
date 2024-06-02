import React from 'react'
import { DLMSElement } from "../elements/DLMSElement";

export const Accuracy = ({ data }) => {
  return (
    <DLMSElement data={data.accuracy} defaultValue={1} label="accuracy" tooltip="Base accuracy by range band"/>
  )
}
