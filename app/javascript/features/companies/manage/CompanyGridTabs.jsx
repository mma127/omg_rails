import React, { useState } from "react";
import { Tab, Tabs } from "@mui/material";
import { CORE, DISPLAY_CATEGORIES } from "../../../constants/company";

export const CompanyGridTabs = ({ selectedTab, changeCallback }) => {

  const onChange = (e, index) => {
    console.log(`Company grid tab changed to: ${index}`)
    changeCallback(index)
  }

  let tabs = Object.entries(DISPLAY_CATEGORIES).map(([key, displayValue]) => (
    <Tab key={`company-grid-tab-${key}`} label={displayValue} value={key} />
  ))

  return (
    <Tabs value={selectedTab} onChange={onChange}>
      {tabs}
    </Tabs>
  )
}