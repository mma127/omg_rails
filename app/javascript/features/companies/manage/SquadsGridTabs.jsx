import React, { useState } from "react";
import { Tab, Tabs } from "@mui/material";
import { CORE, DISPLAY_CATEGORIES } from "../../../constants/company";

export const SquadsGridTabs = ({ selectedTab, changeCallback }) => {

  const onChange = (e, index) => {
    console.log(`Squads grid tab changed to: ${index}`)
    changeCallback(index)
  }

  let tabs = Object.entries(DISPLAY_CATEGORIES).map(([key, displayValue]) => (
    <Tab key={`squads-grid-tab-${key}`} label={displayValue} value={key} />
  ))

  return (
    <Tabs value={selectedTab} onChange={onChange}>
      {tabs}
    </Tabs>
  )
}