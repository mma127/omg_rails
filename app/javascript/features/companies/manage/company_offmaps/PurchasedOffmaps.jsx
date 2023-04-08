import React from 'react'
import { useDispatch, useSelector } from "react-redux";
import {
  removeExistingCompanyOffmap,
  removeNewCompanyOffmap,
  selectAllCompanyOffmaps,
  selectNewCompanyOffmaps
} from "./companyOffmapsSlice";
import { Box } from "@mui/material";
import { PurchasedOffmapClickable } from "./PurchasedOffmapClickable";
import { makeStyles } from "@mui/styles";
import { nanoid } from "@reduxjs/toolkit";

const useStyles = makeStyles(() => ({
  wrapper: {
    display: 'flex'
  }
}))
export const PurchasedOffmaps = ({ onDeleteClick, enabled }) => {
  const classes = useStyles()
  const existingCompanyOffmaps = useSelector(selectAllCompanyOffmaps)
  const newCompanyOffmaps = useSelector(selectNewCompanyOffmaps)
  const offmapsByAvailableOffmapId = {}
  Object.entries(newCompanyOffmaps).forEach(([key, value]) => {
    offmapsByAvailableOffmapId[key] = [...value]
  })

  existingCompanyOffmaps.forEach(eco => {
    const availableOffmapId = eco.availableOffmapId
    if (_.has(offmapsByAvailableOffmapId, availableOffmapId)) {
      offmapsByAvailableOffmapId[availableOffmapId].push(eco)
    } else {
      offmapsByAvailableOffmapId[availableOffmapId] = [eco]
    }
  })

  const flatCompanyOffmaps = _.values(offmapsByAvailableOffmapId).flat()

  return (
    <Box className={classes.wrapper}>
      {flatCompanyOffmaps.map(nco => <PurchasedOffmapClickable companyOffmap={nco}
                                                               onOffmapClick={onDeleteClick}
                                                               enabled={enabled}
                                                               key={nanoid()} />)}
    </Box>
  )
}